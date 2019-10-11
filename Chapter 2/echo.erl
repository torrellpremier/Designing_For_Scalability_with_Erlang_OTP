-module(echo).

-export([loop/0]).

loop() ->
  receive
    Anything ->
      loop()
  end.
