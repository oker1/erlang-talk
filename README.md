```
c(server1).
Pid = spawn_link(server1, loop, []).
Pid ! {test}.
Pid ! {ping, ohai}.
Pid ! stop.

c(server3).
Pid = spawn_link(server3, restarter, []).
serverProcess ! {ping, ohai}.
exit(whereis(serverProcess), die).


c(server5).
Pid = server5:init(self()).
Pid ! {self(), {ping, 1}}.
sys:suspend(Pid).
Pid ! {self(), {ping, 2}}.
code:purge(server5), compile:file(server5), code:load_file(server5).
sys:change_code(Pid, server5, "0", []).
sys:resume(Pid).
Pid ! {self(), {ping, 3}}.


c(server5_gen).
{ok, Pid} = server5_gen:start_link().
Pid ! {self(), {ping, 1}}.
flush().


erl -sname n1
erl -sname n2
register(n2shell, self()).
erlang:monitor_node('n1@localhost', true).
nodes().
{ n2shell, 'n2@localhost' } ! {ohai, self()}.
quit n1
flush().
```

