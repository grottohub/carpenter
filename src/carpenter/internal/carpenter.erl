-module(carpenter).

-export([new_table/2]).

new_table(Name, Options) ->
    try
        {ok, ets:new(Name, Options)}
    catch
        error:badarg -> {error, nil}
    end.
