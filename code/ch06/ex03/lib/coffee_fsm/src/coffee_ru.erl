-module(coffee_ru).

-export([tea/0, espresso/0, americano/0, cappuccino/0, pay/1, cup_removed/0, cancel/0]).
-export([start_link/0, init/0]).

start_link() ->
	{ok, spawn_link(?MODULE, init, [])}.
	
init() ->
	register(?MODULE, self()),
	hw_ru:reboot(),
	hw_ru:display("Выберите­напиток", []), 
	selection().
	
%% Клиентские функции для выбора напитка

tea() -> ?MODULE ! {selection, tea, 100}.
espresso() -> ?MODULE ! {selection, espresso, 150}.
americano() -> ?MODULE ! {selection, americano, 100}.
cappuccino() -> ?MODULE ! {selection, cappuccino,150}.

%% Клиентские функции для действий

pay(Coin) -> ?MODULE ! {pay, Coin}.
cup_removed() -> ?MODULE ! cup_removed.
cancel() -> ?MODULE ! cancel.

%% Состояние: selection (выбор напитка)
selection() ->
	receive
		{selection, Type, Price} ->
			hw_ru:display("Пожалуйста,­оплатите:~w",[Price]),
			payment(Type, Price, 0);
		{pay, Coin} -> hw_ru:return_change(Coin), selection();
			_Other -> % отмена
			selection()
	end.


%% Состояние: оплата

payment(Type, Price, Paid) ->
	receive
		{pay, Coin} ->
			if
				Coin + Paid >= Price ->
					hw_ru:display("Готовится­напиток.",[]),
					hw_ru:return_change(Coin + Paid - Price),
					hw:drop_cup(),
					hw:prepare(Type),
					hw:display("Заберите­стаканчик.", []),
					remove();
				true ->
					ToPay = Price - (Coin + Paid),
					hw:display("Пожалуйста,­оплатите:~w",[ToPay]),
					payment(Type, Price, Coin + Paid)
			end;
		cancel ->
			hw:display("Выберите­напиток", []),
			hw:return_change(Paid), 
			selection();
		_Other -> % выбор
			payment(Type, Price, Paid)
	end.
	
%% Состояние: заберите стаканчик

remove() ->
	receive
		cup_removed ->
			hw:display("Выберите напиток", []),
			selection();
		{pay, Coin} ->
			hw:return_change(Coin),
			remove();
		_Other -> % отмена/выбор напитка
			remove()
	end.	