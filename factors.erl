-module(factors).

% behavior setup for gen_server
-behaviour(gen_server).
-export([start_link/0]).

% gen_server functions
- export([init/1,handle_call/3,handle_cast/2,handle_info/2,terminate/2, code_change/3]).

% client functions
-export([start/0,stop/0,for/1]).
-define(SERVER, ?MODULE).

start() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

stop() ->
    gen_server:call(?MODULE, stop).

for(List) -> gen_server:call(?MODULE, {factor,List}).

start_link() -> gen_server:start_link([local, ?SERVER], ?MODULE, [], []).

init([]) -> {ok, up}.
handle_call({factor,List},_From,State) ->
    Gcf_list = doStuff(List, State),
	{reply,
		Gcf_list,
	State};%% not modifying the server's internal state
handle_call(stop, _From, _State) -> 
	{stop,normal,
		server_stopped,
    down}. %% setting the server's internal state to down

% doStuff(List, _) ->
%     doStuff(List, 0);
doStuff([H,N|T], _) ->
    % greatest common factor of the two numbers
    NewGcf = calculate_gcf(H,N),
    doStuff([H + 1,N + 1|T], NewGcf);
doStuff([], Gcf) ->
   Gcf.

calculate_gcf(H,0) ->
    H;
calculate_gcf(H, N) ->
    calculate_gcf(N, H rem N).





%syncronizing send and receive functions
handle_cast(_Msg, State) ->  {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason,_State) -> ok.
code_change(_OldVsn, _State, _Extra) -> io:format("code changing", []),{ok, state}.