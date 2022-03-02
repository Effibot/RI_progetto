function r=visione(xb,yb,obsTarget)
syms x diag1(x) diag2(x) diag3(x)
syms rect(x,x0,y0,x1,y1)
rect(x,x0,y0,x1,y1) = (x-x0)/(x1-x0)*(y1-y0)+y0;
filename='';
switch(obsTarget)
    case 1
        filename = 'img/triangolo.jpg';
    case 2
        filename = 'img/QuadratoRosso.jpg';

    case 3
        filename = 'img/rondella.jpg';
    otherwise
        disp("No obstacle match");
end
preprocessdata=preprocess(filename);
center=preprocessdata{1};
imgRGB=preprocessdata{2};
res=preprocessdata{3};
imgM=manipulateImg(imgRGB,res);
[objArea,objPerim,bc,objShape,B,orient,rect1,rect2,rect3,R1]=computeGeometric(imgM,rect,diag1,diag2,diag3,x);

% % Visualizzo immagine a colori compressa
figure
subplot(3,1,1)
imshow(imgRGB)
title('Immagine a Colori Compressa');

% Visualizzo immagine in scala di grigi
subplot(3,1,2)
imshow(imgGRS)
title('Immagine in Scala di Grigi');

% Visualizzo immagine in B/N
subplot(3,1,3)
imshow(imgBW)
title('Immagine in Bianco e Nero');

% Visualizzo immagine senza artefatti
figure
subplot(3,1,1)
imshow(imgBW2)
title('Dopo Area Opening');

% Visualizzo immagine dopo operatori morfologici
subplot(3,1,2)
imshow(imgBW3)
title('Dopo Dilataizione ed Erosione');

% Visualizzo immagine Pre-Processata
subplot(3,1,3)
imshow(imgBW4)
title('Dopo Eliminazione dei Disturbi/Fori');

% Visualizzo la Trasformata di Radon
figure
imagesc(theta, xp1, R1); colormap(hot);
xlabel('\theta (degrees)');
ylabel('x^{\prime} (pixels from center)');
title('Trasfomata di Radon: R_{\theta} (x^{\prime})');
colorbar
%
figure
tiledlayout(4,3);
t1=nexttile;
plot(xp1,R1(:,1));
title(t1,'0°','Color','r')
t2=nexttile;
plot(xp1,R1(:,2));
title(t2,'16°','Color','#ffd700')
t3=nexttile;
plot(xp1,R1(:,3));
title(t3,'32°','Color','b')
t4=nexttile;
plot(xp1,R1(:,4));
title(t4,'49°','Color','#008000')
t5=nexttile;
plot(xp1,R1(:,5));
title(t5,'65°','Color','m')
t6=nexttile;
plot(xp1,R1(:,6));
title(t6,'81°','Color','#f08080')
t7=nexttile;
plot(xp1,R1(:,7));
title(t7,'98°','Color','k')
t8=nexttile;
plot(xp1,R1(:,8));
title(t8,'114°','Color','#77AC30')
t9=nexttile;
plot(xp1,R1(:,9));
title(t9,'130°','Color','#4DBEEE')
t10=nexttile;
plot(xp1,R1(:,10));
title(t10,'147°','Color','#D95319')
plot(xp1,R1(:,11));
t11=nexttile;
title(t11,'163°','Color','#EDB120')
t12=nexttile;
plot(xp1,R1(:,12));
title(t12,'180°','Color','#7E2F8E')

% Grafico delle Diagonali
figure
imshow(imgBW4)
hold on
boundary = B{1};
for i = 2:length(B)
    if(size(B{1},1) > size(boundary, 1))
        boundary = B{1};
    end
end

plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2);
title('Identificazione Oggetto');
hold on

plot(cosd(theta1),sind(theta1), 'r*', 'MarkerSize', 10);
plot(cosd(theta2),sind(theta2), 'g*', 'MarkerSize', 10);
% plot(x_bc, y_bc, 'bo', 'MarkerSize', 10);
plot(center(1) + x_bc, center(2) - y_bc, 'bo', 'MarkerSize', 10);

% diagPlot = imgCenterY-alpha*(xCoord-imgCenterX-Xtocross)-YtoCross
% nella definizione delle diagonali (imgCenterX,imgCenterY) non sono state
% considerate dato che le coordinate sono già traslate
diag1Plot =  center(2) - tand(theta1 + 90) * ( x - center(1) - offset1*cosd(theta1) ) - offset1*sind(theta1);
diag2Plot = center(2) - tand(theta2 + 90) * ( x - center(1) - offset2*cosd(theta2) ) - offset2*sind(theta2);
if (objShape=="Triangolo")
    diag3Plot = center(2) - tand(theta3 + 90) * ( x - center(1) - offset3*cosd(theta3) ) - offset3*sind(theta3);
    fplot(diag3Plot, 'c', 'LineWidth', 1.5);
end
% lineOrient = - tand(orient) * (x  - x_bc) + y_bc;
lineOrient = center(2) - tand(orient) * ( x - center(1) - x_bc ) - y_bc;

fplot(diag1Plot, 'r', 'LineWidth', 1.5);
fplot(diag2Plot, 'g', 'LineWidth', 1.5);
fplot(lineOrient, 'y', 'LineWidth', 2);
rect1=-subs(rect1,x,x-center(1)) + center(2);
rect2=-subs(rect2,x,x-center(1)) + center(2);
rect3=-subs(rect3,x,x-center(1)) + center(2);
plot(center(1)+x_1,center(2)-y_1,'bo','MarkerSize',10)

fplot(rect1, 'r', 'LineWidth', 1.5);

fplot(rect2, 'r', 'LineWidth', 1.5);
fplot(rect3, 'r', 'LineWidth',1.5);

% Report dell'Identificazione
fprintf("Area: %f, Perimetro: %f\n", objArea, objPerim);
fprintf("Forma dell'Oggetto: %s\n", objShape);
fprintf("Baricentro dell'Oggetto: X[bc] = %f, Y[bc] = %f\n", bc(1), bc(2));
fprintf("Orientamento dell'Oggetto: %f°\n", orient);
fprintf("Tempo di Processamento: %f ms\n", elapseTime);


r=[bc(1),bc(2)];
end




