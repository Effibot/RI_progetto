function curve = pathfind(nodeList, idList, Aint)
    % nodeList: lista di nodi che compongono il path
    % Aint: matrice n x n x 2 di componenti [x,y]

    % costruisco sequenza di punti in cui far passare il path
    dimPath = size(idList,2);
    for i = 1:dimPath -1
        node = findobj(nodeList,'id', idList(i));
        next = findobj(nodeList, 'id', idList(i+1));
        if ~isempty(node) || ~isempty(next)
            nPoints(end+1,:) = node.bc;
            nPoints(end+1,:) = Aint(node.id,next.id,:);
            nPoints(end+1,:) = next.bc;
        end
    end

    % Risolvo equazioni per calcolare le spline

    % calcolo coefficiente angolare tra due punti
    for i = 1:size(nPoints,2)-1 
        curr = nPoints(i);
        next = nPoints(i+1);        
        eq = point2rect(curr(1),curr(2),next(1),next(2));
        m = diff(eq,x);
        
    end
end

function eq = point2rect(x0,y0,x1,y1)
    sym x y
    if x1 == x0
        eq = x - x0 == 0;    
    else
        m = -(y0-y1)/(x0-x1);
        eq = y - y0 == m*(x-x0);
    end
end