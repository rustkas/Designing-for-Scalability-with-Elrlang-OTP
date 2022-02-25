-module(addr).
-export([type/1]).
-export([type2/1]).
-export([hostent/1]).


-include_lib("kernel/include/inet.hrl").

type(Addr) ->
    {ok, HostEnt} = inet:gethostbyaddr(Addr),
    HostEnt#hostent.h_addrtype.

type2(Addr) ->
	{ok, #hostent{h_addrtype=AddrType}} = inet:gethostbyaddr(Addr),
	AddrType.
	
hostent(Host) ->
	#hostent{h_name=Host, h_addrtype=inet, h_length=4,
		h_addr_list=inet:getaddrs(Host, inet)}.	