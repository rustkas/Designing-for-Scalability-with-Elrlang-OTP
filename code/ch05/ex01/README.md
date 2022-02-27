ex01
=====

An OTP library

Build
-----

   $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> frequency:start().
{ok,<0.35.0>}
2> sys:trace(frequency, true).
ok
3> frequency:allocate().
*DBG* frequency got call {allocate,<0.33.0>} from <0.33.0>
*DBG* frequency sent {ok,10} to <0.33.0>,
new state {[11,12,13,14,15],[{10,<0.33.0>}]}
{ok,10}
4> frequency:deallocate(10).
frequency:deallocate_all().
*DBG* frequency got cast {deallocate,10} ok
*DBG* frequency new state {[10,11,12,13,14,15],[]}
5> sys:trace(frequency, false).
ok
6> frequency:deallocate_all().
```

```
6> sys:log(frequency, true).
ok
7> {ok, Freq} = frequency:allocate(), frequency:deallocate(Freq).
ok
8> sys:log(frequency, print).
*DBG* frequency got call {allocate,<0.33.0>} from <0.33.0>
*DBG* frequency sent {ok,10} to <0.33.0>,
new state {[11,12,13,14,15],[{10,<0.33.0>}]}
*DBG* frequency got cast {deallocate,10}
*DBG* frequency new state {[10,11,12,13,14,15],[]} ok
9> sys:log(frequency, get).
{ok,[{{in,{'$gen_call',{<0.33.0>,#Ref<0.0.4.59>},
{allocate,<0.33.0>}}},
frequency,#Fun<gen_server.0.40920150>},
{{out,{ok,10},<0.33.0>,{[11,12,13,14,15],[{10,<0.33.0>}]}},
frequency,#Fun<gen_server.6.40920150>},
{{in,{'$gen_cast',{deallocate,10}}},
frequency,#Fun<gen_server.0.40920150>},
{{noreply,{[10,11,12,13,14,15],[]}},
frequency,#Fun<gen_server.4.40920150>}]}
10> sys:log(frequency, false).
ok
```

```
werl +pc unicode
```

```
11> F = fun(Count,{out, {error, no_frequency}, Pid, _LoopData}, ProcData) ->
io:format("*DBG* Внимание, клиенту ~p отказано в частоте! Всего:~w~n", [Pid, Count]),
Count + 1;
(Count, _, _) -> Count
end.
#Fun<erl_eval.18.54118792>

> code:add_pathz("_build/default/lib/frequency/ebin").
> frequency:start().

12> sys:install(frequency, {F, 1}).
ok
13> frequency:allocate(), frequency:allocate(), frequency:allocate(), frequency:allocate(), frequency:allocate(), frequency:allocate().
{ok,15}
14> frequency:allocate().
*DBG*­Внимание,­клиенту­<0.33.0>­отказано­в­частоте!­Всего:1
{error,no_frequency}
15> frequency:allocate().
*DBG*­Внимание,­клиенту­<0.33.0>­отказано­в­частоте!­Count:2
{error,no_frequency}
16> sys:remove(frequency, F).
ok
17> frequency:allocate().
{error,no_frequency}
```

```
18> sys:statistics(frequency, true).
ok
19> frequency:allocate().
{error,no_frequency}
20> sys:statistics(frequency,get).
{ok,[{start_time,{{2015,11,29},{20,10,54}}},
{current_time,{{2015,11,29},{20,12,9}}},
{reductions,33},
{messages_in,1},
{messages_out,0}]}
21> sys:statistics(frequency, false).
ok
22> sys:get_status(frequency).
{status,<0.96.0>,
        {module,gen_server},
        [[{'$initial_call',{frequency,init,1}},
          {'$ancestors',[<0.85.0>]}],
         running,<0.85.0>,
         [{statistics,{{{2022,2,26},{18,23,5}},
                       {reductions,2325},
                       1,1}}],
         [{header,"Status for generic server frequency"},
          {data,[{"Status",running},
                 {"Parent",<0.85.0>},
                 {"Logged events",[]}]},
          {data,[{"State",
                  {{available,[]},
                   {allocated,[{15,<0.85.0>},
                               {14,<0.85.0>},
                               {13,<0.85.0>},
                               {12,<0.85.0>},
                               {11,<0.85.0>},
                               {10,<0.85.0>}]}}}]}]]}

23> {Free, Alloc} = sys:get_state(frequency).
{[],
 [{15,<0.85.0>},
  {14,<0.85.0>},
  {13,<0.85.0>},
  {12,<0.85.0>},
  {11,<0.85.0>},
  {10,<0.85.0>}]}


24> sys:replace_state(frequency, fun(_) -> {[16,17], Alloc} end).
{[16,17],
 [{15,<0.85.0>},
  {14,<0.85.0>},
  {13,<0.85.0>},
  {12,<0.85.0>},
  {11,<0.85.0>},
  {10,<0.85.0>}]}
25> frequency:allocate().
{ok,16}
```