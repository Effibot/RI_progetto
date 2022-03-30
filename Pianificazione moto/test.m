clc
clear
close all
%%
rng("default")
dim=[1024,1024];
% obs=[105,100,30;300,400,80;800,78,66;700,150,201;555,777,200;512,512,24;700,200,90;900,900,10];
robotsize=48;
numObst = 10;
% rng('default');
obs = maprng(dim(1),dim(2), numObst);
% map = makeMap(obs,dim);
load map.mat
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
%                 color = [255 255 255 0];
            case 'r'
                color=[255,0,0];
        end
%         if strcmp(mapList(i).prop, 'r')
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
%         end
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
Amid = zeros([size(A),2]);
for node=nodeList
    id = node.id;
    tempList=nodeList(~ismember(nodeList,findobj(nodeList,'id',id)));
    % nodespace = borderLeft, borderTop, borderRight, borderDown
    nodespace=unique(borderSpace(node,1)','rows','stable')';
    %     plot(nodespace(1,:),nodespace(2,:),'g','markersize',5)
    for t = tempList
        tnodespace=unique(borderSpace(t,0)','rows','stable')';
        %         plot(tnodespace(1,:),tnodespace(2,:),'r','markersize',3)
        [in, on] = inpolygon(tnodespace(1,:),tnodespace(2,:),nodespace(1,:),nodespace(2,:));
        temp = find(on);
        if ~isempty(temp)            
%             plot(nodespace(1,:),nodespace(2,:))
%             axis equal
% 
%             hold on
%             plot(tnodespace(1,in),...
%                 tnodespace(2,in),'r+') % points inside
%             plot(tnodespace(1,~in),...
%                 tnodespace(2,~in),'bo') % points outside
%             hold off
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
                            [in, on] = inpolygon(tnodespace(1,:),tnodespace(2,:),nodespace(1,:),nodespace(2,:));

                    commonborder = tnodespace(:,in);
                    
                    Amid(node.id, t.id, :) = flipud(commonborder(:,fix(size(commonborder,2)/2)));
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
% Plotting Edges
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
%             plot(xi,...
%                 yi,'bo','MarkerSize',10) % points outside
%             hold on
%             plot([x1_coord(2) x2_coord(2)],[x1_coord(1),x2_coord(1)],'w','LineWidth',2);
%             plot(Amid(i,j,2),...
%                 Amid(i,j,1),'r*','MarkerSize',10)
        end
    end
end
%%
ostacle=[];
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
