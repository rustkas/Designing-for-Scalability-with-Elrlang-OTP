ex02
=====
```
rebar3 new lib ex02 && cd ex02 && rm -R src && mkdir lib && cd lib && rebar3 new lib coffee_fsm && cd ..
```

An OTP application

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 
	
	$ werl +pc unicode
	> code:add_pathz("_build/default/lib/coffee_fsm/ebin").
	
```

3> hw:display("Capuchino", []).
Display:Capuchino
ok
4> hw:return_change(1).
Machine:Returned 1 in change
ok
5> hw:return_change(1.1).
Machine:Returned 1.1 in change
ok
6> hw:drop_cup().
Machine:Dropped Cup.
ok
7> hw:prepare("Small").
Machine:Preparing "Small".
ok
8> hw:reboot().
Machine:Rebooted Hardware
ok

```	

```
hw_ru:display("Капучино", []).
hw_ru:return_change(1).
hw_ru:drop_cup().
hw_ru:prepare("Маленький").
```