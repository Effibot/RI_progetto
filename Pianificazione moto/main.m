clc 
clear 
close all
%%
dim=[50,50];
obs=[10,10,2;39,20,3;8,8,3;30,30,4;40,40,1;21,5,1;10,40,5];
cellsize=10;
robotsize=2;
map=Map(dim,obs,cellsize);
figure,imshow(map.grid)
map.populateMap(cellsize)
figure,imshow(map.grid)