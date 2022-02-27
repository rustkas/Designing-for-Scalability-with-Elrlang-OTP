-module(ping).
-behaviour(gen_server).

-export([start/0,stop/0]).
-export([run_start/0, run_pause/0]).
-export([init/1, handle_call/3, handle_info/2, handle_cast/2]).
-define(TIMEOUT, 5000).

start() ->
	gen_server:start({local, ping}, ping, [], []).

stop() ->
    gen_server:cast(?MODULE, stop).

run_start() ->
	gen_server:call(ping, start).
	
run_pause() ->
	gen_server:call(ping, pause).
	
init(_Args) ->
    {ok, undefined, ?TIMEOUT}.

handle_call(start, From, LoopData) ->
	io:format("Handle call start: From: ~p, LoopData: ~p~n",[From,LoopData]),
    {reply, started, LoopData, ?TIMEOUT};
handle_call(pause, From, LoopData) ->
	io:format("Handle call pause: From: ~p, LoopData: ~p~n",[From,LoopData]),
    {reply, paused, LoopData}.

handle_cast(stop, LoopData) ->
	io:format("Handle cast stop: LoopData: ~p~n",[LoopData]),
    {stop, normal, LoopData}.		


handle_info(timeout, LoopData) ->
    {_Hour,_Min,Sec} = time(),
    io:format("Handle info: ~2.w~n",[Sec]),
    {noreply, LoopData, ?TIMEOUT}.
