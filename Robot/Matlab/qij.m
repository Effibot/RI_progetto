function M = qij(rt)
Avz=Av([0;0;1],rt(1,1),rt(1,2));
Avx=Av([1;0;0],rt(1,3),rt(1,4));
M=Avz*Avx;
end

