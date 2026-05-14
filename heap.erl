%Start for heap.erl
-module(heap).
-author("Tjark Pfeiffer").
-export([create/0, isEmpty/1, insert/2, pop/1, top/1]).

create() -> {[],1}.%Tupel 

isEmpty({[],_}) -> true;%leere Liste
isEmpty({_,_}) -> false. 


top({[Head|_],_}) -> Head.%top Element zurückgeben (Heap sollte unverändert in HeapS bestehen bleiben)


%13.05. --------------------------------pop fertig ----------------------------------
pop({_, 2})->{[], 1};%nur ein Element im Heap, nach pop ist er leer
pop({Heap,Count})->
    Elem = get_Elem(Heap, Count-1),
    NewHeap = insert_at_Idx(Heap, 1, Elem),%1. letztes Element an erste Stelle setzen
    NewHeap2 = remove_last_elem(NewHeap),%2. letztes Element entfernen
    NewHeap3 = compare_loop_pop(NewHeap2, 1, Count-1),%maxHeap wiederherstellen, Idx=1 für beginn bei Wurzel
    {NewHeap3, Count-1}.%1. letztes Element an erste Stelle setzen, 2. neues Heap zurückgeben mit Count-1

%12.05. --------------------------------insert fertig --------------------------
insert({Heap, Count}, E) -> NewHeap=insert_at_Idx(Heap, Count, E),%1. an letzter Stelle neues Element
    {compare_loop(NewHeap, Count),Count+1}.%2. 

%Hilfsfunktionen
%12.05. Ausgang: wenn Idx = 1 dann bin ich an der richtigen Stelle 

%go to Idx, wenn Idx = 0 dann an freier Stelle E einfügen
insert_at_Idx([], _, E) -> [E];%leere Liste, erstes Element wird eingefügt
insert_at_Idx([_|Tail], 1, E) -> [E|Tail];%H wird ersetzt, Logik an anderer Stelle
insert_at_Idx([H|Tail], Idx, E) -> [H|insert_at_Idx(Tail, Idx-1, E)].

%get element at Idx of heap for insert for pop
get_Elem([H|_], 1) -> H;
get_Elem([_|Tail], Idx) -> get_Elem(Tail, Idx-1).

%swap elements E1 and E2 at Idx1 and Idx2
swap(Heap, E1, E2, Idx1, Idx2) ->
    Heap1 = insert_at_Idx(Heap, Idx1, E2),
    insert_at_Idx(Heap1, Idx2, E1).

%--------------------------------Hilfe für insert---------------------------------
%compare loop bis alle an richtiger Stelle
compare_loop(Heap, Idx) when Idx > 1 ->
    {NewHeap, NewIdx} = compare_with_parent(Heap, Idx),
    if NewIdx >= 0 -> compare_loop(NewHeap, NewIdx);%Vergleicht immer weiter bis -1 als Abbruchkriteium
       true -> NewHeap
    end;
compare_loop(Heap, _) -> Heap. %Abbruchbedingung, wenn Idx <= 1 (Wurzel erreicht)

%compare child with parent 
compare_with_parent(Heap, Idx) when Idx rem 2 == 0 -> 
    ParentIdx = Idx div 2,
    %io:format("compare_with_parent: Idx=~p, ParentIdx=~p~n", [Idx, ParentIdx]),
    E1 = get_Elem(Heap, Idx),
    E2 = get_Elem(Heap, ParentIdx),
    if E1 > E2 -> {swap(Heap, E1, E2, Idx, ParentIdx), ParentIdx};%gibt Idx für weitere Vergleiche zurück
       true -> {Heap, -1}%-1 als Abbruchbedingung für weitere Vergleiche
    end;
compare_with_parent(Heap, Idx) when Idx rem 2 == 1 ->
    ParentIdx = (Idx - 1) div 2,
    %io:format("compare_with_parent: Idx=~p, ParentIdx=~p~n", [Idx, ParentIdx]),
    E1 = get_Elem(Heap, Idx),
    E2 = get_Elem(Heap, ParentIdx),
    if E1 > E2 -> {swap(Heap, E1, E2, Idx, ParentIdx), ParentIdx};
       true -> {Heap, -1}
    end.

%--------------------------------Hilfe für pop---------------------------------
%erst alle immer die linken Kinder vergleichen, dann die rechten
compare_loop_pop(Heap, Idx, Count) when Idx < Count ->
    %io:format("Heap: ~p~n", [Heap]),
    {NewHeap, NewIdx} = compare_with_left_child(Heap, Idx, Count),
    if NewIdx >= 0 -> NewHeap1 = compare_loop_pop(NewHeap, NewIdx, Count);%Vergleicht immer weiter bis -1 als Abbruchkriteium
       true -> NewHeap1 = NewHeap%NewHeap1 muss der aktuellste Heap sein, für Vergleiche auf der rechten Seite
    end,
    {NewHeap2, NewIdx2} = compare_with_right_child(NewHeap1, Idx, Count),
    if NewIdx2 >= 0 -> compare_loop_pop(NewHeap2, NewIdx2, Count);%Vergleicht immer weiter bis -1 als Abbruchkriteium
       true -> NewHeap2
    end.

compare_with_left_child(Heap, Idx, Count) ->
    LeftChildIdx = 2 * Idx,%LeftChildIdx darf nicht größer als Count sein
    if LeftChildIdx < Count ->%Abbruch (kein Child vorhanden)
        %io:format("compare_with_left_child: Idx=~p, LeftChildIdx=~p~n", [Idx, LeftChildIdx]),
        %io:format("Heap: ~p~n", [Heap]),
        E1 = get_Elem(Heap, Idx),
        E2 = get_Elem(Heap, LeftChildIdx),
        if E1 < E2 -> {swap(Heap, E1, E2, Idx, LeftChildIdx), LeftChildIdx};% wenn kind größer, dann swap
           true -> {Heap, -1}
        end;
    true -> {Heap, -1}
    end.

compare_with_right_child(Heap, Idx, Count) ->
    RightChildIdx = 2 * Idx + 1,
    if RightChildIdx < Count ->%Abbruch
        %io:format("compare_with_right_child: Idx=~p, RightChildIdx=~p~n", [Idx, RightChildIdx]),
        %io:format("Heap: ~p~n", [Heap]),
        E1 = get_Elem(Heap, Idx),
        E2 = get_Elem(Heap, RightChildIdx),
        if E1 < E2 -> {swap(Heap, E1, E2, Idx, RightChildIdx), RightChildIdx};% wenn kind größer, dann swap
           true -> {Heap, -1}
        end;
    true -> {Heap, -1}
    end.

remove_last_elem([_|[]]) -> [];
remove_last_elem([H|Tail]) -> [H | remove_last_elem(Tail)].
%end for heap.erl


    