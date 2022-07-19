function E = expLap(A,t)
    dim=size(A);
    syms s 
    if dim(1)== dim(2)
        E=sym('a',[dim(1),dim(2)]);
        I=eye(dim(1));
        sImA=(s*I-A)^-1;
        for i=1:dim(1)
            for j=1:dim(2)
                if sImA(i,j)==0
                E(i,j)=ilaplace(sImA(i,j),s);
                else
                E(i,j)=ilaplace(sImA(i,j),t);
                end
            end
        end
    else
        E=double.empty;
    end
end