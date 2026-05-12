%Start for heap.erl
-module(heap).
-author("Tjark Pfeiffer").
-export([create/0, isEmpty/1, insert/2, pop/1, top/1]).

create() -> {[],1}.%Tupel 

isEmpty({[],_}) -> true;%leere Liste
isEmpty({_,_}) -> false. %??

%Baumstruktur wird noch nicht beachtet!!!! (Nur iteratives Vergleichen von Elementen)--------------
%Knoten i hat Nachfolger 2*i (links) und 2*i+1 (rechts) beachten für iterieren

top([Head|_]) -> Head.%top Element zurückgeben (Heap sollte unverändert in HeapS bestehen bleiben)


%12.05. --------------------------------pop:!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!nicht finished
%Es fehlt: ein loop um nach dem Tauschen Ersetzen des ersten Elements noch alle Children zu überprüfen!
pop({[Head|Tail],Count})->
    NewHeap = get_Elem([Head|Tail], Count-1),
    NewHeap = compare_loop_pop(NewHeap, 1, Count-1),%maxHeap wiederherstellen, Idx=1 für beginn bei Wurzel
    {NewHeap, Count-1}.%1. letztes Element an erste Stelle setzen, 2. neues Heap zurückgeben mit Count-1

%12.05. --------------------------------insert sollte fertig sein--------------------------> testen!!
insert({Heap, Count}, E) -> insert_at_Idx(Heap, Count, E),%1. an letzter Stelle neues Element
    {compare_loop(Heap, Count),Count+1}.%2. 

%Hilfsfunktionen
%12.05. Ausgang: wenn Idx = 0 dann bin ich an der richtigen Stelle 

%go to Idx, wenn Idx = 0 dann an freier Stelle E einfügen
insert_at_Idx([H|Tail], 0, E) -> [E|Tail];%klammern Richtig?????????????????????????
insert_at_Idx([H|Tail], Idx, E) -> [H|insert_at_Idx(Tail, Idx-1, E)].

%get element at Idx of heap for insert for pop
get_Elem([H|Tail], 0) -> H;
get_Elem([H|Tail], Idx) -> get_Elem(Tail, Idx-1).

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
    end.
compare_loop(Heap, _) -> Heap. %Abbruchbedingung, wenn Idx <= 1 (Wurzel erreicht)

%compare child with parent 
compare_with_parent(Heap, Idx) when Idx mod 2 == 0 -> 
    ParentIdx = Idx div 2,
    E1 = get_Elem(Heap, Idx),
    E2 = get_Elem(Heap, ParentIdx),
    if E1 > E2 -> {swap(Heap, E1, E2, Idx, ParentIdx), ParentIdx};%gibt Idx für weitere Vergleiche zurück
       true -> {Heap, -1}%-1 als Abbruchbedingung für weitere Vergleiche
    end;
compare_with_parent(Heap, Idx) when Idx mod 2 == 1 ->
    ParentIdx = (Idx - 1) div 2,
    E1 = get_Elem(Heap, Idx),
    E2 = get_Elem(Heap, ParentIdx),
    if E1 > E2 -> {swap(Heap, E1, E2, Idx, ParentIdx), ParentIdx};
       true -> {Heap, -1}
    end.

%--------------------------------Hilfe für pop---------------------------------
%erst alle immer die linken Kinder vergleichen, dann die rechten, Hauptsache oben ist der größte Wert
compare_loop_pop(Heap, Idx, Count) when Idx < Count ->
    {NewHeap, NewIdx} = compare_with_left_child(Heap, Idx, Count),
    if NewIdx >= 0 -> NewHeap = compare_loop_pop(NewHeap, NewIdx, Count);%Vergleicht immer weiter bis -1 als Abbruchkriteium
       true -> NewHeap
    end,
    {NewHeap2, NewIdx2} = compare_with_right_child(NewHeap, Idx, Count),
    if NewIdx2 >= 0 -> compare_loop_pop(NewHeap2, NewIdx2, Count);%Vergleicht immer weiter bis -1 als Abbruchkriteium
       true -> NewHeap2
    end.

compare_with_left_child(Heap, Idx, Count) ->
    LeftChildIdx = 2 * Idx,%LeftChildIdx darf nicht größer als Count sein
    if LeftChildIdx < Count ->%Abbruch (kein Child vorhanden)
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
        E1 = get_Elem(Heap, Idx),
        E2 = get_Elem(Heap, RightChildIdx),
        if E1 < E2 -> {swap(Heap, E1, E2, Idx, RightChildIdx), RightChildIdx};% wenn kind größer, dann swap
           true -> {Heap, -1}
        end;
    true -> {Heap, -1}
    end.
%end for heap.erl


    