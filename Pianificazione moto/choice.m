function toSplit = choice(m,s)
k=size(m,3);
logical=zeros(k,1);
for i=1:k
    blk=m(:,:,i);
    dim=size(blk);
    if dim(1)<s
        logical(i,1)=false;
    elseif isequal(blk,ones(dim))
        logical(i,1)=false;
    elseif isequal(blk,zeros(dim))
        logical(i,1)=false;
    elseif dim(1)>s && ~isempty(find(ismember(blk,0), 1))
        logical(i,1)=true;
    end
end
toSplit=find(logical==1);
end

function val=findSubmat(mat,value,s)
A=mat;
B=value*ones(s,s);
szA=size(A);
szB=size(B);
szS=szA-szB+1;
tf=false(szA);
for r=1:szS(1)
    for c=1:szS(2)
        tf(r,c)= isequal(A(r:r+szB(1)-1,c:c+szB(2)-1),B) ;
    end
end
[rout,cout]=find(tf);
coords=[rout,cout];
if ~isempty(coords)
    val=1;
else
    val=0;
end
end
