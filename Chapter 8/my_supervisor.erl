-module(my_supervisor).
-export([start/2, init/1, stop/1]).

start(Name, ChildSpecList) ->
  register(Name, Pid = spawn(?MODULE, init, [ChildSpecList])),
  {ok, Pid}.

stop(Name) -> Name ! stop.

init(ChildSpecList) ->
  process_flag(trap_exit, true),
  loop(start_children(ChildSpecList)).

start_children(ChildSpecList) ->
  % List comprehension - list of {Pid, {M,F,A}} where
  %   {M,F,A} is taken from the list 'ChildSpecList'
  %   and Pid is the second element of calling the apply(M,F,A)
  %   function and obtaining {ok, Pid} as the result
  [{element(2, apply(M,F,A)), {M,F,A}} || {M,F,A} <- ChildSpecList].
