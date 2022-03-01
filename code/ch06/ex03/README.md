ex03
=====
```
rebar3 new lib ex03 && cd ex03 && rm -R src && mkdir lib && cd lib && rebar3 new lib coffee_fsm && cd ..
```

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> coffee:start_link().
erlang:is_process_alive(coffee).
2> coffee:tea().
coffee:pay(50).
coffee:cup_removed().

coffee:espresso().
coffee:americano().
coffee:cappuccino().


coffee:espresso().
coffee:pay(50).
coffee:pay(50).
coffee:pay(50).
coffee:cup_removed().


coffee:americano().
coffee:pay(50).
coffee:pay(50).
coffee:cup_removed().

coffee:cappuccino().


```