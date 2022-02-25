ex14
=====

An OTP library

Build
-----

    $ rebar3 compile

```
erl -sname foo -setcookie abc
Eshell V12.2  (abort with ^G)
(foo@tol)1>

erl -sname bar -setcookie abc
Eshell V12.2  (abort with ^G)
(bar@tol)1>

(bar@tol)1> net_adm:ping('foo@tol').
pong
(bar@tol)2> [Node] = nodes().
['foo@tol']
(bar@tol)3> Shell = self().
<0.38.0>
(bar@tol)4> spawn(Node, fun() -> Shell ! self() end).
<5985.46.0>
(bar@tol)5> receive Pid -> Pid end.
<5985.46.0>
(bar@tol)6> node(Pid).
'foo@tol'
receive Msg -> Msg end.