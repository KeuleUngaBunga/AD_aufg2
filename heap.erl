%Start for heap.erl
-module(heap).
-author("Tjark Pfeiffer").
-export([create/0, isEmpty/1, insert/2, pop/1, top/1]).

create() -> {[],1}.%Tupel 

isEmpty({[],_}) -> true;%leere Liste
isEmpty({_,_}) -> false. 


top({[Head|_],_}) -> Head.%top Element zurückgeben (Heap sollte unverändert in HeapS bestehen bleiben)


%--------------------------------pop----------------------------------
pop({_, 2})->{[], 1};%nur ein Element im Heap, nach pop ist er leer
pop({Heap,Count})->
    {Elem, NewHeap} = remove_last_elem(Heap),%kürzt den heap um 1 und gibt dieses Element zurück
    NewHeap2 = compare_loop_pop([Elem|NewHeap], 1, Count-1),%maxHeap wiederherstellen, Idx=1 für beginn bei Wurzel
    {NewHeap2, Count-1}.%1. letztes Element an erste Stelle setzen, 2. neues Heap zurückgeben mit Count-1

%--------------------------------insert--------------------------
insert({Heap, Count}, E) -> NewHeap=insert_at_Idx(Heap, Count, E),%1. an letzter Stelle neues Element
    {compare_loop(NewHeap, Count),Count+1}.%2. 

%Hilfsfunktionen

%go to Idx, wenn Idx = 0 dann an freier Stelle E einfügen
insert_at_Idx([], _, E) -> [E];%leere Liste, erstes Element wird eingefügt
insert_at_Idx([_|Tail], 1, E) -> [E|Tail];%H wird ersetzt, Logik an anderer Stelle
insert_at_Idx([H|Tail], Idx, E) -> [H|insert_at_Idx(Tail, Idx-1, E)].

%Element an Idx holen
%get_Elem([H|_], 1) -> H;
%get_Elem([_|Tail], Idx) -> get_Elem(Tail, Idx-1).

%tausche Parent und Child
swap([_|Tail], ParentE, ChildE, ParentIdx, ChildIdx) when ParentIdx == 1 -> [ChildE|swap(Tail, ParentE, ChildE, ParentIdx-1, ChildIdx-1)];
swap([_|Tail], ParentE, ChildE, ParentIdx, ChildIdx) when ChildIdx == 1 -> [ParentE|Tail];
swap([H|Tail], ParentE, ChildE, ParentIdx, ChildIdx) -> [H|swap(Tail, ParentE, ChildE, ParentIdx-1, ChildIdx-1)].

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
    {ParentE, ChildE} = get_Parent_Child(Heap, ParentIdx, Idx),%get Parent and Child in one function for faster runtime
    if ChildE > ParentE -> {swap(Heap, ParentE, ChildE, ParentIdx, Idx), ParentIdx};%gibt Idx für weitere Vergleiche zurück
       true -> {Heap, -1}%-1 als Abbruchbedingung für weitere Vergleiche
    end;
compare_with_parent(Heap, Idx) when Idx rem 2 == 1 ->
    ParentIdx = (Idx - 1) div 2,
    %io:format("compare_with_parent: Idx=~p, ParentIdx=~p~n", [Idx, ParentIdx]),
    {ParentE, ChildE} = get_Parent_Child(Heap, ParentIdx, Idx),%get Parent and Child in one function for faster runtime
    if ChildE > ParentE -> {swap(Heap, ParentE, ChildE, ParentIdx, Idx), ParentIdx};
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
        {ParentE, ChildE} = get_Parent_Child(Heap, Idx, LeftChildIdx),%get Parent and Child in one function for faster runtime
        if ParentE < ChildE -> {swap(Heap, ParentE, ChildE, Idx, LeftChildIdx), LeftChildIdx};% wenn kind größer, dann swap
           true -> {Heap, -1}
        end;
    true -> {Heap, -1}
    end.

compare_with_right_child(Heap, Idx, Count) ->
    RightChildIdx = 2 * Idx + 1,
    if RightChildIdx < Count ->%Abbruch
        %io:format("compare_with_right_child: Idx=~p, RightChildIdx=~p~n", [Idx, RightChildIdx]),
        %io:format("Heap: ~p~n", [Heap]),
        {ParentE, ChildE} = get_Parent_Child(Heap, Idx, RightChildIdx),%get Parent and Child in one function for faster runtime
        if ParentE < ChildE -> {swap(Heap, ParentE, ChildE, Idx, RightChildIdx), RightChildIdx};% wenn kind größer, dann swap
           true -> {Heap, -1}
        end;
    true -> {Heap, -1}
    end.

%neue Hilfsfunktionen für schnellere runtime:
get_Parent_Child([H|Tail], ParentIdx, ChildIdx) ->%Parent und Child in einer Funktion
    if ParentIdx == 1 -> {H, get_Parent_Child(Tail,ParentIdx-1, ChildIdx-1)};
        ChildIdx == 1 -> H;
        true -> get_Parent_Child(Tail, ParentIdx-1, ChildIdx-1)
    end.



remove_last_elem([H|[]]) -> {H, []};
remove_last_elem([H|Tail]) -> {Elem, NewTail} = remove_last_elem(Tail), {Elem, [H | NewTail]}.

%end for heap.erl


    