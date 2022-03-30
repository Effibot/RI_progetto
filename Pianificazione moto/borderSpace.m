function r=borderSpace(node,k)
    % make a linear span to simulate the four borders of a cell
    borderLeft = linspace(node.corner(1,1)-k,node.corner(1,2)+k);
    borderLeft = [(node.corner(2,1)-k)*ones(size(borderLeft));borderLeft];
    borderTop = linspace(node.corner(2,1)-k,node.corner(2,3)+k);
    borderTop = [borderTop;(node.corner(1,1)-k)*ones(size(borderTop))];
    borderRight = linspace(node.corner(1,3)-k,node.corner(1,4)+k);
    borderRight = [(node.corner(2,3)+k)*ones(size(borderRight));borderRight];
    borderDown = linspace(node.corner(2,2)-k,node.corner(2,4)+k);
    borderDown = [borderDown;(node.corner(1,4)+k)*ones(size(borderDown))];
    r = horzcat(borderLeft,borderTop,borderRight,borderDown);
end