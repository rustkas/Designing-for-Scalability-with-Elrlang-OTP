%%% @copyright (c) 2013,2016 Francesco Cesarini
-module(phone_fsm_statem).
%-behaviour(gen_fsm).
-behaviour(gen_statem).

-export([start_link/1]).

-export([init/1, callback_mode/0, terminate/3]).

-export([inbound/1, action/3, busy/1, reject/1, accept/1, hangup/1]).

-export([idle/3, calling/3, connected/3, receiving/3]).

start_link(Ms) ->
%    gen_fsm:start_link(?MODULE, Ms, [{debug, [trace]}]).
%%    gen_fsm:start_link(?MODULE, Ms, []).

	gen_statem:start_link(?MODULE, Ms, [{debug, [trace]}]).
	%gen_statem:start_link(?MODULE, Ms, []).

init(Ms) ->
    process_flag(trap_exit, true),
    hlr:attach(Ms),
    {ok, idle, Ms}.

callback_mode() ->
	%state_timeout.
    state_functions.


terminate(_Reason, idle, _Ms) ->
    hlr:detach();
terminate(_Reason, calling, {_Ms, CallingMsId}) ->
    phone_fsm_statem:hangup(CallingMsId),
    hlr:detach();
terminate(_Reason, connected, {_Ms, OtherMsId, _Freq}) ->
    %% We hang up, We initated call
    phone_fsm_statem:hangup(OtherMsId),
    hlr:detach();
terminate(_Reason, receiving, {_Ms, FromMsId}) ->
    phone_fsm_statem:reject(FromMsId),
    hlr:detach().

%% Events from the Phone
action(cast, {outbound, ToMs}, MsId) ->
    %gen_fsm:sync_send_all_state_event(MsId, {outbound, ToMs});
	handle_call(MsId, {outbound, ToMs});
action(cast, Action, MsId) ->  %Action == hangup, reject, accept
    %gen_fsm:send_event(MsId, {action,Action}).
	gen_statem:cast(?MODULE, MsId, {action,Action});
action({call, From}, Msg, Data) ->    
    handle_call(From, Msg, Data).


busy(ToMsId) ->
    %gen_fsm:send_event(ToMsId, {busy, self()}).
	gen_statem:cast(?MODULE, ToMsId, {busy, self()}).
	
reject(ToMsId) ->
    %gen_fsm:send_event(ToMsId, {reject, self()}).
	gen_statem:cast(?MODULE, ToMsId, {reject, self()}).
accept(ToMsId) ->
    %gen_fsm:send_event(ToMsId, {accept, self()}).
	gen_statem:cast(?MODULE, ToMsId, {accept, self()}).
hangup(ToMsId) ->
    %gen_fsm:send_event(ToMsId, {hangup, self()}).
	gen_statem:cast(?MODULE, ToMsId, {hangup, self()}).
inbound(ToMsId) ->
    %gen_fsm:send_event(ToMsId, {inbound, self()}).
	gen_statem:cast(?MODULE, ToMsId, {inbound, self()}).
	
%%--------------------------------------------------------------------
%%--------------------------------------------------------------------

%% Event outbound in state idle is synchronous and handled in
%% handle_sync_event

idle(cast, {inbound, FromMsId}, Ms) ->
    phone:reply(inbound, FromMsId, Ms),
    {next_state, receiving, {Ms, FromMsId}};
idle(cast, _Ignore, State) ->  % , hangup, reject, accept
    io:format("~p in idle, ignored. State:~w, Event:~w~n",[self(), State, _Ignore]),
    {next_state, idle, State};
idle({call, From}, Msg, Data) ->    
    handle_call(From, Msg, Data).

%% Beware of race conditions. This event could be received right after
%% the other party accepts, meaning we would handle it not here but in state
%% connected.

calling(cast, {action, hangup}, {Ms, CallingMsId}) ->
    phone_fsm:hangup(CallingMsId),
    {next_state, idle, Ms};
calling(cast, {busy, Pid}, {Ms, Pid}) ->
    phone:reply(busy, Pid, Ms),
    {next_state, idle, Ms};
calling(cast, {reject, Pid}, {Ms, Pid}) ->
    phone:reply(rejected, Pid, Ms),
    {next_state, idle, Ms};
calling(cast, {accept, Pid}, {Ms, Pid}) ->
    case frequency:allocate() of
	{error, no_frequency} ->
	    phone_fsm:reject(Pid),
	    phone:reply(no_frequency, Pid, Ms),
	    {next_state, idle, Ms};
	{ok, Freq} ->
	    phone:reply(connected, Pid, Ms),
	    {next_state, connected, {Ms, Pid, Freq}}
    end;
calling(cast, {inbound, Pid}, State) ->
    phone_fsm:busy(Pid),
    {next_state, calling, State};
calling(cast, _Ignore, State) ->  % {action, reject}, {action, accept}
    io:format("In calling, ignored. State:~w, Event:~w~n",[State, _Ignore]),
    {next_state, calling, State};
calling({call, From}, Msg, Data) ->    
    handle_call(From, Msg, Data).	

connected(cast, {inbound, FromMsId}, State) ->
    phone_fsm:busy(FromMsId),
    {next_state, connected, State};
connected(cast, {action, hangup}, {Ms, OtherMsId, Freq}) -> %% We hang up, We initated call
    phone_fsm:hangup(OtherMsId),
    frequency:deallocate(Freq),
    {next_state, idle, Ms};
connected(cast, {action, hangup}, {Ms, OtherMsId}) -> %% We hang up, Other initated call
    phone_fsm:hangup(OtherMsId),
    {next_state, idle, Ms};
connected(cast, {hangup, OtherMsId}, {Ms, OtherMsId}) -> %% they hang Up
    phone:reply(hangup, OtherMsId, Ms),
    {next_state, idle, Ms};
connected(cast, {hangup, OtherMsId}, {Ms, OtherMsId, Freq}) -> %% they hang Up
    phone:reply(hangup, OtherMsId, Ms),
    frequency:deallocate(Freq),
    {next_state, idle, Ms};
connected(cast, _Ignore, State) ->
    io:format("In connected, ignored. State:~w, Event:~w~n",[State, _Ignore]),
    {next_state, connected, State};
connected({call, From}, Msg, Data) ->    
    handle_call(From, Msg, Data).	


receiving(cast, {action, accept}, {Ms, FromMsId}) ->
    phone_fsm:accept(FromMsId),
    {next_state, connected, {Ms, FromMsId}};
receiving(cast, {action, reject}, {Ms, FromMsId}) ->
    phone_fsm:reject(FromMsId),
    {next_state, idle, Ms};
receiving(cast, {hangup, FromMsId}, {Ms, FromMsId}) ->
    phone:reply(hangup, FromMsId, Ms),
    {next_state, idle, Ms};
receiving(cast, {inbound, FromMsId}, State) ->  %Others
    phone_fsm:busy(FromMsId),
    {next_state, receiving, State};
receiving(cast, _Ignore, State) ->  % {action, hangup}
    io:format("In receiving, ignored. State:~w, Event:~w~n",[State, _Ignore]),
    {next_state, receiving, State};
receiving({call, From}, Msg, Data) ->    
    handle_call(From, Msg, Data).


%handle_sync_event({outbound, ToMs}, _From, idle, Ms) ->
%    case hlr:lookup_id(ToMs) of
%		{error, invalid} ->
%			io:format("ERROR, INVALID~n"),
%			phone:reply(invalid, ToMs, Ms),
%			{reply, {error, invalid}, idle, Ms};
%		{ok, ToMsId} when is_pid(ToMsId) ->
%			phone:reply(outbound, ToMs, Ms),
%			phone_fsm:inbound(ToMsId),
%			{reply, ok, calling, {Ms, ToMsId}}
%    end;
%handle_sync_event({outbound, _ToMSISDN}, _From, State, MSISDN) ->
%    {reply, {error, busy}, State, MSISDN}.


%% Internal functions
handle_call(From, stop, Data) ->
     {stop_and_reply, normal,  {reply, From, ok}, Data}.
	 
handle_call(Ms, {outbound, ToMs}) ->
    case hlr:lookup_id(ToMs) of
		{error, invalid} ->
			io:format("ERROR, INVALID~n"),
			phone:reply(invalid, ToMs, Ms),
			{reply, {error, invalid}, idle, Ms};
		{ok, ToMsId} when is_pid(ToMsId) ->
			phone:reply(outbound, ToMs, Ms),
			phone_fsm:inbound(ToMsId),
			{reply, ok, calling, {Ms, ToMsId}}
    end.	 
	 