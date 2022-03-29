function curve = pathfind(nodeList, idList, Aint, Amid, robotSize, obsList, pp)
    % nodeList: lista di nodi che compongono il path
    % Aint: matrice n x n x 2 di componenti [x,y]
    % costruisco sequenza di punti in cui far passare il path
    dimPath = size(idList,2);
    nPoints = double.empty(0,2);
    for i = 1:dimPath -1
        node = findobj(nodeList, 'id', idList(i));
        next = findobj(nodeList, 'id', idList(i+1));
        if (~isempty(node) || ~isempty(next))
            if isempty(ismember(nPoints,node.bc,'rows'))
                nPoints(end+1,:) = node.bc;
            end
            %             nPoints(end+1,:) = Amid(node.id,next.id,:);
            %             nPoints(end+1,:) = Aint(node.id,next.id,:);
            nPoints(end+1,:) = selectPoint(node, next, Amid, Aint, robotSize, obsList);
            nPoints(end+1,:) = next.bc;
        end
    end
    % individuo potenziali angoli retti
    offset = 1;
    for i = 1:size(nPoints,1)-2
        if nPoints(i,1) == nPoints(i+1,1) &&...
                nPoints(i+1,2) == nPoints(i+2,2) || ...
                nPoints(i,2) == nPoints(i+1,2) && ...
                nPoints(i+1,1) == nPoints(i+2,1)
            % ho trovato un angolo retto
            if nPoints(i,1) < nPoints(i+2,1)
                % angolo verso il basso
                nPoints(i+1,1) = nPoints(i+1,1) + offset;
            else
                % angolo verso l'alto
                nPoints(i+1,1) = nPoints(i+1,1) - offset;
            end
            if nPoints(i,2) < nPoints(i+2,2)
                % angolo da sinistra
                nPoints(i+1,2) = nPoints(i+1,2) - offset;
            else
                % angolo da destra
                nPoints(i+1,2) = nPoints(i+1,2) + offset;
            end
        end
    end
    % Risolvo equazioni per calcolare le spline
    t = 0:1:size(nPoints,1)-1;  % waypoints
    k = 1000;    % sampling factor
    tq = t(1):1/k:t(end);   % symtime
    % makima permette di creare curve di tipo C1
    if pp
        curvex = spline(t,nPoints(:,2));
        curvey = spline(t,nPoints(:,1));
    else
        curvex = spline(t,nPoints(:,2),tq);
        curvey = spline(t,nPoints(:,1),tq);
    end
    curve = [curvex',curvey'];
    %% plot section
    %     figure
    %     subplot(1,3,1)
    %     plot(tq,curvex,'r');
    %     title('t vs x')
    %     subplot(1,3,2)
    %     plot(tq,curvey,'g')
    %     title('t vs y')
    %     subplot(1,3,3)
    %     plot(curvex,curvey,'b')
    %     title('x vs y')

end

function point = selectPoint(node, next, Amid, Aint, robotSize, obsList)
    %     if size(node.value,1) > robotSize && ...
    %             size(next.value,1) > robotSize
    %         point = Aint(node.id, next.id,:);
    %     else
    %         point = Amid(node.id, next.id,:);
    %     end
    pointInt = Aint(node.id, next.id,:);
    pointMid = Amid(node.id, next.id,:);

    [closestObstInt, minDistInt] = findClosestObs(obsList, pointInt);
    [closestObstMid, minDistMid] = findClosestObs(obsList, pointMid);

    if isequal(closestObstMid, closestObstInt)
        if minDistInt >= minDistMid
            point = pointInt;
        else
            point = pointMid;
        end
    else
        point = (pointInt+pointMid)/2;
    end
end

