-module(coffee_fsm_timeout).
%-behaviour(gen_fsm).
-behaviour(gen_statem).

-export([start_link/0]).
-export([init/1, callback_mode/0, stop/0,terminate/3]). % Функции обратного вызова
-export([selection/3, payment/3, remove/3]). % Состояния
-export([americano/0, cappuccino/0, tea/0, espresso/0, pay/1, cancel/0, cup_removed/0]). % Клиентские функции

-define(TIMEOUT, 10000).


start_link() ->
    gen_statem:start_link({local, ?MODULE}, ?MODULE, [], []).
	
init([]) -> 
    hw:reboot(),
    hw:display("Make Your Selection", []),
    process_flag(trap_exit, true),
    {ok, selection, []}.


callback_mode() ->
	%state_timeout.
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

%% State: drink selection
selection(cast, {selection, Type, Price}, _LoopData) ->
  hw:display("Please pay:~w",[Price]),
  {next_state, payment, {Type, Price, 0}, [{state_timeout, ?TIMEOUT, reset}]};
selection(cast, {pay, Coin}, LoopData) ->
  hw:return_change(Coin),
  {next_state, selection, LoopData};
selection(cast, _Other, LoopData) ->  
  {next_state, selection, LoopData};
selection({call, From}, Msg, LoopData) ->  
    handle_call(From, Msg, LoopData). 
  

payment(cast,{pay, Coin}, {Type,Price,Paid}) 
                when Coin+Paid < Price ->
    NewPaid = Coin + Paid,
    hw:display("Please pay: ~w",[Price - NewPaid]),
	{next_state, payment, {Type, Price, NewPaid}, [{state_timeout, ?TIMEOUT, reset}]};
payment(state_timeout, reset, {_Type, _Price, Paid}) ->
	hw:display("Make Your Selection", []),
	hw:return_change(Paid),
	{next_state, selection, []};	
payment(cast,{pay, Coin}, {Type, Price, Paid}) 
                when Coin + Paid >= Price ->
    NewPaid = Coin + Paid,
    hw:display("Preparing Drink.", []),
    hw:return_change(NewPaid - Price),
    hw:drop_cup(), 
	hw:prepare(Type),
    hw:display("Remove Drink.", []),
    {next_state, remove, []};
payment(cast,cancel, {_Type, _Price, Paid}) ->
    hw:display("Make Your Selection", []),
    hw:return_change(Paid),
    {next_state, selection, []};
payment(cast,_Other, LoopData) ->
    {next_state, payment, LoopData, [{state_timeout, ?TIMEOUT, reset}]};
payment({call, From}, Msg, LoopData) ->  
  handle_call(From, Msg, LoopData).

%% State: remove cup

remove(cast, cup_removed, LoopData) ->
    hw:display("Make Your Selection", []),
    {next_state, selection, LoopData};
remove(cast, {pay, Coin}, LoopData) ->
    hw:return_change(Coin),
    {next_state, remove, LoopData};
remove(cast, _Other, _LoopData) ->          
    keep_state_and_data;
remove({call, From}, Msg, LoopData) ->  
  handle_call(From, Msg, LoopData).
	
stop() ->
    gen_statem:call(?MODULE, stop).

terminate(_Reason, payment, {_Type,_Price,Paid}) ->
	hw:return_change(Paid);	
terminate(_Reason, _State, _Data) -> 
	io:format("Terminated~n",[]).
	

%% Internal functions
handle_call(From, stop, Data) ->
     {stop_and_reply, normal,  {reply, From, ok}, Data}.