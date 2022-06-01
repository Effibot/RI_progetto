clc
clear
close all
%% Setup
rng("default")
dim=[1024,1024];
% obs=[105,100,30;300,400,80;800,78,66;700,150,201;555,777,200;512,512,24;700,200,90;900,900,10];
robotsize = 48;
numObst = 10;
% obs = maprng(dim(1),dim(2), numObst);
% map = makeMap(obs,dim);
% save map.mat
% save obs.mat
load map.mat 
load obs.mat
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
circleColor = [0.0, 1.0, 1.0, 0.5];
circleColorObs=[0.623, 0.501, 0.635, 0.5];
robotColor = [1 1 0 0.7];
for i = 1:5
    endId = idList(randi(size(idList,2)));
    P = shortestpath(G, startId, endId);
    idList(ismember(idList,startId)) = [];
    [points,dudt] = pathfind(nodeList, P, Aint, Amid, rbclist);
    q=curvspace(points,size(points,1));
%Derivatives
dxdt = diff(q(:,1),[],1);
dydt= diff(q(:,2),[],1);
% quiver(q(2:end,1),q(2:end,2),dxdt,dydt);
%Distance between points
dist = norm(q(1,:)-q(2,:));
dnom=dist;
for ii = 2:size(q,1)-1
dist = [dist;norm(q(ii,:)-q(ii+1,:))];
end
% Mod V
a=[dxdt,dydt];
modV=norm(a(1,:));
modVn=modV;
for ii = 2:size(a,1)-1
modV = [modV;norm(a(ii,:))];
end
%     figure
%     hold on 
%     plot(points(:,1),points(:,2),'LineStyle','-','LineWidth',5);
s= plot(q(:,1),q(:,2),'*');
   ds= quiver(points(:,1),points(:,2),dudt(:,1),dudt(:,2));

    for j = 1:fix(size(points,1)/100):size(points,1)
        currPoint = points(j,:);
        [closestObs, minDist] = findClosestObs(rbclist, fliplr(currPoint));
        obsNode= findobj(nodeList,'bc',closestObs);
        radiusObs=sqrt(2)/2*obsNode.dim;
        radiusRobot=minDist-radiusObs;
        if radiusRobot>=robotsize/2
            circleColor = [0.0, 1.0, 1.0, 0.5];
        else
            circleColor = [0.780, 0, 0.050];

        end
        h = circle(currPoint(1), currPoint(2), radiusRobot, circleColor);

        hobs = circle(closestObs(2), closestObs(1), radiusObs, circleColorObs);

        robot = circle(currPoint(1), currPoint(2), robotsize/2, robotColor);
        ll = line([currPoint(1), closestObs(2)],...
            [currPoint(2), closestObs(1)],...
            'Color','#ca64ea','LineStyle','-.','LineWidth',3);
        pause(0.05)
        delete(h);
        delete(hobs);
        delete(robot)
        delete(ll);
    end
    delete(s);
    delete(ds);
end
%% plots
% figure(5)
% hold on
% fnplt(trajectory(1),'r')
% fnplt(trajectory(2),'b')
% fnplt(dppx,'g')
% fnplt(dppy,'y')
% legend('t v x', 't v y', 't v dx', 't v dy')
