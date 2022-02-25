ex09
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> c(addr).
{ok,addr}
2> addr:type("127.0.0.1").
inet
3> addr:type("::1").
inet6
2> addr:type2("127.0.0.1").
inet
3> addr:type2("::1").
inet6
```

```
addr:hostent(inet:gethostbyaddr("127.0.0.1")).
{hostent,{ok,{hostent,"192.150.14.69",
                      ["192.150.18.101","192.150.18.108","192.150.22.40",
                       "192.150.8.100","192.150.8.118",
                       "209-34-83-73.ood.opsource.net","3dns-1.adobe.com",
                       "3dns-2.adobe.com"],
                      inet,4,
                      [{127,0,0,1}]}},
         [],inet,4,
         {error,einval}}
```

```
1> inet:gethostbyname("oreilly.com").
{ok,{hostent,"oreilly.com",[],inet,4,
[{208,201,239,101},{208,201,239,100}]}}
2> rr(inet).
[connect_opts,hostent,listen_opts,sctp_adaptation_event,
 sctp_assoc_change,sctp_assoc_value,sctp_assocparams,
 sctp_event_subscribe,sctp_initmsg,sctp_opts,
 sctp_paddr_change,sctp_paddrinfo,sctp_paddrparams,
 sctp_pdapi_event,sctp_prim,sctp_remote_error,sctp_rtoinfo,
 sctp_send_failed,sctp_setadaptation,sctp_setpeerprim,
 sctp_shutdown_event,sctp_sndrcvinfo,sctp_status,udp_opts]
3> inet:gethostbyname("oreilly.com").
{ok,#hostent{h_name = "oreilly.com",h_aliases = [],
h_addrtype = inet,h_length = 4,
h_addr_list = [{208,201,239,101},{208,201,239,100}]}}
```

inets
====
```
1>inets:services().
[{httpc,<0.112.0>},{httpc,<0.109.0>}]
2>inets:service_names().
[httpc,httpd]
```

httpc
=====
```
15> httpc:info().
[{handlers,[]},
 {sessions,{[],[],[]}},
 {options,[{proxy,{undefined,[]}},
           {https_proxy,{undefined,[]}},
           {pipeline_timeout,0},
           {max_pipeline_length,2},
           {max_keep_alive_length,5},
           {keep_alive_timeout,120000},
           {max_sessions,2},
           {cookies,disabled},
           {verbose,false},
           {ipfamily,inet},
           {ip,default},
           {port,default},
           {socket_opts,[]},
           {unix_socket,undefined}]},
 {cookies,[{session_cookies,[]}]}]

> httpc:request("127.0.0.1"). 
{error,{no_scheme}}

> httpc:which_cookies().
[{session_cookies,[]}]
```