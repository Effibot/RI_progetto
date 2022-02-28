clc
clear all
close all
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
fun=@(m,s)choice(m,s);
S=qtdecomp(grid,0.9);
blocks = true(size(S));
for dim = [64 32 16 8 4]
    numblocks = length(find(S==dim));
    if (numblocks > 0)
        values = repmat(uint8(1),[dim dim numblocks]);
        values(2:dim,2:dim,:) = 0;
        blocks = qtsetblk(blocks,S,dim,values);
    end
end
blocks(end,1:end) = 1;
blocks(1:end,end) = 1;
blocks=imcomplement(blocks);
for i=1:size(obs,1)
    x=obs(i,1);
    y=obs(i,2);
    r=obs(i,3);
    blocks(fix(-r/2)+x-1:fix(r/2)+x+1,fix(-r/2)+y-1:fix(r/2)+y+1)=0;
end
figure, imshow(blocks,[])


% blocks=true(size(S));
% 
% for dim = [64 32 16 8 4 2]
%     numblocks = length(find(S==dim));
%     if (numblocks > 0)
%         values = repmat(uint8(1),[dim dim numblocks]);
%         values(2:dim,2:dim,:) = 0;
%         blocks = qtsetblk(blocks,S,dim,values);
%     end
% end
% blocks(end,1:end) = 1;
% blocks(1:end,end) = 1;
% blocks=imcomplement(blocks);
% for i=1:size(obs,1)
%     x=obs(i,1);
%     y=obs(i,2);
%     r=obs(i,3);
%     blocks(fix(-r/2)+x-1:fix(r/2)+x+1,fix(-r/2)+y-1:fix(r/2)+y+1)=0;
% end
% figure, imshow(blocks,[])
%% Filling Holes
% for dim=[64 32 16 8 4 2]
%     [vals,r,c]=qtgetblk(grid,S,4);
%     for i=1:size(r,1)
%         x=r(i);
%         y=c(i);
%         offsetX=x+size(vals(:,:,i),1)-1;
%         offsetY=y+size(vals(:,:,i),2)-1;
%         square=getIdx(x,y,offsetX,offsetY);
%         if ~isempty(find(ismember(double(blocks(x:offsetX,y:offsetY)),1), 1))
% %             blocks(x:offsetX-1,y:offsetY-1)=0(size(offsetX-x,offsetY-y));
% %             grid(x:offsetX-1,y:offsetY-1)=0;
%         end
%         
%     end
% end
% figure, imshow(blocks,[])


for i=obs'
    upperLeft=[i(1),i(2)]-[i(3),i(3)];
    upperRight=[i(1),i(2)]+[i(3),-i(3)];
    bottomLeft=[i(1),i(2)]+[-i(3),i(3)];
    bottomRight=[i(1),i(2)]+[i(3),i(3)];
    corners=[upperLeft,upperRight,bottomLeft,bottomRight];
    
end



%% Centroid
bc=regionprops(blocks,'centroid');

centroids = cat(1,bc.Centroid);
figure
imshow(blocks)
hold on
plot(centroids(:,1),centroids(:,2),'b*')
hold off
% obsregions=obsReg(obs);
% edge=makeedge(bc,obs);
%%
% 
% function edges=makeedge(bc,obs)
% syms x f(x);
% edge=double.empty(0,2);
% dim=size(obs,1);
% for x1=bc  
%     for x2=bc
%         if ~isequal(x,y)
%             f(x)=(x2(2)-x1(2))*(x-x1(1))/(x2(1)-x1(1))+x2(1);
%             for i=1:dim
%                 y=f(obs(i,1))~=obs(i,2)%Ostacolo non interseca i baricentri
%                 
%             end
%         end
%     end
% end
% end

% %% Obs regions
% function points=obsReg(obs)
% points=double.empty(0,2);
% for i=1:size(obs,1)
%     x=obs(i,1);
%     y=obs(i,2);
%     r=obs(i,3);
%     x_val=fix(-r/2)+x-1:fix(r/2)+x+1;
%     for i=x_val
%         pointx=i*ones(r,1);
%         points=vertcat(points,horzcat(pointx,y:r+y-1));
%     end
%     y_val=fix(-r/2)+y-1:fix(r/2)+y+1;
% end
% end
%%
% function idx=getIdx(x,y,offsetX,offsetY)
% idx=double.empty(0,2);
% for i=x:offsetX
%     idx=vertcat(idx,[i*ones(1,offsetX-x+1);y:offsetY]');
% end
% end

