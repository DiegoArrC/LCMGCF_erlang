-module(calcs_supervisor).
-behaviour(supervisor).
 
-export([start/0, start_link/1, start_in_shell_for_testing/0]).
-export([init/1]).

-define(SERVER, ?MODULE).


start() ->
    spawn(fun() ->
        supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = [])
    end).

start_in_shell_for_testing() ->
    {ok, Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, _Arg = []),
    unlink(Pid).

start_link(Args) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init([]) ->
    {ok,
        {
          {one_for_one, 3, 10},
   % the pattern for this tuple is {supervision_type, restart_limit, restart_limit_time}. 
   % in this case, if the managed gen_server has to be restarted more than 3 times in 10 seconds, 
   % the supervisor should notify it's supervisor, if one exists, by failing.
            [% the begining of the list of children this supervisor supervises
              {get_factors,% any unique, descriptive atom that can be used for later reference. A name for the child.     
                {factors, start_link, []},% the pattern for this tuple is {module_name,startup_function, startup_function_parameters} for the supervised child
                permanent,% the type of restart desired. The permanent atom means always restart. There are other options.
                10000,% the maximum number of milliseconds available for the gen_server's shutdown process before the gen_server is killed without remorse.
                worker,% an atom that declares if this child is a worker or a supervisor
                [factors]}, % the name of the module that has the gen_server (or supervisor if this child is a supervisor) callbacks in it
              {get_gcf_lcm,
                {gcf_lcm_service, start_link, []},
                permanent,
                10000,
                worker,
                [gcf_lcm_service]}]}}.
				