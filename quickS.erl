%start for quickS.erl
-module(quickS).
-author("Tjark Pfeiffer").
-export([quickS/2]).

quickS([], _) -> [];
quickS([H|[]], _) -> [H];
quickS(List, Pivot) ->
    Pivot_element = get_pivot_element(Pivot, List),
    {Less, Greater, Equal} = part(List, Pivot_element),%diesn Tupel in introsort verwenden

    %rekursiver Aufruf mit den drei Listen um die Liste zu sortieren: 
    %(für introsort weglassen und in introS mit Less/Greater/Equal die Aufrufe zu introS machen)
    concat_lists(quickS(Less, Pivot), concat_lists(Equal, quickS(Greater, Pivot))).

%Hilfsfunktionen:
part([], _) -> {[], [], []};
part([H|T], Pivot) ->  
    {Less, Greater, Equal} = part(T, Pivot),
    if
        H < Pivot -> {[H | Less], Greater, Equal};
        H == Pivot -> {Less, Greater, [H|Equal]};
        H > Pivot -> {Less, [H | Greater], Equal}
    end.

%get 1 of 5 possible pivot elements
get_pivot_element(Pivot, List) ->
    case Pivot of
        middle -> MidIdx = length(List) div 2,%length(List) ok? 
                get_Elem(List, MidIdx+1);%+1, da von 1 indiziert wird, wie bei heapS
        random -> RndIdx = rand:uniform(length(List)),
                get_Elem(List, RndIdx);
        left -> get_Elem(List, 1);
        right -> get_last_Elem(List);
        median -> A = get_pivot_element(left, List),
            B = get_pivot_element(middle, List),
            C = get_pivot_element(right, List),
            if A =< C, C =< B -> C;%last
                C =< A, A =< B -> A;%first
                true -> B%middle
            end
    end.
    

get_Elem([H|_], 1) -> H;
get_Elem([_|Tail], Idx) -> get_Elem(Tail, Idx-1).

%right(letztes) Element aus Liste holen
get_last_Elem([H|[]]) -> H;
get_last_Elem([_|T]) -> get_last_Elem(T).

%Listen aneinanderhängen 
concat_lists([], List) -> List;
concat_lists([H|T], List) -> [H | concat_lists(T, List)].
%end for quickS.erl
