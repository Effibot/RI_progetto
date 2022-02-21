%% Visione Artificiale
% Determinare perimetro, area, forma, centro ed orientamento di un oggetto
% all'interno in un'immagine.
% Andrea Efficace 0300125
% In questo script verranno utilizzate funzioni dell'Image Processing
% Toolbox di maxima
clearvars
close all
clc
syms x diag1(x) diag2(x)
syms rect(x,x0,y0,x1,y1)
rect(x,x0,y0,x1,y1) = (x-x0)/(x1-x0)*(y1-y0)+y0;

%% Lettura Immagini e caricamento in workspace
% Calcolatrice Verticale con luce diffusa -> Non Identificata
% filename = 'images/verticalCalc.jpg';
% Calcolatrice in Diagonale con sfondo bianco -> Identificata
% filename = 'Immagini/rotateCalcW.jpg';
% Calcolatrice Orizzontale con Ombra -> Identificata con pxToDel = 40000
% filename = 'Immagini/horizontalCalcShadow.jpg';
% Calcolatrice Orizzontale sfondo bianco -> Identificata
% filename = 'images/horizontalCalcW.jpg';
% Calcolatrice Orizzontale sfondo nero -> Identificata
% filename = 'images/horizontalCalcB.jpg';
% Rondella Circolare -> Identificata
% filename = 'Immagini/rondella.jpg';
% Mensola Triangolare -> Identificata
filename = 'Immagini/triangolo.jpg';
% Dado Esagonale  -> Identificato
% filename = 'images/dadoEsagono.jpg';
% Controller  -> Bordi troppo diversi da loro, non identificata.
% filename = 'Immagini/controller.jpg';
% filename = 'Immagini/QuadratoRosso.jpg';
imgRGB = imread(filename);  % Caricamente Immagine

%% Pre-Processamento: Compressione dell'immagine

% Per mantenere un rapporto di grandezze tra l'aspetto dell'immagine in
% ingresso quella post compressione, una delle due dimensioni viene decisa
% dalla libreria in automatico.

maxRes = [480, 640];        % Risoluzione massima desiderata dell'immagine
width = size(imgRGB, 2);    % Larghezza iniziale dell'immagine
height = size(imgRGB, 1);   % Altezza iniziale dell'immagine

if (height > maxRes(1))
    imgRGB = imresize(imgRGB, [maxRes(1) NaN]);
end
if (width > maxRes(2))
    imgRGB = imresize(imgRGB, [NaN maxRes(2)]);
end

width = size(imgRGB, 2);    % Larghezza dell'immagine post-compressione
height = size(imgRGB, 1);   % Altezza dell'immagine post-compressione
res = width*height;         % Risoluzione dell'immagine post-compressione
center = [floor((width+1)/2), floor((height+1)/2)];
%% Avvio Processamento dell'immagine
tic;        % Avvio contatore del tempo di processamento

%% Converto l'immagine a scala di grigi
imgGRS = rgb2gray(imgRGB);

%% Converto l'immagine in B/N
imgBW = imbinarize(imgGRS);

%% Calcolo il negativo dell'immagine se questa è troppo chiara
% utile per le operazioni successive

% Prima somma per le colonne, seconda per le righe
nPixelW = sum(sum(imgBW));
if(nPixelW >= res/2)
    imgBW_old = imgBW;
    imgBW = imcomplement(imgBW);
end

%% Elimino difetti nell'immagine
% utile per eliminare artefatti grafici (es: ombre)
% pxToDel = 40;        % Soglia di pixel da considerare come rumore.
pxToDel = 40000;      % Soglia per Ombra
imgBW2 = bwareaopen(imgBW,pxToDel);

%% Applico Maschere di Dilatazione ed Erosione
% Definisco operatore morfologico: Applico maschere quadrate

mask=strel('disk',10,8);
%imgBW3=imdilate(imgBW2,mask);
mask1=strel('square',10);

% imclose() applica operatori morfologici su immagini in b/n  o greyscale
imgBW3 = imclose(imgBW2, mask);
imgBW3 = imopen(imgBW3, mask1);

%% Eliminazione "buchi" dall'immagine
% permette di eliminare artefatti grafici simili a riflessi sulla
% superficie dell'oggetto, o buchi nello stesso.
imgBW4 = imfill(imgBW3, 'holes');
%% Determino Area e Perimetro dell'Oggetto nell'Immagine

% bwboundaries() determina i contorni di un oggetto in un'immagine b/w
% il parametro 'noholes' serve per specificare all'algoritmo di cercare
% soltanto oggetti compatti, velocizzando il processo.
% Tale algoritmo può identificare più oggetti in una singola immagine.
[B, L] = bwboundaries(imgBW4, 'noholes');
% regionprops() calcola il valore effettivo di perimetro ed area.
% Salvo il risultato in un oggetto.
props = regionprops(L, 'Area', 'Perimeter');
% Salvo Area e Perimetro di tutti gli oggetti identificati come lista.
areas = [props.Area];
perims = [props.Perimeter];
% Discrimino l'oggetto da identificare da tutti quelli nell'immagine
objArea = max(areas);
objPerim = max(perims);
% Sapendo che Area = (perimetro * apotema)/2 e che l'apotema è pari ad un
% numero fisso per perimetro/numero_lati, troviamo che
apothem = objArea*2/objPerim;
epsilon = 0.05;
objShape = "Irregolare";
fixed = [0.289,0.5,0.688,0.866];
polig = ["Triangolo", "Quadrilatero", "Pentagono", "Esagono"];
for i=1:4
    numLati = i+2;
    if(apothem/objPerim*numLati < fixed(i)+epsilon)
        if(apothem/objPerim*numLati > fixed(i)-epsilon)
            objShape = polig(i);
            break;
        end
    end
end
% Stesso discorso dei poligoni regolari, ma su una circonferenza
if (strcmp(objShape, "Irregulare") == 1)
    epsilon = 0.55;
    myPi = objPerim^2/(4*objArea);
    if(myPi < pi+epsilon)
        if(myPi > pi-epsilon)
            objShape = "Circolare";
        end
    end
end

%% Eseguo Trasformata di Radon per determinare baricentro ed orientamento
% Calcoliamo le proiezioni, in modo tale da identificare le diagonali
% principali dell'oggetto da riconoscere. La loro intersezione ne
% determinerà il baricentro.

% Definisco Rispetto a quanti angoli effettuare la proiezione.
theta = 0:179;
% Eseguo le proiezioni.
% R è la trasformata, Xp l'angolo in radianti relativo alla trasformata.
[R1, xp1] = radon(imgBW4,  theta);

% Determino la proiezione con altezza maggiore per determinare la diagonale
maxRadon = max(R1);

%% Determino il massimo per identificare il punto più alto della
% proiezione con altezza maggiore.
% [pk, locs] = findpeaks() identifica il massimo locale del vettore dato in
% ingresso e l'indice di quel valore all'interno del vettore.
% SosrtStr specifica che i risultati andranno ordinati
% NPeaks specifica quanti massimi locali trovare nel vettore.
[pk, locs] = findpeaks(maxRadon, 'SortStr', 'descend', 'NPeaks', 3);

% Trovo angolo in radianti il cui indice corrisponde all'elemento di una
% delle colonne di R il cui valore è pari al picco individuato da pk
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
% Mi assicuro che l'angolo trovato sia tra -90° and 90°
orient = atand(sind(orient)/cosd(orient));
%% Fine Processamento
elapseTime = toc;
%% Visualizzo Immagine a Colori
% figure
% imshow(imgRGB)
% title('Immagine a Colori');

%% Visualizzo immagine a colori compressa
figure
subplot(3,1,1)
imshow(imgRGB)
title('Immagine a Colori Compressa');

%% Visualizzo immagine in scala di grigi
subplot(3,1,2)
imshow(imgGRS)
title('Immagine in Scala di Grigi');

%% Visualizzo immagine in B/N
subplot(3,1,3)
imshow(imgBW)
title('Immagine in Bianco e Nero');

%% Visualizzo immagine senza artefatti
figure
subplot(3,1,1)
imshow(imgBW2)
title('Dopo Area Opening');

%% Visualizzo immagine dopo operatori morfologici
subplot(3,1,2)
imshow(imgBW3)
title('Dopo Dilataizione ed Erosione');

%% Visualizzo immagine Pre-Processata
subplot(3,1,3)
imshow(imgBW4)
title('Dopo Eliminazione dei Disturbi/Fori');

%% Visualizzo la Trasformata di Radon
figure
imagesc(theta, xp1, R1); colormap(hot);
xlabel('\theta (degrees)');
ylabel('x^{\prime} (pixels from center)');
title('Trasfomata di Radon: R_{\theta} (x^{\prime})');
colorbar
%%
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

%% Grafico delle Diagonali
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

%% Report dell'Identificazione
fprintf("Area: %f, Perimetro: %f\n", objArea, objPerim);
fprintf("Forma dell'Oggetto: %s\n", objShape);
fprintf("Baricentro dell'Oggetto: X[bc] = %f, Y[bc] = %f\n", x_bc, y_bc);
fprintf("Orientamento dell'Oggetto: %f°\n", orient);
fprintf("Tempo di Processamento: %f ms\n", elapseTime);