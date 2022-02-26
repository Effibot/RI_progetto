clc 
clear 
close all
%%
dim=[50,50];
obs=[10,10,2;39,20,3;8,8,3;30,30,4;40,40,1;21,5,1;10,40,5];
div=divisors(dim(1));
cellsize=div(end-2);
robotsize=4;
map=Map(dim,obs,cellsize,robotsize);
figure,imshow(map.grid)
map.populateMap(cellsize);
% disp(map);
figure,imshow(map.grid);
disp("Valori sottocelle");
map.findCollision();
img=map.drawCell();
figure,imshow(img)
