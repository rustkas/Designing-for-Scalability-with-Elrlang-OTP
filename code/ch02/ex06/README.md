ex06
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> factorial:factorial(zero).
{error,bad_argument}

2> try factorial:factorial(zero) catch Type:Error -> {Type, Error} end.
{error,function_clause}
4> try factorial:factorial(-2) catch Type:Error -> {Type, Error} end.
{error,function_clause}
5> try factorial:factorial(-2) catch error:Error2 -> {error, Error2} end.
{error,function_clause}
6> try factorial:factorial(-2) catch error:Error3 -> {error, Error3};
6> exit:Reason -> {exit, Reason} end.
{error,function_clause}
```