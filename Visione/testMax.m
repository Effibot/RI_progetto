
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
% filename = 'Immagini/verticalCalc.jpg';
% Calcolatrice in Diagonale con sfondo bianco -> Identificata
filename = 'Immagini/rotateCalcW.jpg';
% Calcolatrice Orizzontale con Ombra -> Identificata con pxToDel = 40000
% filename = 'Immagini/horizontalCalcShadow.jpg';
% Calcolatrice Orizzontale sfondo bianco -> Identificata
% filename = 'Immagini/horizontalCalcW.jpg';
% Calcolatrice Orizzontale sfondo nero -> Identificata
% filename = 'images/horizontalCalcB.jpg';
% Rondella Circolare -> Identificata
% filename = 'Immagini/rondella.jpg';
% Mensola Triangolare -> Identificata
% filename = 'Immagini/triangolo.jpg';
% Dado Esagonale  -> Identificato
% filename = 'Immagini/esagono_rot.png';
% Controller  -> Bordi troppo diversi da loro, non identificata.
% filename = 'Immagini/controller.jpg';
% filename = 'Immagini/QuadratoRosso.jpg';
imgRGB = imread(filename);  % Caricamente Immagine
rng('default')
imgRGB=imnoise(imgRGB,'salt & pepper',0.1);

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
%% Graficare tutte le proiezioni dell'immagine
% Graficando il massimo in funzione dell'angolo


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
epsilon = 0.05*10;
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
if (strcmp(objShape, "Irregolare") == 1)
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

figure
plot(theta, maxRadon);

%% Determino il massimo per identificare il punto più alto della
% proiezione con altezza maggiore.
% [pk, locs] = findpeaks() identifica il massimo locale del vettore dato in
% ingresso e l'indice di quel valore all'interno del vettore.
% SosrtStr specifica che i risultati andranno ordinati
% NPeaks specifica quanti massimi locali trovare nel vettore.
% figure
angleSum = 180*numLati-360;

[pk, locs] = findpeaks(maxRadon,'SortStr','descend',...
    'MinPeakHeight',max(maxRadon)*0.95,'MinPeakDistance',25,'Threshold',1e-4);
locs = locs - 1;
plot(locs, pk ,'or') 
grid on
[M, idM] = max(pk);


%% Ellisse circoscritta all'oggetto
figure
grid on
hold on 
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

%%
diag = [];
for i = 1:size(locs,2)
    theta = locs(i);
    offset = xp1(R1(:,locs(i)+1) == pk(i));
    diag_i(x) = tand(theta + 90) * ( x - offset*cosd(theta) ) + offset*sind(theta);
    diag = horzcat(diag,diag_i);
end
orient = alpha+pi;



%%
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
figure
imagesc(theta, xp1, R1); colormap(hot);
xlabel('\theta (degrees)');
ylabel('x^{\prime} (pixels from center)');
title('Trasfomata di Radon: R_{\theta} (x^{\prime})');
colorbar
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
%% contorno dell'oggetto
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
syms rect(x,x0,y0,m) x
rect(x,x0,y0,m)=m*(x-x0)+y0;
ang=(alpha-pi);
majorax=rect(x,z(1),z(2),ang);
point=subs(majorax,x,z(1)+linspace(-a/2,a/2));
plot(z(1)+linspace(-a/2,a/2),point)
plot(z(1),z(2),'*g')
% while(1)

minorax=rect(x,z(1),z(2),-1/ang);
point=subs(minorax,x,z(1)+linspace(-b/2,b/2));
h=plot(z(1)+linspace(-b/2,b/2),point);
% pause()
% i=i+10;
% delete(h)
% end
%% Visualizzo Diagonali dell'oggetto
% lineOrient = rect(x,z(1),z(2),)
lineOrient = center(2) - z(2) - tan(orient) * ( x - center(1) - z(1) ) ;
for i =1:size(diag,2)
    fplot(diag(i), 'LineWidth', 1.5);
    hold on
end
