function [A, Acomp, Aint, Amid] = adjmatrix(nodeList, toShow)
    nodeList = nodeList(~ismember(nodeList,findobj(nodeList,'prop','y')));
    A = zeros(size(nodeList,2));
    Acomp = zeros(size(nodeList,2));
    Amid = zeros([size(A),2]);
    Aint = zeros([size(A),2]);
    for node=nodeList
        id = node.id;
        tempList = nodeList(~ismember(nodeList,findobj(nodeList,'id',id)));
        % nodespace = borderLeft, borderTop, borderRight, borderDown
        nodespace = unique(borderSpace(node,1)','rows','stable')';
        %     plot(nodespace(1,:),nodespace(2,:),'g','markersize',5)
        for t = tempList
            tnodespace = unique(borderSpace(t,0)','rows','stable')';
            [in, on] = inpolygon(tnodespace(1,:),tnodespace(2,:),...
                nodespace(1,:),nodespace(2,:));
            temp = find(on);
            if ~isempty(temp)
                if toShow
                    figure
                    plot(nodespace(1,:),nodespace(2,:))
                    axis equal
                    hold on
                    plot(tnodespace(1,in),...
                        tnodespace(2,in),'r+') % points inside
                    plot(tnodespace(1,~in),...
                        tnodespace(2,~in),'bo') % points outside
                    hold off
                end
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
                        commonborder = tnodespace(:,in);
                        Amid(node.id, t.id, :) = flipud(commonborder(:,fix(size(commonborder,2)/2)));;
                        [yi, xi] = findintersection(node,t);
                        Aint(node.id,t.id,:) = [yi, xi];
                    end
                end
            end
        end
    end
    Aint = fixmeasure(Aint);
    Amid = fixmeasure(Amid);
end
function Afix = fixmeasure(A)
    Afix = A;
    for i = 1:size(A,1)
        for j = 1:size(A,1)
            if A(i,j,1) ~= A(j,i,1) || A(i,j,2) ~= A(j,i,2)
                y = (A(i,j,1) + A(j,i,1)) /2;
                x = (A(i,j,2) + A(j,i,2)) /2;                              
                Afix(i,j,:) = [y, x];
                Afix(j,i,:) = [y, x];
            end
        end
    end
    
end