clc
clear
close all
%%
% set(0,'DefaultFigureWindowStyle','normal');
dim=[1024,1024];
obs=[105,100,30;300,400,80;800,78,66;700,150,201;555,777,200;512,512,24;700,200,90;900,900,10];
robotsize=120;
% map=ones(dim);
% for i=1:size(obs,1)
%     x=obs(i,1);
%     y=obs(i,2);
%     r=obs(i,3);
%     map(x,y)=1;
%     map(fix(-r/2)+x-1:fix(r/2)+x+1,fix(-r/2)+y-1:fix(r/2)+y+1)=0;
% end
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
figure
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
        %                 if(corner(2,3)==dim(1) && corner(1,2) ~= dim(1))
        %                     M(corner(1,1):corner(1,2),corner(2,3),:)=0;
        %                 elseif(corner(2,3)==dim(1) && corner(1,2) == dim(1))
        %                     M(corner(1,1):corner(1,2),corner(2,3),:)=0;
        %                 elseif(corner(1,2) == dim(1) && corner(1,4) == dim(1) && corner(2,4) == dim(1))
        %                     M(corner(1,2),corner(2,1):corner(2,3),:)=0;
        %                 end
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
        imshow(M)
    end
    currdim = currdim/2;
end
% figure
% imshow(Mtemp);
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
% %%
% fun=@(m,s)choice(m,s);
% % map2bw = imbinarize(map);
% % img2bw = map(:,:,1)
% S=qtdecomp(map,0.9);
% blocks = true(size(S));
% for dim = [64 32 16 8 4]
%     numblocks = length(find(S==dim));
%     if (numblocks > 0)
%         values = repmat(uint8(1),[dim dim numblocks]);
%         values(2:dim,2:dim,:) = 0;
%         blocks = qtsetblk(blocks,S,dim,values);
%     end
% end
% blocks(end,1:end) = 1;
% blocks(1:end,end) = 1;
% figure, imshow(blocks,[])
%
% blocks=imcomplement(blocks);
% figure, imshow(blocks,[])
% %29,21
% for i=1:size(obs,1)
%     x=obs(i,1);
%     y=obs(i,2);
%     r=obs(i,3);
%     blocks(fix(-r/2)+x-1:fix(r/2)+x+1,fix(-r/2)+y-1:fix(r/2)+y+1)=0;
% end
% figure, imshow(blocks,[])
%
%
%
% %% Centroid
% props=regionprops(blocks,'centroid','boundingbox');
% bc=[props.Centroid];
% bc=ceil(reshape(bc',2,[]));
% imshow(blocks)
% hold on
% numObj = numel(props);
% for k = 1 : numObj
%     plot(props(k).Centroid(1), props(k).Centroid(2), 'r.')
% end
% hold on
% %% Creazione dei rettangoli validi
% nodeList=rectNode.empty(0,1); %Primo valore
% id=1;
% for dim = [32 16 8 4]
%     [valMatrix, x, y] = qtgetblk(blocks, S, dim);
%     idx =[x,y];
%     if ~isempty(idx)
%         sz=size(idx,1);
%         for i=1:sz
%             lc=idx(i,:);
%             bct=[lc(2)+dim/2,lc(1)+dim/2];
%             if ~isempty(find(ismember(bc',bct,'rows'), 1))
%                 if lc(1)+dim > 64
%                     corner = lc(1)+dim -1;
%                 else
%                     corner = lc(1)+dim;
%                 end
%                 cUpLeft=[lc(1),lc(2)];
%                 cDWLeft=[lc(1)+dim,lc(2)];
%                 cUpRig=[lc(1),lc(2)+dim];
%                 cDWRig=[lc(1)+dim,lc(2)+dim];
%                 vert=horzcat(cUpLeft',cDWLeft',cUpRig',cDWRig');
%                 node = rectNode([bct(2),bct(1)],lc,dim,vert,id);
%                 nodeList(end+1)=node;
%                 id=id+1;
%             end
%
%             %             for k = 1:size(idx1,1)
%             %             plot(corner,lc(2),'bo','MarkerSize',5);
%             %             end
%         end
%     end
% end
%
% %% Adiacenze
% edges=[];
% hold on
% A = zeros(size(nodeList,2));
% for node=nodeList
%     id = node.id;
%     tempList=nodeList(~ismember(nodeList,findobj(nodeList,'id',id)));
%     % nodespace = borderLeft, borderTop, borderRight, borderDown
%     nodespace=borderSpace(node);
% %     plot(nodespace(1,:),nodespace(2,:),'g','markersize',5)
%     for t = tempList
%         tnodespace=borderSpace(t);
% %         plot(tnodespace(1,:),tnodespace(2,:),'r','markersize',3)
%         %Left
%         [in, on] = inpolygon(tnodespace(1,:),tnodespace(2,:),nodespace(1,:),nodespace(2,:));
%         temp = find(on);
%         minVert = tnodespace(:,min(temp));
%         maxVert = tnodespace(:,max(temp));
%         segDim = abs(minVert - maxVert);
%         segDim = segDim(segDim ~= 0,:);
%         maxSize = min(node.dim,t.dim);
%         if maxSize == segDim
%             node.setAdj(t.id);
%             A(node.id,t.id) = 1;
%             A(t.id,node.id) = 1;
%         end
%     end
% end
% %%
G = graph(A);
%% Plotting graph over image
% Plotting node id
hold on;
for node=nodeList
    text(node.bc(2),node.bc(1),int2str(node.id),'HorizontalAlignment','center');
end
%% Plotting Edges
hold on
for i=1:size(A,1)
    for j=1:size(A,2)
        if A(i,j)==1
            x1=findobj(nodeList,'id',i);
            x2=findobj(nodeList,'id',j);
            x1_coord=x1.bc;
            x2_coord=x2.bc;
            plot([x1_coord(2) x2_coord(2)],[x1_coord(1),x2_coord(1)],'w','LineWidth',3);
        end
    end
end
% P=shortestpath(G,7,41);
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


