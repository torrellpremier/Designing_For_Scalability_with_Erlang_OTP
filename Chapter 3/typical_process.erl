start(Args) ->                      % Start the server
  spawn(server, init, [Args]).

init(Args) ->                       % Initialize the internal process state
  State = initialize_state(Args),
  loop(State).

loop(State) ->                      % Receive and handle messages
  receive
    {handle, Msg} ->
      NewState = handle(Msg, State),
      loop(NewState);
    stop ->
      terminate(State)               % Stop the process
  end.

terminate(State) ->                  % Clean up prior to termination
  clean_up(State).


call(Name, Message) ->
  Ref = make_ref(),
  Name ! {request, {Ref, self()}, Message},
  receive
    {reply, Ref, Reply} -> Reply
  end.

reply({Ref, To}, Reply) ->
  To ! {reply, Ref, Reply}.

call(Name, msg) ->
  Ref = erlang:monitor(process, Name),
  catch Name ! {request, {Ref, self()}, Msg},
  receive
    {reply, Ref, Reply} ->
      erlang:demonitor(Ref),
      Reply;
    {'DOWN', Ref, process, _Name, _Reason} ->
      {error, no_proc}
  end.
