ex01
=====
```
$ rebar3 new lib ex02 && cd ex02 && rm -R src && mkdir lib && cd lib && rebar3 new lib earth && cd ..
```
An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> Pid = earth:start().
<0.137.0>
2> register(earth,Pid).
true
3> earth ! eclipse.
eclipse
4> earth ! sunset.
sunset
5> earth ! sunrise.
sunrise
6> exit(earth, kill).
** exception error: bad argument
     in function  exit/2
        called as exit(earth,kill)
        *** argument 1: not a pid
7> unregister(earth).
true
8> exit(Pid, kill).
true
9> earth ! sunrise.
** exception error: bad argument
     in operator  !/2
        called as earth ! sunrise
10>

```