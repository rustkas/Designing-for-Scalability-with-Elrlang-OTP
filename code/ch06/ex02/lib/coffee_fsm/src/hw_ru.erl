-module(hw_ru).

-export([display/2, return_change/1, drop_cup/0, prepare/1, reboot/0]).

display(Str, Arg) -> io:format("Дисплей:" ++ Str ++ "~n", Arg).

return_change(Payment) -> io:format("Машина:Вернула­~w сдачи~n",[Payment]).

drop_cup() -> io:format("Машина:Выбросила­стаканчик.~n").

prepare(Type) -> io:format("Машина:Готовит­~p.~n",[Type]).

reboot() -> io:format("Машина:Перезагружена~n").