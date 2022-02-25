ex10
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> EmptyMap = #{}.
#{}
2> erlang:map_size(EmptyMap).
0
> RelDates = #{ "R15B03-1" => {2012, 11, 28}, "R16B03" => {2013, 12, 11} }.
#{"R15B03-1" => {2012,11,28},"R16B03" => {2013,12,11}}
4> RelDates2 = RelDates#{ "17.0" => {2014, 4, 2}}.
#{"17.0" => {2014,4,2},
  "R15B03-1" => {2012,11,28},
  "R16B03" => {2013,12,11}}
5> RelDates3 = RelDates2#{"17.0" := {2014, 4, 9}}.
#{"17.0" => {2014,4,9},
"R15B03-1" => {2012,11,28},
"R16B03" => {2013,12,11}}
6> #{ "R15B03-1" := Date } = RelDates3.
#{"17.0" => {2014,4,2},
"R15B03-1" => {2012,11,28},
"R16B03" => {2013,12,11}}
7> Date.
{2012,11,28}
```