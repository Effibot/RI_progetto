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
figure, imshow(blocks,[])

blocks=imcomplement(blocks);
figure, imshow(blocks,[])
%29,21
for i=1:size(obs,1)
    x=obs(i,1);
    y=obs(i,2);
    r=obs(i,3);
    blocks(fix(-r/2)+x-1:fix(r/2)+x+1,fix(-r/2)+y-1:fix(r/2)+y+1)=0;
end
figure, imshow(blocks,[])



%% Centroid
props=regionprops(blocks,'centroid','boundingbox');
bc=[props.Centroid];
bc=ceil(reshape(bc',2,[]));
imshow(blocks)
hold on
numObj = numel(props);
for k = 1 : numObj
    plot(props(k).Centroid(1), props(k).Centroid(2), 'r.')
end
hold on
%% Creazione dei rettangoli validi
nodeList=rectNode.empty(0,1); %Primo valore
id=1;
for dim = [32 16 8 4]
    [valMatrix, x, y] = qtgetblk(blocks, S, dim);
    idx =[x,y];
    if ~isempty(idx)
        sz=size(idx,1);
        for i=1:sz
            lc=idx(i,:);
            bct=[lc(2)+dim/2,lc(1)+dim/2];
            if ~isempty(find(ismember(bc',bct,'rows'), 1))
                if lc(1)+dim > 64
                    corner = lc(1)+dim -1;
                else
                    corner = lc(1)+dim;
                end
                cUpLeft=[lc(1),lc(2)];
                cDWLeft=[lc(1)+dim,lc(2)];
                cUpRig=[lc(1),lc(2)+dim];
                cDWRig=[lc(1)+dim,lc(2)+dim];
                vert=horzcat(cUpLeft',cDWLeft',cUpRig',cDWRig');
                node = rectNode([bct(2),bct(1)],lc,dim,vert,id);
                nodeList(end+1)=node;
                id=id+1;
            end
            
            %             for k = 1:size(idx1,1)
            %             plot(corner,lc(2),'bo','MarkerSize',5);
            %             end
        end
    end
end

%% Adiacenze
edges=[];
hold on
A = zeros(size(nodeList,2));
for node=nodeList
    id = node.id;    
    tempList=nodeList(~ismember(nodeList,findobj(nodeList,'id',id)));
    % nodespace = borderLeft, borderTop, borderRight, borderDown
    nodespace=borderSpace(node);
%     plot(nodespace(1,:),nodespace(2,:),'g','markersize',5)
    for t = tempList        
        tnodespace=borderSpace(t);
%         plot(tnodespace(1,:),tnodespace(2,:),'r','markersize',3)
        %Left
        [in, on] = inpolygon(tnodespace(1,:),tnodespace(2,:),nodespace(1,:),nodespace(2,:));        
        temp = find(on);
        minVert = tnodespace(:,min(temp));
        maxVert = tnodespace(:,max(temp));
        segDim = abs(minVert - maxVert);
        segDim = segDim(segDim ~= 0,:);
        maxSize = min(node.dim,t.dim);
        if maxSize == segDim
            node.setAdj(t.id);
            A(node.id,t.id) = 1;
            A(t.id,node.id) = 1;
        end
    end    
end
%%
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
            plot([x1_coord(2) x2_coord(2)],[x1_coord(1),x2_coord(1)],'g');
        end
    end
end
P=shortestpath(G,7,41);
%%
function r=borderSpace(node)
    borderLeft = linspace(node.corner(1,1),node.corner(1,2));
    borderLeft = [node.corner(2,1)*ones(size(borderLeft));borderLeft];
    borderTop = linspace(node.corner(2,1),node.corner(2,3));
    borderTop = [borderTop;node.corner(1,1)*ones(size(borderTop))];
    borderRight = linspace(node.corner(1,3),node.corner(1,4));
    borderRight = [node.corner(2,3)*ones(size(borderRight));borderRight];
    borderDown = linspace(node.corner(2,2),node.corner(2,4));
    borderDown = [borderDown;node.corner(1,4)*ones(size(borderDown))];
    r = horzcat(borderLeft,borderTop,borderRight,borderDown);
end



