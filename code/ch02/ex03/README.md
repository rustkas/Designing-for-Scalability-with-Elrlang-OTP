ex03
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> filter:filter(fun(X) -> X rem 2 == 0 end, [1,2,3,4]).
[2,4]
2> filter:filter(fun filter:is_even/1,[1,2,3,4]).
[2,4]

4> F = fun Filter(_,[]) -> [];
4> Filter(P,[X|Xs]) -> case P(X) of
4> true -> [X|Filter(P,Xs)];
4> false -> Filter(P,Xs) end end.
#Fun<erl_eval.36.90072148>
5> Filter(fun(X) -> X rem 2 == 0 end,[1,2,3,4]).
* 1: variable 'Filter' is unbound
6> F(fun(X) -> X rem 2 == 0 end,[1,2,3,4]).
[2,4]
7> filter:filter2(fun filter:is_even/1,[1,2,3,4]).
```

```
1> [Element || Element <- [1,2,3,4], Element rem 2 == 0].
[2,4]
2> [Element || Element <- [1,2,3,4], filter:is_even(Element)].
[2,4]
3> [Element || Element <- lists:seq(1,4), Element rem 2 == 0].
[2,4]
4> [io:format("~p~n",[Element]) || Element <- [one, two, three]].
one 
two 
three
[ok,ok,ok]
```

```
5> [ {X,Y} || X <- [1,2], Y <- [3,4,5] ].
[{1,3},{1,4},{1,5},{2,3},{2,4},{2,5}]
6> [ {X,Y} || X <- [1,2], Y <- [X+3,X+4,X+5] ].
[{1,4},{1,5},{1,6},{2,5},{2,6},{2,7}]
7> [ {X,Y} || X <- [1,2,3], X rem 2 /= 0, Y <- [X+3,X+4,X+5], (X+Y) rem 2 == 0 ].
[{1,5},{3,7}]
8> [ {X,Y} || X <-[1,2,3], X rem 2 /= 0, Y <- [X+3,X+4,X+5], (X+Y) rem 2 /= 0 ].
[{1,4},{1,6},{3,6},{3,8}]
```