-module(server).
-export([start/2, stop/1, call/2]).
-export([init/2]).

start(Name, Args) ->
    register(Name, spawn(server, init, [Name, Args])).

stop(Name) ->
	Ref = make_ref(),
    Name ! {stop, {Ref, self()}},
    receive {reply, Ref, Reply} -> Reply end.

init(Mod, Args) ->
    State = Mod:init(Args),
    loop(Mod, State).


call(Name, Msg) ->
	Ref = make_ref(),
    Name ! {request, {Ref, self()}, Msg},
    receive {reply, Ref, Reply} -> Reply end.

reply({Ref, To}, Reply) ->
    To ! {reply, Ref, Reply}.

loop(Mod, State) ->
    receive
	{request, From, Msg} ->
	    {NewState, Reply} = Mod:handle(Msg, State),
	    reply(From, Reply),
	    loop(Mod, NewState);
	{stop, From}  ->
	    Reply = Mod:terminate(State),
	    reply(From, Reply)
    end.
