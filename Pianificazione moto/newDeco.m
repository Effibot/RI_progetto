clc
close all
clear all
%%
dim=[64,64];
obs=[10,10,2;39,20,3;8,8,3;30,30,4;40,40,1;21,5,1;10,40,5];
robotsize=4;
grid=ones(dim);
for i=1:size(obs,1)
    x=obs(i,1);
    y=obs(i,2);
    r=obs(i,3);
    grid(x,y)=1;
    grid(fix(-r/2)+x-1:fix(r/2)+x+1,fix(-r/2)+y-1:fix(r/2)+y+1)=0;
end
figure,imshow(grid);
map=Cell1(grid,[1,1],64);

l_32=decomp(map,robotsize,0.9);
% blankMap=ones(dim);
% figure
% blockedMap=drawMap(blankMap,map);
% imshow(blockedMap);
%%
figure
gridNew=ones(64,64);
for i=l_32
    grid=i.value;
    idx=i.idx;
    dim=size(grid,1);
    gridNew(idx(1)+1:idx(1)+size(grid,1),idx(2)+1:idx(2)+size(grid,1))=grid;
    
    imshow(gridNew);
    
end
%%
gridNew=ones(64,64);
l_16=[];
for i=l_32
    l_16=[l_16,i.children];
end
l_8=[];
for i=l_16
    l_8=[l_8,i.children];
end
l_4=[];
for i=l_8
    l_4=[l_4,i.children];
end
%%
allnodes=[l_32,l_16,l_8,l_4];
for y=allnodes
    disp(y.bc)
end
%%
figure
gridNew=ones(64,64);
gridM=plott(gridNew,allnodes);
imshow(gridM);
function gridNew=plott(gridNew,map)
for i=map
    grid=i.value;
    %     imshow(grid);
    idx=i.idx;
    dim=size(grid,1);
    
    idxf=i.father.idx;
    fatherdim=size(i.father.value,1);
    disp(i.father.idx);
    disp(idx);
    if isequal(idxf,[1,1])
        disp("1");
        if idx(1)==1 && idx(2)==1 %[1,1]
            gridNew(idx(1):dim,idx(2):dim)=grid;
        elseif idx(1)==1 && idx(2)~=1 %[1,16]
            gridNew(idx(1):dim,idx(2)+1:idx(2)+dim)=grid;
        elseif idx(1)~=1 && idx(2)==1 %[16,1]
            gridNew(idx(1)+1:idx(1)+dim,idx(2):dim)=grid;
        else %[16,16]
            gridNew(idx(1)+1:idx(1)+dim,idx(2)+1:dim+idx(2))=grid;
        end
    elseif isequal(idxf,[1,32])
        disp("2");%f=[1,32]
        if idx(1)==1 && idx(2)==1 %[1,1]
            gridNew(idx(1):dim,idx(2)+idxf(2):dim+idxf(2))=grid;
        elseif idx(1)==1 && idx(2)~=1 %[1,16]
            gridNew(idx(1):dim,idx(2)+idxf(2)+1:end)=grid;
        elseif idx(1)~=1 && idx(2)==1 %[16,1]
            gridNew(idxf(1)+idx(1):idx(1)+dim,idxf(2)+1:dim+idxf(2))=grid;
        else %[16,16]
            gridNew(idxf(1)+idx(1)+1:idx(1)+idxf(1)+dim,idx(2)+idxf(2)+1:end)=grid;
        end
    elseif isequal([32,1],idxf)
        disp("3");%f=[32,1]
        if idx(1)==1 && idx(2)==1 %[1,1]
            gridNew(idx(1)+idxf(1)+1:idx(1)+dim+idxf(1),idx(2):dim)=grid;
        elseif idx(1)==1 && idx(2)~=1 %[1,16]
            gridNew(idx(1)+idxf(1):dim+idxf(1),idx(2)+1:idx(2)+dim)=grid;
        elseif idx(1)~=1 && idx(2)==1 %[16,1]
            gridNew(idxf(1)+idx(1)+1:end,idx(2):dim)=grid;
        else %[16,16]
            gridNew(idxf(1)+idx(1)+1:end,idx(2)+idxf(2)+1:idx(2)+idxf(2)+dim)=grid;
        end
    elseif isequal([32,32],idxf)
        disp("4");%f=[32 32]
        if idx(1)==1 && idx(2)==1 %[1,1]
            gridNew(idx(1)+idxf(1):idxf(1)+dim,idxf(2)+idx(2):idxf(2)+dim)=grid;
        elseif idx(1)==1 && idx(2)~=1 %[1,16]
            gridNew(idx(1)+idxf(1)+1:idx(1)+idxf(1)+dim,idxf(2)+idx(2)+1:end)=grid;
        elseif idx(1)~=1 && idx(2)==1 %[16,1]
            gridNew(idxf(1)+idx(1)+1:end,idx(2):dim)=grid;
        else %[16,16]
            gridNew(idxf(1)+idx(1)+1:end,idx(2)+idxf(2)+1:end)=grid;
        end
    end
    imshow(gridNew);
    hold on;
end
end

% imshow(gridNew);
