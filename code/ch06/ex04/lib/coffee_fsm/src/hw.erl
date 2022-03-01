-module(hw).

-export([display/2, return_change/1, drop_cup/0, prepare/1, reboot/0]).

display(Str, Arg)      -> io:format("Display: " ++ Str ++ "~n", Arg).

return_change(Payment) -> case Payment > 0 of 
							true -> 
								io:format("Machine: Returned ~w in change~n",[Payment]);
							false -> ok
						  end.

drop_cup()             -> io:format("Machine: Dropped Cup.~n").

prepare(Type)          -> io:format("Machine: Preparing ~tp.~n",[[Type]]).

reboot()               -> io:format("Machine: Rebooted Hardware~n").
