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