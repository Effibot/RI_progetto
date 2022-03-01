function l= decomp(obj,minDim,thresh,father,~)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
l=Cell1.empty;
children=Cell1.empty;
grid=obj.value;
father=obj;
maximum=grid(find(ismember(grid, max(grid(:))),1));
minimum=grid(find(ismember(grid, min(grid(:))),1));

if maximum-minimum>thresh && size(grid,1)/2>minDim
    dim=size(grid,1)/2;
    grid1=grid(1:dim,1:dim);
    grid2=grid(1:dim,dim+1:end);
    grid3=grid(dim+1:end,1:dim);
    grid4=grid(dim+1:end,dim+1:end);
    %     imshow(grid1);
    %     hold on;
    %     imshow(grid2);
    %     hold on;
    %     imshow(grid3);
    %     hold on;
    %     imshow(grid4);
    %     hold on;
    child1=Cell1(grid1,[1,1],dim);
    child2=Cell1(grid2,[1,dim],dim);
    child3=Cell1(grid3,[dim,1],dim);
    child4=Cell1(grid4,[dim,dim],dim);
    children=[child1,child2,child3,child4];
    obj.addChildren(child1,father);
    obj.addChildren(child2,father);
    obj.addChildren(child3,father);
    obj.addChildren(child4,father);
        l=[l,children];

    obj.setAllChildren(child1);
        obj.setAllChildren(child2);
    obj.setAllChildren(child3);
    obj.setAllChildren(child4);

elseif  isequal(grid,ones(size(grid)))
    disp("No figli...");
    disp(obj.value);
    dim=size(grid);
    child=Cell1(grid,[1,1],dim);
    obj.addChildren(child,father);
    l=[l,child];
        obj.setAllChildren(child);

elseif isequal(grid,zeros(size(grid))) ||  size(grid,1)/2<minDim
    disp("Ostacolo...")
    disp(obj.value)
    dim=size(grid);
    
    child=Cell1(zeros(size(grid)),[1,1],dim);
    child.obstacles=1;
    obj.addChildren(child,father);
    l=[l,children];
        obj.setAllChildren(child);

end
for i=children
    decomp(i,minDim,thresh,obj,l)
end

