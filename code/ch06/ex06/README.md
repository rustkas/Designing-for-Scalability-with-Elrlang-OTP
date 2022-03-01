ex06
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 


```
> coffee_fsm_timeout:start_link().
> coffee_fsm_timeout:tea().
> coffee_fsm_timeout:pay(50).
> coffee_fsm_timeout:stop().
```