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