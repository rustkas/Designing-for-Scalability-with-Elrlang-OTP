ex02
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> from:start().
{ok,<0.168.0>}

2> from:add(10).
ok
3> From:{<0.140.0>,[alias|#Ref<0.19200598.2997944322.58431>]}, Sum:10
3> from:add(10).
ok
4> From:{<0.140.0>,[alias|#Ref<0.19200598.2997944322.58438>]}, Sum:20
4> from:add(10).
ok
5> From:{<0.140.0>,[alias|#Ref<0.19200598.2997944322.58445>]}, Sum:30
5> from:add(10).
ok
6> From:{<0.140.0>,[alias|#Ref<0.19200598.2997944322.58452>]}, Sum:40
6> from:add(10).
ok
7> From:{<0.140.0>,[alias|#Ref<0.19200598.2997944322.58459>]}, Sum:50
7> from:stop().
ok
8> from:add(10).
** exception exit: {noproc,{gen_server,call,[from,{add,10}]}}
     in function  gen_server:call/2 (gen_server.erl, line 239)
```