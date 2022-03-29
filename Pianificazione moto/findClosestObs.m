function [closest, mindist] = findClosestObs(obsList, point)
    %   calcolo tutte le distanze dai baricentri degli ostacoli
    %     dist = sqrt(sum(bsxfun(@minus, obsList(:,1:2), point).^2,2));
    dist = pdist2(point(1,:), obsList(:,1:2));
    %   trovo l'ostacolo più vicino
    closest = obsList(dist==min(dist),1:2);
    mindist = min(dist);
end