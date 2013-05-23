```
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
```

