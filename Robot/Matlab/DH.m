function Q = DH(dht)
dim=size(dht);
Q=eye(4);
Qlist=[];
for i=1:dim(1)
    Qlist=[Qlist,qij(dht(i,:))];
end
idx = 1;
while ~(isempty(Qlist))    
    if (dht(idx,3)==0 || dht(idx,3)==pi) && idx~=dim(1)
        term = Qlist(:,1:4);
        Qlist(:,1:4) = [];
        if isempty(Qlist)
            Q=combine(simplify(Q*term),'sincos');
        else
            term1 = Qlist(:,1:4);
            Qlist(:,1:4) = [];
            Q = Q*combine(simplify(term*term1),'sincos');
            idx=idx+2;
        end
    else
        term = Qlist(:,1:4);
        Qlist(:,1:4) = [];
        Q=Q*term;
        idx=idx+1;       
    end 
end