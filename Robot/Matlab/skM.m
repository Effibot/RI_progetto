%Matrice antisimmetrica
function M = skM(v)
if isequal(size(v),[3,1])
    M=[0 -v(3) v(2) ; v(3) 0 -v(1) ; -v(2) v(1) 0 ];
else
    M=double.empty;
end
end
