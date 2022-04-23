
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
imgRGB=imnoise(imgRGB,'salt & pepper',0.7);

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
%%
phaseMask = islocalmax(R1, 1);
R1mask = R1.*phaseMask;
distMask = islocalmax(R1mask,2,'MinSeparation',30);
R1mask = R1mask.*distMask;
figure
plot(theta,max(R1mask))
%% Determino il massimo per identificare il punto più alto della
% proiezione con altezza maggiore.
% [pk, locs] = findpeaks() identifica il massimo locale del vettore dato in
% ingresso e l'indice di quel valore all'interno del vettore.
% SosrtStr specifica che i risultati andranno ordinati
% NPeaks specifica quanti massimi locali trovare nel vettore.
figure
angleSum = 180*numLati-360;
hold on

% [pk, locs] = findpeaks(maxRadon,'SortStr','descend');
% plot(locs, pk,'ob') 
% [M, idM] = max(pk);
% theta1 = locs(idM)-2:locs(idM)+1;
% [R2, xp2] = radon(imgBW4,  theta1);
% maxRadon2 = max(R2);
% plot(theta1, maxRadon2, 'r');
% figure
% hold on
[pk, locs] = findpeaks(maxRadon,'SortStr','descend','Annotate','extents',...
    'MinPeakHeight',max(maxRadon)*0.95,'MinPeakDistance',25);
plot(locs, pk,'ob') 
grid on
[M, idM] = max(pk);
% locs2 = locs2 +locs(idM);
% plot(locs2, pk2,'*r') 
% [pk, locs] = findpeaks(maxRadon,'SortStr','descend','MinPeakDistance',60);
% plot(locs, pk,'-g') 

%%
figure
subplot(2,2,1)
imshow(imgRGB);
subplot(2,2,2)
imshow(imgBW2);
subplot(2,2,3)
imshow(imgBW3);
subplot(2,2,4)
imshow(imgBW4);
hold on 
