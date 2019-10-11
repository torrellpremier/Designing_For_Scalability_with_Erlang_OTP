-module(frequency).
-behaviour(gen_server).

-export([start_link/1, init/1, ...]).

start_link(...) ->
  ...

gen_server:call(Name, Message) -> Reply

allocate() ->                                             % frequency.erl
  gen_server:call(frequency, {allocate, self()}).

handle_call({allocate, Pid}, _From, Frequencies) ->
  {NewFrequencies, Reply} = allocate(Frequencies, Pid),
  {reply, Reply, NewFrequencies}.

gen_server:cast(Name, Message) -> ok

deallocate(Frequency) ->                                  % frequency.erl
  gen_server:cast(frequency, {deallocate, Frequency}).

handle_cast({deallocate, Freq}, Frequencies) ->
  NewFrequencies = deallocate(Frequencies, Freq),
  {noreply, NewFrequencies}.

handle_info(_Msg, LoopData) ->                            % frequency.erl
  {noreply, LoopData}.

handle_info({'EXIT', _Pid, normal}, LoopData) ->
  {noreply, LoopData};
handle_info({'EXIT', Pid, Reason}, LoopData) ->
  io:format("Process: ~p exited with reason: ~p~n", [Pid, Reason]),
  {noreply, LoopData};
handle_info(_Msg, LoopData) ->
  {noreply, LoopData}.

gen_server:reply(From, Reply)

handle_call({add, Data}, From, Sum) ->
  gen_server:reply(From, ok),
  timer:sleep(1000),
  NewSum = add(Data, Sum),
  io:format("From:~p, Sum:~p~n", [From, NewSum]),
  {noreply, NewSum}.


stop() -> gen_server:cast(frequency, stop).

handle_cast(stop, LoopData) ->
  {stop, normal, LoopData}.

terminate(_Reason, _LoopData) ->
  ok.

gen_server:call(Server, Message, Timeout) -> Reply
