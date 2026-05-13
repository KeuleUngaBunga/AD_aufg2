-module(insertionS).
-author(amirhossein_naghashi).
-export([insertionS/1]).

insertionS(Liste) -> insertionS(Liste,[]).

insertionS([],Sortiert) -> Sortiert;
insertionS([H|T],Sortiert) -> insertionS(T,insert(H,Sortiert)).

insert(H,[]) -> [H];
insert(H, [Head|Tail]) when H =< Head -> [H,Head|Tail];
insert(H,[Head|Tail]) -> [Head|insert(H,Tail)].


