-module(echo_link).

-export([go/0, loop/0]).

go() ->
	%io:format("Shell PID = ~p~n",[self()]),
    Pid = spawn_link(echo_link, loop, []),
    Pid ! {self(), hello},
    receive
	{Pid, Msg} ->
	    io:format("New message: ~w~n",[Msg])
    end,
    Pid ! stop.
	%io:format("Shell PID = ~p~n",[self()]).

loop() ->
    receive
	{From, Msg} ->
	    From ! {self(), Msg},
	    loop();
	stop ->
	    ok
    end.
