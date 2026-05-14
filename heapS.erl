%Start for heapS.erl
-module(heapS).
-author("Tjark Pfeiffer").
-export([heapS/1]).
-import(heap, [create/0, isEmpty/1, insert/2, pop/1, top/1]).

%cd("C:/Users/pfeif/Documents/HAW/S3/AD 3/AD_Aufg2").

heapS([])-> [];
heapS(List) ->
	%Zeit:
	%Start = erlang:monotonic_time(millisecond),%Zeitmessung Start
	Heap = create(),%Phase 1
	Built_heap = build_heap(List, Heap),
	%End = erlang:monotonic_time(millisecond),%Zeitmessung Ende Phase 1
	%io:format("Build time delta: ~pms~n", [End - Start]),
	Start2 = erlang:monotonic_time(millisecond),%Zeitmessung Start Phase
	SortList = get_sorted_list(Built_heap,[]), %Phase 2
	End2 = erlang:monotonic_time(millisecond),%Zeitmessung Ende Phase 2 
	io:format("Sort time delta: ~pms~n", [End2 - Start2]),
	SortList.

	%ohne Zeit:
	%Heap = create(),%Phase 1
	%Built_heap = build_heap(List, Heap),
	%get_sorted_list(Built_heap,[]). %Phase 2

%heap aufbauen
build_heap([H|T], Heap) ->
	NewHeap = insert(Heap, H),
	build_heap(T, NewHeap);
build_heap([], Heap) -> Heap.

%heap sortieren und in neuer Liste ausgeben
get_sorted_list(Heap, Acc) ->
	case isEmpty(Heap) of %case, da imported func illegal in guard
		true -> Acc;
		false ->
			Top = top(Heap),

			%io:format("Top: ~p~n", [Top]),
			%io:format("Heap before pop: ~p~n", [Heap]),

			Start = erlang:monotonic_time(millisecond),%Zeitmessung Start Phase
			NewHeap = pop(Heap),
			End = erlang:monotonic_time(millisecond),%Zeitmessung Ende Phase  
			io:format("pop time delta: ~pms~n", [End - Start]),
			
			get_sorted_list(NewHeap, [Top | Acc])%Top|Acc für aufsteigend sortierte Liste
	end.

%end for heapS.erl
