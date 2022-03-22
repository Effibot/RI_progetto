clc
clear
close all
%%
dim=[1024,1024];
obs=[105,100,30;300,400,80;800,78,66;700,150,201;555,777,200;512,512,24;700,200,90;900,900,10];
robotsize=48;
map = makeMap(obs,dim);
figure
imshow(map.value);
%%
decomp(map, robotsize, 0.9);
nodeList = getAllNode(map, []);
M = 255 * repmat(uint8(map.value), 1, 1, 3);
Mtemp = map.value;
currdim = dim(1)/2;
id = 0;
while(currdim >= robotsize)
    mapList = findobj(nodeList, 'dim', currdim);
    for i = 1:size(mapList,1)
        mapList(i).id = id+1;
        id = id+1;
        corner = mapList(i).corner;
        upLeft =  corner(:,1)';
        dwnLeft = corner(:,2)';
        upRight = corner(:,3)';
        dwnRight = corner(:,4)';
        color=[];
        switch mapList(i).prop
            case 'y'
                color=[255, 160, 0];
            case 'g'
                color=[0,255,0];
            case 'r'
                color=[255,0,0];
        end
        M(corner(1,1):corner(1,2),corner(2,1):corner(2,3)) = mapList(i).value;
        %                         imshow(M)
        M(corner(1,1):corner(1,2),corner(2,1):corner(2,3),1)=color(1);
        %         Mtemp(corner(1,1):corner(1,2),corner(2,1):corner(2,3)) = 0;
        %                         imshow(M)
        M(corner(1,1):corner(1,2),corner(2,1):corner(2,3),2)=color(2);
        %         Mtemp(corner(1,1):corner(1,2),corner(2,1):corner(2,3))=0;
        %                         imshow(M)
        M(corner(1,1):corner(1,2),corner(2,1):corner(2,3),3)=color(3);
        %         Mtemp(corner(1,1):corner(1,2),corner(2,1):corner(2,3))=0;
        %                         imshow(M)
        M(corner(1,1):corner(1,2),corner(2,1),:)=0;
        Mtemp(corner(1,1):corner(1,2),corner(2,1))=0;
        M(corner(1,1),corner(2,1):corner(2,3),:)=0;
        Mtemp(corner(1,1),corner(2,1):corner(2,3))=0;
        %
        M(corner(1,3):corner(1,4),corner(2,3),:)=0;
        Mtemp(corner(1,3):corner(1,4),corner(2,3))=0;
        M(corner(1,2),corner(2,2):corner(2,4),:)=0;
        Mtemp(corner(1,2),corner(2,2):corner(2,4))=0;

        if corner(2,3)==dim(1)
            M(corner(1,1):corner(1,2),corner(2,3),:)=0;
            Mtemp(corner(1,1):corner(1,2),corner(2,3))=0;
        end
        if corner(1,2) == dim(1)
            M(corner(1,2),corner(2,1):corner(2,3),:)=0;
            Mtemp(corner(1,2),corner(2,1):corner(2,3))=0;
        end
        %         filename = "mapimage/cell"+num2str(mapList(i).id)+".jpg";
        %         imwrite(M,filename,'jpg');
%                 imshow(M)
    end
    currdim = currdim/2;
end
figure
imshow(M);
%%
nodeList = nodeList(~ismember(nodeList,findobj(nodeList,'prop','y')));
A = zeros(size(nodeList,2));
Acomp = zeros(size(nodeList,2));
for node=nodeList
    id = node.id;
    tempList=nodeList(~ismember(nodeList,findobj(nodeList,'id',id)));
    % nodespace = borderLeft, borderTop, borderRight, borderDown
    nodespace=borderSpace(node,1);
    %     plot(nodespace(1,:),nodespace(2,:),'g','markersize',5)
    for t = tempList
        tnodespace=borderSpace(t,0);
        %         plot(tnodespace(1,:),tnodespace(2,:),'r','markersize',3)
        %Left
        [in, on] = inpolygon(tnodespace(1,:),tnodespace(2,:),nodespace(1,:),nodespace(2,:));
        temp = find(on);
        if ~isempty(temp)
            %             %%
            %             plot(nodespace(1,:),nodespace(2,:))
            %             axis equal
            %
            %             hold on
            %             plot(tnodespace(1,in),...
            %                 tnodespace(2,in),'r+') % points inside
            %             plot(tnodespace(1,~in),...
            %                 tnodespace(2,~in),'bo') % points outside
            %             hold off
            %%
            minVert = tnodespace(:,min(temp));
            maxVert = tnodespace(:,max(temp));
            segDim = abs(minVert - maxVert);
            segDim = segDim(segDim ~= 0,:);
            maxSize = min(node.dim,t.dim);
            if maxSize >= segDim
                node.setAdj(t.id);
                Acomp(node.id,t.id) = 1;
                Acomp(t.id,node.id) = 1;
                if strcmp(node.prop,'g') && strcmp(t.prop,'g')
                    A(node.id,t.id) = 1;
                    A(t.id,node.id) = 1;
                end
            end
        end
    end
end
%%
% figure,imshow(M);
G = graph(A);
Aint=zeros([size(A),2]);
%% Plotting graph over image
% Plotting node id
hold on;
for node=nodeList
    text(node.bc(2),node.bc(1),int2str(node.id),'HorizontalAlignment','center');
end
%% Plotting Edges
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            x1=findobj(nodeList,'id',i);
            x2=findobj(nodeList,'id',j);
            x1_coord=x1.bc;
            x2_coord=x2.bc;
            xlimit=[x1.corner(2,2),x1.corner(2,3)];
            ylimit=[x1.corner(1,2),x1.corner(1,3)];
            xbox = xlimit([1 1 2 2 1]);
            ybox = ylimit([1 2 2 1 1]);
            [xi,yi] = polyxpoly([x2.bc(2) x1.bc(2)],[x2.bc(1) x1.bc(1)],xbox,ybox);
            Aint(i,j,:)=[yi,xi];
            plot(xi,...
                yi,'bo','MarkerSize',10) % points outside
            hold on
            plot([x1_coord(2) x2_coord(2)],[x1_coord(1),x2_coord(1)],'w','LineWidth',2);
        end
    end
end

%% Calculating trajectory
% s=60,t1=64,t2=85,t3=42
P = shortestpath(G,60,10);
% path ciclico
% P = [76 73 74 85 86 87 90 91 92 143 144 141 76]
trajectory=pathfind(nodeList, P, Aint, true);
points = pathfind(nodeList, P, Aint, false);
%% curve from trajectory
% coefs = trajectory(1).coefs;
% breaks = trajectory(1).breaks;
% time = linspace(breaks(1),breaks(end));
% f = zeros(size(coefs,1),size(time,2));
% for j = 1:size(coefs,1)
%     f(j,:) = polyval(coefs(j,:), time - breaks(j));
% end
pp = cscvn([points(:,1)';points(:,2)']);
fnplt(pp,'b')
dppx = fnder(trajectory(1));
dppy = fnder(trajectory(2));
% J = fndir(pp, eye(2))
% [d,m] = fnbrk(J,'dim','var');
% x = [1;1];
% jacobian = reshape(fnval(fndir(pp,eye(m)),x),d,m);
%% plots 
figure
fnplt(trajectory(1),'r')
hold on
fnplt(trajectory(2),'b')
fnplt(dppx,'g')
fnplt(dppy,'y')
legend('t v x', 't v y', 't v dx', 't v dy')
%%
% clc
% close all
% clear
% x = linspace(0, 1);
% y = 1./(x-1);
% sp = spline(x,y)
% dsp = fnder(sp)
% spval = fnval(dsp,x)
% figure
% fnplt(sp,'r')
% hold on
% plot(x,y,'-og')
% fnplt(dsp,'jumps','y')
% plot(1,1,'BO')
% x = fnzeros(pp)
% nz = size(x,2);
% hold on
% plot(x(1,:),zeros(1,nz),'r>',x(2,:),zeros(1,nz),'r<','MarkerSize',10)
% hold off
%%
% %% K per scegliere se mi espando e basta
function r=borderSpace(node,k)
borderLeft = linspace(node.corner(1,1)-k,node.corner(1,2)+k);
borderLeft = [(node.corner(2,1)-k)*ones(size(borderLeft));borderLeft];
borderTop = linspace(node.corner(2,1)-k,node.corner(2,3)+k);
borderTop = [borderTop;(node.corner(1,1)-k)*ones(size(borderTop))];
borderRight = linspace(node.corner(1,3)-k,node.corner(1,4)+k);
borderRight = [(node.corner(2,3)+k)*ones(size(borderRight));borderRight];
borderDown = linspace(node.corner(2,2)-k,node.corner(2,4)+k);
borderDown = [borderDown;(node.corner(1,4)+k)*ones(size(borderDown))];
r = horzcat(borderLeft,borderTop,borderRight,borderDown);
end
