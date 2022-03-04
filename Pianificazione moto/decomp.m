function decomp(node, minDim, thresh)
    % at init time node has:
    % bc = [dim/2, dim/2]
    % lc = [1 1]
    % dim = dim(1)
    % adj = []
    % corner = [[1 1],[1 dim],[dim 1],[dim dim]]
    % id = 1
    % prop = 'y'
    % value = init map
    % father = 'root'
    % child = []


    % node: node of class tree
    % minDim: minimun size of blocks to split
    % thresh: threshold to decide when to split or not
    child = rectNode.empty(0,1);
    grid = node.value;
    % max value
    maximum = grid(find(ismember(grid,max(grid(:))),1));
    % min value
    minimum = grid(find(ismember(grid, min(grid(:))),1));

    newDim = size(grid,1)/2;
    if abs(minimum-maximum) > thresh && newDim >= minDim
        % create new node instances
        for i = 1:4
            lc = getLc(node.lc, newDim, i);
            bc = getBc(lc, newDim);
            childGrid = getGrid(grid, newDim, i);
            corners = getCorners(lc, newDim);
            child(end+1) = rectNode(bc, lc, newDim,...
                corners, 0, childGrid);
            child(i).setParent(node);
        end
        node.addChildrenList(child);
    elseif isequal(grid, ones(size(grid)))
        % the grid is empty
        node.prop = 'g';
    elseif isequal(grid, zeros(size(grid))) ||  newDim < minDim
        node.prop = 'r';
    end
    if ~isempty(node.child)
        for c = node.getChildren()
            decomp(c, minDim, thresh);
        end
    end
end
function newGrid = getGrid(grid, dim, num)
    % make a copy of a node's map starting from the upper left corner
    % We use clockwise notation to enumerate the children.
    % for border consistency we consider only the top and left
    % borders.
    switch num
        case 1
            newGrid = grid(1:dim,1:dim);
        case 2
            newGrid = grid(1:dim,dim+1:end);
        case 3
            newGrid = grid(dim+1:end,dim+1:end);
        case 4
            newGrid = grid(dim+1:end,1:dim);

    end
end
function lc = getLc(fatherlc, dim, num)
    % returns the upper left corner point relative position.
    % the starting point is the upper left of the main grid.
    switch (num)
        case 1
            lc = fatherlc;
        case 2
            lc = [fatherlc(1) fatherlc(2)+dim];
        case 3
            lc = fatherlc + dim;
        case 4
            lc = [fatherlc(1)+dim fatherlc(2)];
    end
end
function bc = getBc(nodeloc, dim)
    % compute the center of mass of grid from its upper left corner
    % point and the dimension of the square that describes.
    bc = nodeloc+dim/2;
end
function corners = getCorners(nodeloc, dim)

    cUpLeft = [nodeloc(1),nodeloc(2)];
    cDWLeft = [nodeloc(1)+dim-1,nodeloc(2)];
    cUpRig = [nodeloc(1),nodeloc(2)+dim-1];
    cDWRig = [nodeloc(1)+dim-1,nodeloc(2)+dim-1];
    corners = horzcat(cUpLeft',cDWLeft',cUpRig',cDWRig');
end
