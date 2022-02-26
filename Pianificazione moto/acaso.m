clc
clear all
close all
%%
m=ones(5,5);
for i=1:25
    m(i)=i;
end
disp(m);
fun = @(block_struct) acas(block_struct);
 blockproc(m,[2 2],fun);









%%

function ret= acas(val)
disp(val.data);
ret=val.data;
end
