theta1 = locs(1);
offset1 = xp1(R1(:, locs(1)) == pk(1));
theta2 = locs(2);
offset2 = xp1(R1(:, locs(2)) == pk(2));

% Determino le diagonali
if (objShape=="Triangolo")
    theta3 = locs(3);
    offset3 = xp1(R1(:, locs(3)) == pk(3));
    diag1(x) = tand(theta1 + 90) * ( x - offset1*cosd(theta1) ) + offset1*sind(theta1);
    diag2(x) = tand(theta2 + 90) * ( x - offset2*cosd(theta2) ) + offset2*sind(theta2);
    diag3(x) = tand(theta3 + 90) * ( x - offset3*cosd(theta3) ) + offset3*sind(theta3);
    
    % trovo vertici del triangolo
    x_1 = solve(diag1 == diag2);    % rossa con verde
    y_1 = diag1(x_1);
    x_2 = solve(diag2 == diag3);    % ciano con verde
    y_2 = diag2(x_2);
    x_3 = solve(diag1 == diag3);    % rossa con ciano
    y_3 = diag1(x_3);
    % trovo punti medi
    xm1 = (x_1+x_3)/2;  % rosso
    ym1 =  (y_1+y_3)/2;
    xm2 =(x_1+x_2)/2;   % verde
    ym2 = (y_1+y_2)/2;
    xm3 =(x_2+x_3)/2;   % ciano
    ym3 =(y_2+y_3)/2;
    % retta per due punti
    rect1 = rect(x,x_1,y_1,xm3,ym3);    % mediano rossa-ciano
    rect2 = rect(x,x_2,y_2,xm1,ym1);    % mediano verde-rosso
    rect3 = rect(x,x_3,y_3,xm2,ym2);    % mediano ciano-verde
    
    % baricentro
    x_bc = solve( rect1 == rect2 );
    y_bc = subs(rect3,x,x_bc);
    
    
else
    diag1(x) = tand(theta1 + 90) * ( x - offset1*cosd(theta1) ) + offset1*sind(theta1);
    diag2(x) = tand(theta2 + 90) * ( x - offset2*cosd(theta2) ) + offset2*sind(theta2);
    x_bc = solve( diag1 == diag2 );
    y_bc = diag1(x_bc);
end
% coords=regionprops(imgBW4,{'Centroid','Orientation'});
%     x_bc=coords.Centroid(1);
%     y_bc=coords.Centroid(2);
% Determino Orientamento a partire da due angoli identificati dalla
% trasformata di Radon

orient = (theta1+theta2)/2;
% Controllo se c'è discordanza tra i quadranti identificati dagli angoli
if(sign(sind(theta1)) ~= sign(sind(theta2)) || sign(cosd(theta1)) ~= sign(cosd(theta2)) )
    orient = orient-90;
end
