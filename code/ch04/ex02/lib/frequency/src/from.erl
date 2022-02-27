-module(from).
-behaviour(gen_server).
-export([start/0, stop/0, add/1]).
-export([init/1, handle_call/3, handle_cast/2, terminate/2]).

start() ->
	process_flag(trap_exit, true),
	gen_server:start_link({local, from}, from, 0, []).

stop() ->
    gen_server:cast(from, stop).

add(Value) ->
	gen_server:call(from, {add, Value}).

init(Sum) ->
    {ok, Sum}.

handle_call({add, Data}, From, Sum) ->
    gen_server:reply(From, ok),
    timer:sleep(1000),
    NewSum = add(Data, Sum/0),
    io:format("From:~p, Sum:~p~n",[From, NewSum]),
    {noreply, NewSum}.

handle_cast({add, Data}, Sum) ->
    NewSum = add(Data, Sum),
	{noreply, NewSum};

handle_cast(stop, LoopData) ->
    {stop, normal, LoopData}.	

terminate(Reason, LoopData) ->
	io:format("Server stopped. Reason:~p, Sum:~p~n",[Reason, LoopData]),
    ok.
	
add(Data, Sum) ->
    Data + Sum.	