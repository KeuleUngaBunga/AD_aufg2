%Start for heapS.erl
-module(heapS).
-author("Tjark Pfeiffer").
%-compile(export_all).
-export([heapS/1]).
-import(heap, [create/0, isEmpty/1, insert/2, pop/1, top/1]).

%cd("C:/Users/pfeif/Documents/HAW/S3/AD 3/AD_Aufg2").


heapS(List) ->
	Heap = create(),
	Built_heap = build_heap(List, Heap),
	get_sorted_list(Built_heap).

%heap aufbauen
build_heap([H|T], Heap) ->
	NewHeap = insert(Heap, H),
	build_heap(T, NewHeap);
build_heap([], Heap) -> Heap.

get_sorted_list(Heap) ->% nochmal anschauen
	case isEmpty(Heap) of %case, da imported func illegal in guard
		true -> [];
		false ->
			Top = top(Heap),
			io:format("Top: ~p~n", [Top]),
			io:format("Heap before pop: ~p~n", [Heap]),
			NewHeap = pop(Heap),
			[Top | get_sorted_list(NewHeap)]
	end.
%end for heapS.erl
