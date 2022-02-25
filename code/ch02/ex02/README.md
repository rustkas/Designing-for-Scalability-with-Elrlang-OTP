ex02
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell

```

1> print:print_all([one,two,three]).
one two three
ok
2> print:all_print([one,two,three]).
one two three
ok
3> Val = io:format("~n").
ok
4> Val.
ok
```