function gPlot(nodeList, A, Amid, Aint)
    nodeList = nodeList(~ismember(nodeList,findobj(nodeList,'prop','y')));
    for i=1:size(A,1)
        % Disegno l'id del nodo
        nodeA = findobj(nodeList,'id',i);
        if ~isempty(nodeA)
            text(nodeA.bc(2),nodeA.bc(1),int2str(nodeA.id),...
                'HorizontalAlignment','center');
        end
        for j=1:size(A,2)
            if A(i,j)==1
                nodeB = findobj(nodeList,'id',j);
                % Disegno l'arco tra due nodi adiacenti
                nodeA_bc = nodeA.bc;
                nodeB_bc = nodeB.bc;
                plot([nodeA_bc(2) nodeB_bc(2)],[nodeA_bc(1),nodeB_bc(1)],...
                    'w','LineWidth',2);
                % Disegno il punto di intersezione
                plot(Aint(i,j,2), Aint(i,j,1),'bo','MarkerSize',10);
                % Disegno punto intermedio del bordo cella
                plot(Amid(i,j,2), Amid(i,j,1),'r*','MarkerSize',10)
            end
        end
    end
end