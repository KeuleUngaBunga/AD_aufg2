%Start for heap.erl
-module(heap).
-author("Tjark Pfeiffer").
-export([create/0, isEmpty/1, insert/2, pop/1, top/1]).

create() -> {[],1}.%Tupel 

isEmpty({[],_}) -> true;%leere Liste
isEmpty({_,_}) -> false. %??

%Baumstruktur wird noch nicht beachtet!!!! (Nur iteratives Vergleichen von Elementen)--------------
%Knoten i hat Nachfolger 2*i (links) und 2*i+1 (rechts) beachten für iterieren

%sortiertes einfügen in Heap
insert({Heap, Count}, E) -> {insert(Heap, Count-1, E), Count+1}.
%Heap Ende
insert([H|Tail], 0, E) -> [E|Tail];
%Element vergleichen wenn neues Element größer als aktualles Element, dann tauschen
insert([H|Tail], Count, E) -> when E> H [E|insert(Tail, Count-1, H)].

%Weiter suchen
insert([H|Tail], Count, E) -> [H|insert(Tail, Count-1, E)].

pop([Head|Tail]) -> Tail.%top Element entfernen TODO: neues Wurzelelement 

top([Head|_]) -> Head.%top Element zurückgeben (Heap sollte unverändert in HeapS bestehen bleiben)
%end for heap.erl

%new --------------------------------insert sollte fertig sein--------------------------> testen!!
insert({Heap, Count}, E) -> insert_at_Idx(Heap, Count, E),%1. an letzter Stelle neues Element
    {compare_loop(Heap, Count),Count+1}.%2. 

%Hilfsfunktionen
%new: Ausgang: wenn Idx = 0 dann bin ich an der richtigen Stelle 

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

%compare loop bis alle an richtiger Stelle
compare_loop(Heap, Idx) when Idx >= 0 ->
    {NewHeap, NewIdx} = compare_with_parent(Heap, Idx),
    if NewIdx >= 0 -> compare_loop(NewHeap, NewIdx);%Vergleicht immer weiter bis -1 als Abbruchkriteium
       true -> NewHeap
    end.
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



    