ex05
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell

```
1> frequency:start().
true
2> frequency:allocate(), frequency:allocate(), frequency:allocate(),
frequency:allocate(),frequency:allocate(), frequency:allocate().
{ok,15}
3> frequency:allocate().
{error,no_frequency}
4> frequency:deallocate(11).
ok
5> frequency:allocate().
{ok,11}
6> frequency:stop().
ok
```