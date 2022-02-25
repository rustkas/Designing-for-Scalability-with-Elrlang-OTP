-module(macroses).

-export([test/0]).
-export([test_assign/0]).

-define(ANSWER,42).
-define(DOUBLE,2*).

-define(TWICE(F,X),F(F(X))).

-define(Assign(Var,Exp), Var=Exp,
io:format("~s = ~s -> ~p~n",[??Var,??Exp,Var]) ).

test() -> ?TWICE(?DOUBLE,?ANSWER).

test_assign() -> ?Assign(X, lists:sum([1,2,3])).