compare_Parent_Child([H|Tail],ParentE, ChildE, ParentIdx, ChildIdx) when ParentIdx == 1 -> {Heap, ParentENew, ChildENew,_,_}=compare_Parent_Child(Tail, H, ChildE, ParentIdx-1, ChildIdx-1),
    if ChildENew > ParentENew -> compare_Parent_Child(swap(Heap, ParentENew, ChildENew, ParentIdx, ChildIdx), ParentENew, ChildENew, ParentIdx div 2, ParentIdx);%gibt Idx für weitere Vergleiche zurück
       true -> {Heap, ParentENew, ChildENew, -1}
    end;
%runter
compare_Parent_Child([H|Tail],ParentE, ChildE, ParentIdx, ChildIdx) when ParentIdx > 1 -> {Heap, ParentENew, ChildENew,_,_}=compare_Parent_Child(Tail, ParentE, ChildE, ParentIdx-1, ChildIdx-1),
    {[H|Tail], ParentENew, ChildENew, ParentIdx+1, ChildIdx+1};
%runter
compare_Parent_Child([H|Tail],ParentE, ChildE, ParentIdx, ChildIdx) when ParentIdx < 1, ChildIdx > 1 -> {Heap, ParentENew, ChildENew,_,_}=compare_Parent_Child(Tail, ParentE, ChildE, ParentIdx-1, ChildIdx-1),
    {[H|Tail], ParentENew, ChildENew, ParentIdx+1, ChildIdx+1};
%hoch???????
compare_Parent_Child([H|Tail],ParentE, ChildE, ParentIdx, ChildIdx) when ParentIdx < 1, ChildIdx > 1 -> {Heap, ParentENew, ChildENew,_,_}=compare_Parent_Child(Tail, ParentE, ChildE, ParentIdx-1, ChildIdx-1),
    {[H|Tail], ParentENew, ChildENew, ParentIdx+1, ChildIdx+1};
%child val
compare_Parent_Child([H|Tail], ParentE, _, ParentIdx, ChildIdx) when ChildIdx == 1 -> {[H|Tail], ParentE, H, ParentIdx+1, ChildIdx+1};
