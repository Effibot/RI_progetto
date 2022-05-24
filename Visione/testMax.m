
% Determinare perimetro, area, forma, centro ed orientamento di un oggetto
% all'interno in un'immagine.
% Andrea Efficace 0300125
% In questo script verranno utilizzate funzioni dell'Image Processing
% Toolbox di maxima
clearvars
close all
clc
tic
% variabili simboliche
syms x rect(x,x0,y0,m) rect2p(x,x0,y0,x1,y1)  diag_i(x)
rect(x,x0,y0,m)=m*(x-x0)+y0;
rect2p(x,x0,y0,x1,y1) = (x-x0)/(x1-x0)*(y1-y0)+y0;
diag = sym.empty;
%% Lettura Immagini e caricamento in workspace
% Calcolatrice Verticale con luce diffusa
% filename = 'Immagini/verticalCalc.jpg';
% Calcolatrice in Diagonale con sfondo bianco 
% filename = 'Immagini/rotateCalcW.jpg';
% Calcolatrice Orizzontale con Ombra
% filename = 'Immagini/horizontalCalcShadow.jpg';
% Calcolatrice Orizzontale sfondo bianco 
% filename = 'Immagini/horizontalCalcW.jpg';
% Calcolatrice Orizzontale sfondo nero 
% filename = 'Immagini/horizontalCalcB.jpg';
% Mensola Triangolare
filename = 'Immagini/triangolo.jpg';
% Dado Esagonale 
% filename = 'Immagini/esagono_rot.png';
% Controller
% filename = 'Immagini/controller.jpg';
% filename = 'Immagini/QuadratoRosso.jpg';
%% Caricamento Immagine
imgRGB = imread(filename);  
rng('default')
%% Applico rumore per testing sulla robustezza
imgRGB = imnoise(imgRGB,'salt & pepper', 0.5);
%% Pre-Processamento: Compressione dell'immagine
% Per mantenere un rapporto di grandezze tra l'aspetto dell'immagine in
% ingresso quella post compressione, una delle due dimensioni viene decisa
% dalla libreria in automatico.
maxRes = [480, 640];        % Risoluzione massima desiderata dell'immagine
width = size(imgRGB, 2);    % Larghezza iniziale dell'immagine
height = size(imgRGB, 1);   % Altezza iniziale dell'immagine
if (height > maxRes(1) || width > maxRes(2))
    imgRGB = imresize(imgRGB, [maxRes(1) maxRes(2)]);
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
% pxToDel = 50;        % Soglia di pixel da considerare come rumore.
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
epsilon = 0.01;
objShape = "Irregolare";
fixed = [0.28867, 0.5, 0.68819, 0.86602];
polig = ["Triangolo", "Quadrilatero", "Pentagono", "Esagono"];
deltaP=zeros(size(polig));
deltaA=zeros(size(polig));
deltaFix=zeros(size(polig));
deltaAp=zeros(size(polig));
for i=1:length(polig)
    numLati = i+2;
%     if(apothem/objPerim*numLati < fixed(i)+epsilon)
%         if(apothem/objPerim*numLati > fixed(i)-epsilon)
%             objShape = polig(i);
%             break;
%         end
%     end
% calcolo valori fissi sperimentali
% controllo quale valore fisso è più vicino
% Calcolo perimetro sperimentale 
    perimExp = apothem/fixed(i)*numLati;
    areaExp = apothem^2*numLati/fixed(i);
    fixExp = apothem*numLati/objPerim
    apExp = 2*areaExp/perimExp
% controllo quale perimetro più si avvicina a quello dell'oggetto
    deltaP(i) = min(abs(objPerim-perimExp));
    deltaA(i) = min(abs(objArea-areaExp));
    deltaFix(i) = min(abs(fixed(i)-fixExp));
    deltaAp(i) = min(abs(apothem-apExp));
% areaexp=perimExp*apothem/2
% abs(objArea-areaexp)
end

[~,idP] = min(deltaP);
[~,idA] = min(deltaA);
% if idP ~= idA 
%     [~,idF] = min(deltaFix);
%     if idP == idF
%         
%     end
% end
[~,idF] = min(deltaFix);
[~,idap] = min(deltaAp);

objShape = polig(idx);

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
% figure
angleSum = 180*numLati-360;
[pk, locs] = findpeaks(maxRadon,'SortStr','descend',...
    'MinPeakHeight',max(maxRadon)*0.6,'MinPeakDistance',30,'Threshold',1e-4);
% Scommentare per plottare l'output di findpeak
% findpeaks(maxRadon,'SortStr','descend','MinPeakHeight',max(maxRadon)*0.6,...
%     'MinPeakDistance',25,'Threshold',1e-4)
locs = locs - 1;
[M, idM] = max(pk);
%% Ellisse circoscritta all'oggetto
% trovo l'oggetto più grande nella fotoù
if length(B) == 1 
    obb = B{1};
elseif length(B) > 1
    maxi = 0;
    lenprev = length(B{1});
    for i = 2:length(B)
        if length(B{i}) > lenprev
            lenrev = length(B{i});
            maxi = i;
        end
    end
    obb = B{maxi};
end
[z, a, b, alpha] = fitellipse([obb(:,2)';obb(:,1)'], 'linear', 'constraint', 'trace');

%% Calcolo diagonali
for i = 1:size(locs,2)
    theta_i = locs(i);
        offset = xp1(R1(:,locs(i)+1) == pk(i));
    diag_i(x) = -tand(theta_i+90)*(x-offset*cosd(theta_i)-center(1))-offset*sind(theta_i)+center(2);
    diag = horzcat(diag,diag_i(x));
end
orient = alpha+pi;

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

%% Visualizzo la Trasformata di Radon come colormap
% figure
% imagesc(theta, xp1, R1); colormap(hot);
% xlabel('\theta (degrees)');
% ylabel('x^{\prime} (pixels from center)');
% title('Trasfomata di Radon: R_{\theta} (x^{\prime})');
% colorbar
%% Visualizzo i Massimi della Trasformata di Radon per vedere il contorno
figure
hold on
grid on
plot(theta, maxRadon);
plot(locs, pk ,'or') 
title("Profilo dell'Oggetto");
%% Visualizzo la trasformata di Radon come proiezione
figure
tiledlayout(4,3);
t1=nexttile;
plot(xp1,R1(:,1));
title(t1,'0°','Color','r')
t2=nexttile;
plot(xp1,R1(:,16));
title(t2,'15°','Color','#ffd700')
t3=nexttile;
plot(xp1,R1(:,31));
title(t3,'30°','Color','b')
t4=nexttile;
plot(xp1,R1(:,46));
title(t4,'45°','Color','#008000')
t5=nexttile;
plot(xp1,R1(:,61));
title(t5,'60°','Color','m')
t6=nexttile;
plot(xp1,R1(:,76));
title(t6,'75°','Color','#f08080')
t7=nexttile;
plot(xp1,R1(:,91));
title(t7,'90°','Color','k')
t8=nexttile;
plot(xp1,R1(:,106));
title(t8,'105°','Color','#77AC30')
t9=nexttile;
plot(xp1,R1(:,121));
title(t9,'120°','Color','#4DBEEE')
t10=nexttile;
plot(xp1,R1(:,136));
title(t10,'135°','Color','#D95319')
plot(xp1,R1(:,151));
t11=nexttile;
title(t11,'150°','Color','#EDB120')
t12=nexttile;
plot(xp1,R1(:,166));
title(t12,'165°','Color','#7E2F8E')
%% Grafico contorno dell'oggetto
figure
imshow(imgBW4);
hold on
plot(obb(:,2),obb(:,1),'g','LineWidth',3);
% alpha angolo in radiante preso in senso antiorario. phi serve a spannare
% i punti va da 0 a 2pi. a e b sono rispettivamente semi axe maggiore e
% minore e z è il centro
plotellipse(z, a, b, alpha)
% plotellipse(z, a, b, 0)
% plotellipse(z, a, b, pi/4)
% plotellipse(z, a, b, pi/2)

%% Disegno assi maggiori dell'oggetto
ang=(alpha-pi);
% aggiungo sfasamento trovato empiricamente dai plot precedenti per far
% coincidere lo 'zero' con quello da noi considerato.
majorax=rect(x,z(1),z(2),ang);
point=subs(majorax,x,z(1)+linspace(-a/2,a/2));
plot(z(1)+linspace(-a/2,a/2),point)
plot(z(1),z(2),'*g')
minorax=rect(x,z(1),z(2),-1/ang);
point=subs(minorax,x,z(1)+linspace(-b/2,b/2));
h=plot(z(1)+linspace(-b/2,b/2),point);
hold on
%% Disegno Baricentro dell'oggetto
plot(z(1),z(2),'bo','MarkerSize',10)
%% Visualizzo Diagonali dell'oggetto
lineOrient =  z(2) + tan(orient) * ( x  - z(1) ) ;
fplot(lineOrient,'y', 'LineWidth', 2.5);
plot(z(1)*ones(1,maxRes(1)),linspace(0,maxRes(1),maxRes(1)),'--r','linewidth',2)
plot(linspace(0,maxRes(2),maxRes(2)),z(2)*ones(1,maxRes(2)),'--r','linewidth',2)
for i =1:size(diag,2)
    eq = diag(i);
    fplot(eq, 'b','LineWidth', 1.5);
    hold on
end
%% Report dell'Identificazione
fprintf("Area: %f, Perimetro: %f\n", objArea, objPerim);
fprintf("Forma dell'Oggetto: %s\n", objShape);
fprintf("Baricentro dell'Oggetto: X[bc] = %f, Y[bc] = %f\n", z(1), z(2));
fprintf("Orientamento dell'Oggetto: %f°\n", mod(-rad2deg(orient),360));
fprintf("Tempo di Processamento: %f ms\n", elapseTime);