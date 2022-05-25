-module(factors).

% behavior setup for gen_server
-behaviour(gen_server).
-export(start_link/0).

% gen_server functions
- export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2, code_change/3]).

% client functions
-export([start/0,stop/0,factor/1]).
-define(SERVER, ?MODULE).

start() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

stop() ->
    gen_server:call(?MODULE, stop).

factor(List) -> gen_server:call(?MODULE, {factor,List}).

start_link() -> gen_server:start_link([local, ?SERVER], ?MODULE, [], []).

init([]) -> {ok, up}.
handle_call({factor,List},_From,State) ->
	{reply,
		lists:foldl(fun(X,Accum)->Accum+X end,0,List),
	State};%% not modifying the server's internal state
handle_call(stop, _From, _State) -> 
	{stop,normal,
		server_stopped,
    down}. %% setting the server's internal state to down