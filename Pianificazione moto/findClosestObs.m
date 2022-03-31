function [closest, mindist] = findClosestObs(obsList, point)
    %   calcolo tutte le distanze dai baricentri degli ostacoli
    dist = zeros(size(obsList,1),1);
    for i = 1:size(dist,1)
        dist(i) = norm(obsList(i,:)-point);
    end
    %   trovo l'ostacolo più vicino
    closest = obsList(dist==min(dist),1:2);
    closest = closest(1,:);
    mindist = min(dist);
end