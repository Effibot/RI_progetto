clc
clear
close all
%% Setup 
rng("default")
dim=[1024,1024];
% obs=[105,100,30;300,400,80;800,78,66;700,150,201;555,777,200;512,512,24;700,200,90;900,900,10];
robotsize=48;
numObst = 10;
% rng('default');
obs = maprng(dim(1),dim(2), numObst);
% map = makeMap(obs,dim);
load map.mat
% figure
% imshow(map.value);
%% QT-Decomp
toSave = false;
toShow = false;
[M, nodeList] = splitandcolor(map, robotsize, toSave, toShow);
figure
mapImg = imshow(M);
%% Adjiacency Matrix 
[A, Acomp, Aint, Amid] = adjmatrix(nodeList, toShow);
%%
% figure,imshow(M);
G = graph(A);
%% Plotting graph over image
% Plotting node id
hold on
gPlot(nodeList, A, Amid, Aint);
hold off
%%
ostacle=[];
%% refactoring da qui
for i=1:size(nodeList,2)
        nod=nodeList(i);
        if strcmp(nod.prop,'r')
           
            ostacle(end+1,:)=nod.bc;
            x1_coord=nod.bc;
            
            hold on
            plot([x1_coord(2)],[x1_coord(1)],'bo','LineWidth',2);
    
        end
end
%%
gidList = [findobj(nodeList, 'prop', 'g').id];
ridList = [findobj(nodeList, 'prop', 'r').id];

n = findobj(nodeList,'id', gidList(randi(size(gidList,2))));
obsbcs = reshape([findobj(nodeList, 'prop', 'r').bc]',[67,2]);
[obsbc, mindist] = findClosestObs(ostacle, n.bc)
closest = findobj(nodeList,'id', ...
    ridList(ismember(obsbcs,obsbc,'rows')))
plot(n.bc(2),n.bc(1),'ro','MarkerSize',10)
plot(obsbc(2), obsbc(1),'wo', 'Markersize',10)
line([n.bc(2),obsbc(2)],[n.bc(1), obsbc(1)],'Color','#ca64ea','LineStyle','-.','LineWidth',3)
h = circle(n.bc(2),n.bc(1),mindist)
%%
gidbc = fliplr(reshape([findobj(nodeList, 'prop', 'g').bc],[],2));
ridbc = fliplr(reshape([findobj(nodeList, 'prop', 'r').bc],[],2));
figure()
plot(gidbc(:,1),gidbc(:,2),'*','color','g');
hold on
plot(ridbc(:,1),ridbc(:,2),'o','color','r');
