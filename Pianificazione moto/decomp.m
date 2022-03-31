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




