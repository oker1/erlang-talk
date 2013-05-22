-module(server2).

-export([loop/0]).

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

handle_message(From, {ping, Data}) ->
	From ! {self(), {pong, Data}}.