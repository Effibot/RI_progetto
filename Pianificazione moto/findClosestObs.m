function [closest, mindist] = findClosestObs(obsList, point)
    %   calcolo tutte le distanze dai baricentri degli ostacoli
    %     dist = sqrt(sum(bsxfun(@minus, obsList(:,1:2), point).^2,2));
    %     dist = pdist2(point(1,:), obsList(:,1:2));
    dist = zeros(size(obsList,1),1);
    for i = 1:size(dist,1)
        %         dist(i) = sqrt((point(1)-obsList(i,1)).^2+(point(2)-obsList(i,2)).^2);
        dist(i) = norm(obsList(i,:)-point);
    end
    %   trovo l'ostacolo più vicino
    closest = obsList(dist==min(dist),1:2);
    closest = closest(1,:);
    mindist = min(dist);
end