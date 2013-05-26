-module(server5).

-export([init/1, loop/2, system_continue/3, system_code_change/4]).

init(Parent) ->
	spawn(?MODULE, loop, [Parent, []]).

loop(Parent, State) ->
	receive
		{From, Message} ->
			io:format("message: ~p~n", [Message]),
			io:format("new state: ~p~n", [State]),

			NewState = handle_message(State, From, Message),
			?MODULE:loop(Parent, NewState);
		stop ->
			io:format("stopping.~n", []),
			true;
		{system, From, Request} ->
			sys:handle_system_msg(Request, From, Parent, ?MODULE, [], State)
	end.

system_continue(Parent, _Debug, State) ->
	?MODULE:loop(Parent, State).

system_code_change(State, _Module, _Version, _Extra) ->
	{ok, State}.

handle_message(State, From, {ping, _Data} = Message) ->
	From ! {self(), {pong, State}},
	[Message | State].

