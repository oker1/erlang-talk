-module(server3).

-export([restarter/0, loop/0]).

loop() ->
	receive
		{From, Message} ->
			io:format("message: ~p~n", [Message]),
			handle_message(From, Message),
			loop();
	stop ->
		io:format("stopping.~n", []),
		true
end.

restarter() ->
	process_flag(trap_exit, true),
	Pid = spawn_link(?MODULE, loop, []),
	register(serverProcess, Pid),
	receive
		{'EXIT', Pid, normal} ->
			io:format("exiting normally.~n", []),
			ok;
		{'EXIT', Pid, _} ->
			io:format("restarting.~n", []),
			restarter()
end.

handle_message(From, {ping, Data}) ->
	From ! {self(), {pong, Data}}.