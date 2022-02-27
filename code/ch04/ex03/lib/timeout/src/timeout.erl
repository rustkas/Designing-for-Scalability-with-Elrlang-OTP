-module(timeout).
-behaviour(gen_server).

-export([start/0, stop/0]).
-export([sleep/1]).
-export([init/1, handle_call/3, handle_cast/2]).

start() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

stop() ->
    gen_server:cast(?MODULE, stop).

sleep(Ms) -> 
	gen_server:call(timeout, {sleep, Ms}).

init(_Args) ->
    {ok, undefined}.

handle_call({sleep, Ms}, _From, LoopData) ->
    timer:sleep(Ms),
    {reply, ok, LoopData}.

handle_cast({sleep, _Ms}, LoopData) ->
	{noreply, LoopData};
handle_cast(stop, LoopData) ->
    {stop, normal, LoopData}.		