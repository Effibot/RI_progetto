clc
clear
close all
%% Setup
% rng("default")
dim=[1024,1024];
% obs=[105,100,30;300,400,80;800,78,66;700,150,201;555,777,200;512,512,24;700,200,90;900,900,10];
robotsize = 48;
numObst = 10;
% rng('default');
obs = maprng(dim(1),dim(2), numObst);
map = makeMap(obs,dim);
% load map.mat
% figure
imshow(map.value);
%% QT-Decomp
toSave = false;
toShow = false;
[M, nodeList] = splitandcolor(map, robotsize, toSave, toShow);
% figure
mapImg = imshow(M);
%% Adjiacency Matrix
[A, Acomp, Aint, Amid] = adjmatrix(nodeList, toShow);
%%
% figure,imshow(M);
G = graph(A);
%% Plotting graph over image
hold on
gPlot(nodeList, A, Amid, Aint);
% hold off
%% Find curve for given path and simulate movement
idList = [findobj(nodeList, 'prop', 'g').id];
startId = idList(randi(size(idList,2)));
tempList = idList;
tempList(ismember(idList,startId)) = [];
rbclist = getbcprop(nodeList, 'r');
circleColor = [0.0 1.0 1.0 0.5];
robotColor = [1 1 0 0.7];
for i = 1:5
    endId = idList(randi(size(idList,2)));
    P = shortestpath(G, startId, endId);
    idList(ismember(idList,startId)) = [];
    trajectory = pathfind(nodeList, P, Aint, Amid, robotsize, rbclist, true);
    points = pathfind(nodeList, P, Aint, Amid, robotsize, rbclist, false);
    pp = cscvn([points(:,1)'; points(:,2)']);
    fnplt(pp)
    dppx = fnder(trajectory(1));
    dppy = fnder(trajectory(2));
    for j = 1:fix(size(points,1)/100):size(points,1)
        currPoint = points(j,:);
        [closestObs, minDist] = findClosestObs(rbclist, fliplr(currPoint));
        h = circle(currPoint(1), currPoint(2), minDist, circleColor);
        robot = circle(currPoint(1), currPoint(2), robotsize/2, robotColor);
        ll = line([currPoint(1), closestObs(2)],...
            [currPoint(2), closestObs(1)],...
            'Color','#ca64ea','LineStyle','-.','LineWidth',3);
        pause()
        delete(h);
        delete(robot)
        delete(ll);
    end
end
%%

