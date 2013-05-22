-module(server4).

-export([loop/1]).

loop(State) ->
	receive
		{From, Message} ->
			io:format("message: ~p~n", [Message]),
			io:format("state: ~p~n", [State]),

			NewState = handle_message(State, From, Message),
			loop(NewState);
	stop ->
		io:format("stopping.~n", []),
		true
end.

handle_message(State, From, {ping, Data} = Message) ->
	From ! {self(), {pong, State}},
	[Message | State].