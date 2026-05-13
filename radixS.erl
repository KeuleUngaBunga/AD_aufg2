-module(radixS).
-author(amirhossein_naghashi).
-export([radixS/2]).

radixS(Liste, Digit) -> radixS(Liste, 1, Digit+1).

radixS(Liste, Index, Mdigit) when Index >= Mdigit -> Liste;
radixS(Liste, Index, Mdigit) -> radixS(verteile(Liste, Index), Index+1, Mdigit).

verteile(Liste,Digit) -> sammle(verteile_buckets(Liste,Digit)).



potenz(_,0) -> 1;
potenz(Basis,Ex) -> Basis * potenz(Basis,Ex -1).


verteile_buckets([],_) -> [[],[],[],[],[],[],[],[],[],[]];
verteile_buckets([H|T], Digit) ->
    Buckets = verteile_buckets(T, Digit),
    Ziffer = (H div potenz(10, Digit-1)) rem 10,
    in_bucket(Ziffer, H, Buckets).


in_bucket(0, H, [Bucket|Rest]) -> [[H|Bucket]|Rest];
in_bucket(Ziffer, H, [Bucket|Rest]) -> [Bucket | in_bucket(Ziffer-1, H, Rest)].

sammle([]) -> [];
sammle([Bucket|Rest]) -> Bucket ++ sammle(Rest).