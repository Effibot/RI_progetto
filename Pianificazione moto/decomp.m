function  decomp(obj,minDim,thresh)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
children=Cell1.empty;
grid=obj.value;
maximum=grid(find(ismember(grid, max(grid(:))),1));
minimum=grid(find(ismember(grid, min(grid(:))),1));

if maximum-minimum>thresh && size(grid,1)/2>minDim
    dim=size(grid,1)/2;
    endIndex=size(grid,2);
    grid1=grid(1:dim,1:dim);
    grid2=grid(1:dim,dim:end-1);
    grid3=grid(dim:end-1,1:dim);
    grid4=grid(dim:end-1,dim:end-1);
    child1=Cell1(grid1,[1:dim,1:dim]);
    child2=Cell1(grid2,[1:dim,1:dim:endIndex]);
    child3=Cell1(grid3,[dim:endIndex,1:dim]);
    child4=Cell1(grid4,[dim:endIndex,dim:endIndex]);
    children=[child1,child2,child3,child4];
    obj.addChildren(child1);
    obj.addChildren(child2);
    obj.addChildren(child3);
    obj.addChildren(child4);
end
for i=children
    decomp(i,minDim,thresh);
end
end

