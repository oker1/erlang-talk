-module(server1).

-export([loop/0]).

loop() ->
	receive
		{From, {ping, Data} = Message} ->
			io:format("message: ~p~n", [Message]),
			From ! {self(), {pong, Data}},
			loop();
	stop ->
		io:format("stopping.~n", []),
		true
end.