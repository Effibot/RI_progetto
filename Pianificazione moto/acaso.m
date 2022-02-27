clc
clear all
close all
%%
dim=[64,64];
obs=[10,10,2;39,20,3;8,8,3;30,30,4;40,40,1;21,5,1;10,40,5];
div=divisors(dim(1));
cellsize=div(end-2);
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
fun=@choice;
S=qtdecomp(grid,@(matrix)choice({matrix,robotsize}));


% S=qtdecomp(grid,0.1,robotsize);
% blocks = repmat(uint8(1),size(S));
% 
% for dim = [ 64 32 16 8 4 2]
%   numblocks = length(find(S==dim));    
%   if (numblocks > 0)        
%     values = repmat(uint8(1),[dim dim numblocks]);
%     values(2:dim,2:dim,:) = 0;
%     blocks = qtsetblk(blocks,S,dim,values);
%   end
% end
% 
% blocks(end,1:end) = 1;
% blocks(1:end,end) = 1;
% grid=imcomplement(grid);
% blocks=imcomplement(blocks);
% for i=1:size(obs,1)
%                 x=obs(i,1);
%                 y=obs(i,2);
%                 r=obs(i,3);
%                 blocks(fix(-r/2)+x-1:fix(r/2)+x+1,fix(-r/2)+y-1:fix(r/2)+y+1)=254;
% end
% figure,imshow(grid), figure, imshow(blocks,[])
