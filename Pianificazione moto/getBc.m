function bc = getBc(nodeloc, dim)
    % compute the center of mass of grid from its upper left corner
    % point and the dimension of the square that describes.
    bc = nodeloc+dim/2;
end