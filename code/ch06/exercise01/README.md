exercise01
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell

```
1> hlr:new().
{ok,<0.34.0>}
2> phone_fsm_statem:start_link("123").
{ok,<0.36.0>}
3> phone_fsm_statem:start_link("124").
{ok,<0.38.0>}
4> phone_fsm_statem:start_link("125").
{ok,<0.40.0>}
5> {ok,P123}=phone:start_link("123").
{ok,<0.42.0>}
6> {ok,P124}=phone:start_link("124").
{ok,<0.44.0>}
7> {ok,P125}=phone:start_link("125").
{ok,<0.46.0>}
8> phone:action(P123, {call,"124"}).
<0.44.0>: 124: inbound call from 123 ok
9> phone:action(P124, accept).
<0.42.0>: 123: call accepted ok
10> phone:action(P125, {call,"123"}).
<0.46.0>: 125: busy
ok
11> phone:action(P125, {call,"124"}).
<0.46.0>: 125: busy
ok
```