%Start for heapS.erl
-module(heapS).
-author("Tjark Pfeiffer").
%-compile(export_all).
-export([heapS/1]).
-import(heap, [create/0, isEmpty/1, insert/2, pop/1, top/1]).

heapS(List) ->
	Heap = create(),
	Built_heap = build_heap(List, Heap).

%heap aufbauen
build_heap([H|T], Heap) ->
	NewHeap = insert(Heap, H),
	build_heap(T, NewHeap).
build_heap([], Heap) -> Heap.

get_sorted_list(Heap) ->% nochmal anschauen
	if isEmpty(Heap) -> [];
	   true ->
		   Top = top(Heap),
		   NewHeap = pop(Heap),
		   [Top | get_sorted_list(NewHeap)]
	end.
%end for heapS.erl
