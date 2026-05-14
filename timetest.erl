%Start for heap.erl
-module(timetest).
-author("Tjark Pfeiffer").
-export([testquickS/2,testquickS_all/1,testheapS/1,testall/1]).
-import(quickS, [quickS/2]).
-import(heapS, [heapS/1]).

testquickS(List, Pivot) ->
    Start = erlang:monotonic_time(millisecond),
    quickS(List, Pivot),
    End = erlang:monotonic_time(millisecond),
    io:format("Quick Sort time delta: ~p ms~n", [End - Start]).

testquickS_all(List) ->
    io:format("Testing quicks for all pivots: ~n middle:~n"),
    testquickS(List, middle),
    io:format("random:~n"),
    testquickS(List, random),
    io:format("left:~n"),
    testquickS(List, left),
    io:format("right:~n"),
    testquickS(List, right),
    io:format("median:~n"),
    testquickS(List, median),
    'quickS ok'.

testheapS(List) ->
    io:format("Testing heap sort:~n"),
    Start = erlang:monotonic_time(millisecond),
    heapS(List),
    End = erlang:monotonic_time(millisecond),
    io:format("heap time delta: ~p ms~n", [End - Start]).

testall(List) ->
    {testquickS_all(List), testheapS(List)}.
