ex04
=====

An OTP library

Build
-----

   $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> ping:start().
{ok,<0.260.0>}
2> ping:run_pause().
Handle call pause: From: {<0.135.0>,
                          [alias|#Ref<0.929428269.3308060675.179027>]}, LoopData: undefined
paused
3> ping:run_start().
Handle call start: From: {<0.135.0>,
                          [alias|#Ref<0.929428269.3308060673.184295>]}, LoopData
: undefined
started
11> Handle info: 11
11> Handle info: 16
11> Handle info: 21
11> Handle info: 26
11> Handle info: 31
11> Handle info: 36
11> Handle info: 41
11> Handle info: 46
11> Handle info: 51
11> Handle info: 56
11> Handle info:  1
11> ping:stop().
Handle cast stop: LoopData: undefined
ok
```


```
1> gen_server:start({local, ping}, ping, [], []).
{ok,<0.38.0>}
22
27
2> gen_server:call(ping, pause).
paused
3> gen_server:call(ping, start).
started 51
56
4> gen_server:call(ping, start).
started 4
```
