function map = maprng(dimx, dimy, k)
%   generate a k-by-3 matrix where entries are a the set [bc_x, bc_y, r].
%   [bc_x, bc_y]: [x,y] coordinates of an obstacle's center of mass
%   r: ray of expansion from the center of mass. 
    map = zeros(k,3);
    maxR = min(dimx/4, dimy/4);
%     rng('shuffle');
%     seed = rand;
    for i = 1:k        
        r = randi(maxR);
        bc_x = randi([r,dimx-r]);
        bc_y = randi([r,dimy-r]);
        map(i,:) = [bc_x, bc_y, r];        
    end
end