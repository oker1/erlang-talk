-module(server5_gen).
-behaviour(gen_server).

-export([start_link/0, init/1, code_change/3, terminate/2]).
-export([handle_call/3, handle_cast/2, handle_info/2]).

start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init(_Args) ->
	{ok, []}.

handle_call(_Message, _From, State) ->
	{reply, true, State}.

handle_cast(_Message, State) ->
	{noreply, State}.

handle_info({From, Message}, State) ->
	State2 = handle_message(State, From, Message),
	{noreply, State2}.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

terminate(normal, _State) ->
	ok.

handle_message(State, From, {ping, _Data} = Message) ->
	From ! {self(), {pong, State}},
	[Message | State].

