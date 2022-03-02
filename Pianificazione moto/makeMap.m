function img = makeMap(obstacleList, dim)
    % return RGB Image as m x m x 3
    img = ones([dim,3]);
    for i = 1:size(obstacleList, 1)
        x = obstacleList(i,1);
        y = obstacleList(i,2);
        r = obstacleList(i,3);
        img(x,y,:) = 0;
        img(fix(-r/2)+x-1:fix(r/2)+x+1,...
            fix(-r/2)+y-1:fix(r/2)+y+1,:)=0;
    end
end