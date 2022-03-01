ex04
=====
```
rebar3 new lib ex04 && cd ex04 && rm -R src && mkdir lib && cd lib && rebar3 new lib coffee_fsm && cd ..
```

An OTP library

Build
-----

% using gen_fsm behavior

    $ rebar3 compile 

```
lib/coffee_fsm/src/coffee_fsm.erl:11:5: Warning: gen_fsm:start_link/4 is deprecated; use the 'gen_statem' module instead
lib/coffee_fsm/src/coffee_fsm.erl:22:11: Warning: gen_fsm:send_event/2 is deprecated; use the 'gen_statem' module instead
lib/coffee_fsm/src/coffee_fsm.erl:23:14: Warning: gen_fsm:send_event/2 is deprecated; use the 'gen_statem' module instead
lib/coffee_fsm/src/coffee_fsm.erl:24:16: Warning: gen_fsm:send_event/2 is deprecated; use the 'gen_statem' module instead
lib/coffee_fsm/src/coffee_fsm.erl:25:17: Warning: gen_fsm:send_event/2 is deprecated; use the 'gen_statem' module instead
lib/coffee_fsm/src/coffee_fsm.erl:28:18: Warning: gen_fsm:send_event/2 is deprecated; use the 'gen_statem' module instead
lib/coffee_fsm/src/coffee_fsm.erl:29:18: Warning: gen_fsm:send_event/2 is deprecated; use the 'gen_statem' module instead
lib/coffee_fsm/src/coffee_fsm.erl:30:18: Warning: gen_fsm:send_event/2 is deprecated; use the 'gen_statem' module instead

```