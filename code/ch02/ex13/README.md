ex13
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
2> hlr:new().
ok
3> hlr:attach(12345).
true
4> hlr:lookup_ms(self()).
{ok,12345}
5> hlr:lookup_id(12345).
{ok,<0.32.0>}
6> hlr:detach().
true
7> hlr:lookup_id(12345).
{error,invalid}
```