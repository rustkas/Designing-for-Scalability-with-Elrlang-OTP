ex03
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> gen_server:start_link({local, timeout}, timeout, [], []).
{ok,<0.66.0>}
2> gen_server:call(timeout, {sleep, 1000}).
ok
3> catch gen_server:call(timeout, {sleep, 5001}).
{'EXIT',{timeout,{gen_server,call,[timeout,{sleep,5001}]}}}
4> flush().
Shell got {#Ref<0.0.0.300>,ok}
5> gen_server:call(timeout, {sleep, 5001}).
** exception exit: {timeout,{gen_server,call,[timeout,{sleep,5001}]}}
in function gen_server:call/2
6> catch gen_server:call(timeout, {sleep, 1000}).
{'EXIT',{noproc,{gen_server,call,[timeout,{sleep,1000}]}}}
```

```
1> timeout:start().
{ok,<0.188.0>}
2> timeout:sleep(1000).
ok
2> catch timeout:sleep(5000).
{'EXIT',{timeout,{gen_server,call,[timeout,{sleep,5000}]}}}
3> 
```