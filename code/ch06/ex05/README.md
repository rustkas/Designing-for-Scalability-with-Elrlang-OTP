ex05
=====

An OTP library

Build
-----

    $ rebar3 compile && rebar3 shell
	> r3:do(compile). % recompile after source code editing 

```
1> {ok, Pid} = coffee_fsm_timeout:start_link().
Machine: Rebooted Hardware
Display: Make Your Selection
{ok,<0.138.0>}
2> sys:trace(Pid, true).
ok
3> coffee_fsm_timeout:cancel().
*DBG* coffee_fsm receive cast cancel in state selection
*DBG* coffee_fsm consume cast cancel in state selection
ok
4> coffee_fsm_timeout:tea().
*DBG* coffee_fsm receive cast {selection,tea,100} in state selection
Display: Please pay:100
ok
*DBG* coffee_fsm consume cast {selection,tea,100} in state selection => payment
5> coffee_fsm_timeout:cancel().
*DBG* coffee_fsm receive cast cancel in state payment
Display: Make Your Selection
ok
*DBG* coffee_fsm consume cast cancel in state payment => selection
6> coffee_fsm_timeout:americano().
*DBG* coffee_fsm receive cast {selection,americano,150} in state selection
Display: Please pay:150
ok
*DBG* coffee_fsm consume cast {selection,americano,150} in state selection => payment
*DBG* coffee_fsm receive cast {pay,100} in state payment
Display: Please pay: 50
ok
*DBG* coffee_fsm consume cast {pay,100} in state payment
*DBG* coffee_fsm receive cast {pay,100} in state payment
Display: Preparing Drink.
ok
Machine: Returned 50 in change
Machine: Dropped Cup.
Machine: Preparing [americano].
9> Display: Remove Drink.
9> *DBG* coffee_fsm consume cast {pay,100} in state payment => remove
*DBG* coffee_fsm receive cast {pay,50} in state remove
Machine: Returned 50 in change
ok
*DBG* coffee_fsm consume cast {pay,50} in state remove
10> coffee_fsm_timeout:cup_removed().
*DBG* coffee_fsm receive cast cup_removed in state remove
Display: Make Your Selection
ok
*DBG* coffee_fsm consume cast cup_removed in state remove => selection
11> sys:trace(Pid, false).
ok
12> coffee_fsm_timeout:stop().
ok
```



```
$ werl +pc unicode
> code:add_pathz("_build/default/lib/coffee_fsm/ebin").
true

1> {ok, Pid} = coffee_fsm_ru:start_link().
Машина: Перезагружена
Дисплей: Выберите напиток
{ok,<0.84.0>}
2> sys:trace(Pid, true).
ok
3> coffee_fsm_ru:cancel().
*DBG* coffee_fsm_ru receive cast cancel in state selection
ok
*DBG* coffee_fsm_ru consume cast cancel in state selection
4> coffee_fsm_ru:tea().
*DBG* coffee_fsm_ru receive cast {selection,tea,100} in state selection
ok
Дисплей: Пожалуйста, оплатите: 100
*DBG* coffee_fsm_ru consume cast {selection,tea,100} in state selection => payment

5> coffee_fsm_ru:cancel().
*DBG* coffee_fsm_ru receive cast cancel in state payment
Дисплей: Выбирете напиток
ok
*DBG* coffee_fsm_ru consume cast cancel in state payment => selection
6> coffee_fsm_ru:americano().
*DBG* coffee_fsm_ru receive cast {selection,americano,150} in state selection
ok
Дисплей: Пожалуйста, оплатите: 150
*DBG* coffee_fsm_ru consume cast {selection,americano,150} in state selection => payment
7> coffee_fsm_ru:pay(100).
*DBG* coffee_fsm_ru receive cast {pay,100} in state payment
ok
Дисплей: Пожалуйста, оплатите: 50
*DBG* coffee_fsm_ru consume cast {pay,100} in state payment

8> coffee_fsm_ru:pay(100).
*DBG* coffee_fsm_ru receive cast {pay,100} in state payment
ok
Дисплей: Готовиться напиток.
Машина: Вернула­50 сдачи
Машина: Выбросила­стаканчик.
Машина: Готовит­americano.
Дисплей: Заберите стаканчик.
*DBG* coffee_fsm_ru consume cast {pay,100} in state payment => remove
9> coffee_fsm_ru:pay(50).
*DBG* coffee_fsm_ru receive cast {pay,50} in state remove
ok
Машина: Вернула­50 сдачи
*DBG* coffee_fsm_ru consume cast {pay,50} in state remove
10> coffee_fsm_ru:cup_removed().
*DBG* coffee_fsm_ru receive cast cup_removed in state remove
ok
Дисплей: Выбирете напиток
*DBG* coffee_fsm_ru consume cast cup_removed in state remove => selection
11> sys:trace(Pid, false).
ok
12> coffee_fsm_ru:stop().
ok
```