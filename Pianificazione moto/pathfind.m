function curve = pathfind(nodeList, idList, Aint)
    % nodeList: lista di nodi che compongono il path
    % Aint: matrice n x n x 2 di componenti [x,y]

    % costruisco sequenza di punti in cui far passare il path
    dimPath = size(idList,2);
    nPoints=double.empty(0,2);
    for i = 1:dimPath -1
        node = findobj(nodeList,'id', idList(i));
        next = findobj(nodeList, 'id', idList(i+1));
        if ~isempty(node) || ~isempty(next)
            nPoints(end+1,:) = node.bc;
            nPoints(end+1,:) = Aint(node.id,next.id,:);
            nPoints(end+1,:) = next.bc;
        end
    end
    nPoints = unique(nPoints, 'rows','stable');

    % Risolvo equazioni per calcolare le spline
    t = 0:1:size(nPoints,1)-1;  % waypoints    
    k = 100;    % sampling factor
    tq = t(1):1/k:t(end);   % symtime
    % makima permette di creare curve di tipo C1
    curvex = makima(t,nPoints(:,2),tq);
    curvey = makima(t,nPoints(:,1),tq);
    curve = [curvex',curvey'];
    %% plot section
    figure
    subplot(1,3,1)    
    plot(tq,curvex,'r');
    title('t vs x')
    subplot(1,3,2)    
    plot(tq,curvey,'g')
    title('t vs y')
    subplot(1,3,3)   
    plot(curvex,curvey,'b')
    title('x vs y')
    
end