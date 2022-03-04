function node = makeMap(obstacleList, dim)
    % return RGB Image as m x m x 3
    %     img = ones([dim,3]);
    img = ones(dim);
    for i = 1:size(obstacleList, 1)
        x = obstacleList(i,1);
        y = obstacleList(i,2);
        r = obstacleList(i,3);
        img(x,y,:) = 0;
        img(fix(-r/2)+x-1:fix(r/2)+x+1,...
            fix(-r/2)+y-1:fix(r/2)+y+1,:)=0;
    end
    bc = dim/2;
    lc = [1 1];
    corner = [[1 1];[1 dim(1)];[dim(1) 1];[dim(1) dim(1)]];
    id = 1;
    value = img;
    father = 'root';   
    node = rectNode(bc, lc, dim(1), corner, id, value);
    node.setParent(father)
end