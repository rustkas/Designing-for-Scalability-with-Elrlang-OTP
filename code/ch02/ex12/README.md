ex12
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> TabId = ets:new(tab,[named_table]).
tab
2> ets:insert(tab,{haskell, lazy}).
true
3> ets:lookup(tab,haskell).
[{haskell,lazy}]
4> ets:insert(tab,{haskell, ghci}).
true
5> ets:lookup(tab,haskell).
[{haskell,ghci}]
6> ets:lookup(tab,racket).
[]
7> ets:insert(tab,{racket,strict}).
true
8> ets:insert(tab,{ocaml,strict}).
true
9> ets:first(tab).
racket
10> ets:next(tab,racket).
haskell
11> ets:next(tab,haskell).

11> ets:match(tab,{'$1','$0'}).
[[strict,ocaml],[ghci,haskell],[strict,racket]]
12> ets:match(tab,{'$1','_'}).
[[ocaml],[haskell],[racket]]
13> ets:match(tab,{'$1',strict}).
[[ocaml],[racket]]

```