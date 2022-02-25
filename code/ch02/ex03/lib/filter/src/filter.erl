-module(filter).
-export([filter/2, is_even/1]).
-export([filter2/2]).

filter(_P,[]) -> [];
filter(P,[X|Xs]) ->
    case P(X) of
	true ->
	    [X| filter(P,Xs)];
	_ ->
	    filter(P,Xs)
    end.

is_even(X) ->
    X rem 2 == 0.

filter2(P,Xs) -> [ X || X<-Xs, P(X) ].