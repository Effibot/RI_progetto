function [curve,dt] = pathfind(nodeList, idList, Aint, Amid, obsList)
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
            nPoints(end+1,:) = selectPoint(node, next, Amid, Aint, obsList);
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
    k = 100;    % sampling factor
    lengthCurve = arclength(nPoints(:,2),nPoints(:,1),'makima');

    density = lengthCurve/size(nPoints,1);
    [q,dt]=interparc(floor(k*density),nPoints(:,2)',nPoints(:,1)','makima');

    curve=q;

    %% Controllo errore sulle distanze tra un punto e il successivo
%         q=curvspace(q,size(q,1));
% q;
%     dist = norm(q(1,:)-q(2,:));
%     dnom=dist;
%     for i = 2:size(q,1)-1
%         dist = [dist;norm(q(i,:)-q(i+1,:))];
%         
%     end
% 
% %Derivatives
% dxdt = diff(q(:,1),[],1);
% dydt=diff(q(:,2),[],1);
%     a=[dxdt,dydt];
% modV=norm(a(1,:)-a(2,:));
% modVn=modV;
% for ii = 2:size(a,1)-1
% modV = [modV;norm(a(ii,:)-a(ii+1,:))];
% end
% bbb=abs(modV-modVn)
end

function point = selectPoint(node, next, Amid, Aint, obsList)

    pointInt = [Aint(node.id, next.id,1), Aint(node.id, next.id,2)];
    pointMid = [Amid(node.id, next.id,1), Amid(node.id, next.id,2)];

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

