function corners = getCorners(nodeloc, dim)
    % given the upper left corner of a node compute the other three corners
    cUpLeft = [nodeloc(1),nodeloc(2)];
    cDWLeft = [nodeloc(1)+dim-1,nodeloc(2)];
    cUpRig = [nodeloc(1),nodeloc(2)+dim-1];
    cDWRig = [nodeloc(1)+dim-1,nodeloc(2)+dim-1];
    corners = horzcat(cUpLeft',cDWLeft',cUpRig',cDWRig');
end