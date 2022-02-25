ex08
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> Pid = spawn(echo, loop, []).
<0.137.0>
2> MonitorRef = erlang:monitor(process, Pid).
#Ref<0.0.0.34>
3> exit(Pid, kill).
true
4> flush().
Shell got {'DOWN',#Ref<0.0.0.34>,process,<0.34.0>,killed}
ok
> erlang:demonitor(MonitorRef).
```