clc
close all
clear all
%%
dim=[64,64];
obs=[10,10,2;39,20,3;8,8,3;30,30,4;40,40,1;21,5,1;10,40,5];
robotsize=2;
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
childrenList=[];

decomp(map,robotsize,0.9,Cell1.empty);
blankMap=ones(dim);
figure
blockedMap=drawMap(blankMap,map);
imshow(blockedMap);
%%


%%
function blankMap=drawMap(blankMap,mapCell)
for cell=mapCell.children
    if~isempty(cell) && ~isempty(cell.father)
        blockCell=cell.value;
        idx=cell.idx;
        dim=size(blockCell,1);
%         idxf=cell.father(1).idx;
%         dim=size(blockCell,1);
% %         
%         if isequal(idxf,idx)%Inizio dal padre
%             idxStartX=1;
%             idxEndX=dim;
%             idxStartY=1;
%             idxEndY=dim;
%         elseif idx(1)==idxf(1) %Blocco a destra adiacente
%             idxStartX=idx(1);
%             idxEndX=dim;
%             idxStartY=idx(2)+1;
%             idxEndY=idx(2)+dim;
%         elseif idx(2)==idxf(2) %Blocco in basso a sinistra
%             idxStartX=idx(1)+1;
%             idxEndX=dim+idx(1);
%             idxStartY=idx(2);
%             idxEndY=dim;
%         else
%             idxStartX=idx(1)+1;
%             idxEndX=dim+idx(1);
%             idxStartY=idx(2);
%             idxEndY=dim+idx(2);
%         end
%         blankMap(idxStartX:idxEndX,idxStartY)=0;
%         blankMap(idxStartX,idxStartY:idxEndY)=0;
%         blankMap(idxEndX,idxStartY:idxEndY)=0;
%         blankMap(idxStartX:idxEndX,idxEndY)=0;
        blankMap(idx(1):idx(1)+dim-1,idx(2):idx(2)+dim-1)=blockCell;
        blankMap=drawMap(blankMap,cell);
    end
end
end
