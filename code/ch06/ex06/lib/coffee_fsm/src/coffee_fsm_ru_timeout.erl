-module(coffee_fsm_ru_timeout).
%-behaviour(gen_fsm).
-behaviour(gen_statem).

-export([start_link/0]).
-export([init/1, callback_mode/0, stop/0]). % Функции обратного вызова
-export([selection/3, payment/3, remove/3]). % Состояния
-export([americano/0, cappuccino/0, tea/0, espresso/0, pay/1, cancel/0, cup_removed/0]). % Клиентские функции

-define(TIMEOUT, 10000).

start_link() ->
    gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).
	
init([]) -> 
    hw_ru:reboot(),
    hw_ru:display("Выберите напиток", []),
    process_flag(trap_exit, true),
    {ok, selection, []}.


callback_mode() ->
    state_functions.

%% Client Functions for Drink Selections

tea() ->  
	% gen_fsm:send_event(?MODULE, {selection,tea,100}).   
	gen_statem:cast(?MODULE, {selection, tea, 100}).
	
espresso() ->
	% gen_fsm:send_event(?MODULE, {selection,espresso,150}).
	gen_statem:cast(?MODULE, {selection, espresso, 150}).
	
americano() -> 
	% gen_fsm:send_event(?MODULE, {selection,americano,150}).   
	gen_statem:cast(?MODULE, {selection, americano, 150}).

cappuccino() -> 
	% gen_fsm:send_event(?MODULE,{selection,cappuccino,150}).
	gen_statem:cast(?MODULE, {selection, cappuccino, 150}).

%% Client Functions for Actions
pay(Coin)     -> 
	% gen_fsm:send_event(?MODULE, {pay, Coin}).
	gen_statem:cast(?MODULE, {pay, Coin}).
	
cancel()      -> 
	% gen_fsm:send_event(?MODULE, cancel).
	gen_statem:cast(?MODULE, cancel).
	
cup_removed() -> 
	% gen_fsm:send_event(?MODULE, cup_removed).
	gen_statem:cast(?MODULE, cup_removed).

%% Состояние: выбор напитка
selection(cast,{selection, Type, Price}, _LoopData) ->
  hw_ru:display("Пожалуйста, оплатите: ~w", [Price]),
  {next_state, payment, {Type, Price, 0}, [{state_timeout, ?TIMEOUT, reset}]};
selection(cast,{pay, Coin}, LoopData) ->
  hw_ru:return_change(Coin),
  {next_state, selection, LoopData};
selection(cast,_Other, LoopData) ->  
  {next_state, selection, LoopData}.


payment(cast,{pay, Coin}, {Type,Price,Paid}) 
                when Coin+Paid < Price ->
    NewPaid = Coin + Paid,
    hw_ru:display("Пожалуйста, оплатите: ~w",[Price - NewPaid]),
    {next_state, payment, {Type, Price, NewPaid}, [{state_timeout, ?TIMEOUT, reset}]};
payment(state_timeout, reset, {_Type, _Price, Paid}) ->
	hw:display("Выбирете напиток", []),
	hw:return_change(Paid),
	{next_state, selection, []};	
payment(cast,{pay, Coin}, {Type, Price, Paid}) 
                when Coin + Paid >= Price ->
    NewPaid = Coin + Paid,
    hw_ru:display("Готовиться напиток.", []),
    hw_ru:return_change(NewPaid - Price),
    hw_ru:drop_cup(), 
	hw_ru:prepare(Type),
    hw_ru:display("Заберите стаканчик.", []),
    {next_state, remove, []};
payment(cast, cancel, {_Type, _Price, Paid}) ->
    hw_ru:display("Выбирете напиток", []),
    hw_ru:return_change(Paid),
    {next_state, selection, []};
payment(cast, _Other, LoopData) ->
    {next_state, payment, LoopData, [{state_timeout, ?TIMEOUT, reset}]}.

%% State: remove cup

remove(cast, cup_removed, LoopData) ->
    hw_ru:display("Выбирете напиток", []),
    {next_state, selection, LoopData};
remove(cast,{pay, Coin}, LoopData) ->
    hw_ru:return_change(Coin),
    {next_state, remove, LoopData};
remove(cast,_Other, LoopData) ->          
    {next_state, remove, LoopData}.

stop() ->
	gen_statem:call(?MODULE, stop).