function r = manipulateImg(img,res)
imgGRS = rgb2gray(img);

% Converto l'immagine in B/N
imgBW = imbinarize(imgGRS);

% Calcolo il negativo dell'immagine se questa è troppo chiara
% utile per le operazioni successive

% Prima somma per le colonne, seconda per le righe
nPixelW = sum(sum(imgBW));
if(nPixelW >= res/2)
    imgBW_old = imgBW;
    imgBW = imcomplement(imgBW);
end

% Elimino difetti nell'immagine
% utile per eliminare artefatti grafici (es: ombre)
% pxToDel = 40;        % Soglia di pixel da considerare come rumore.
pxToDel = 40000;      % Soglia per Ombra
imgBW2 = bwareaopen(imgBW,pxToDel);

% Applico Maschere di Dilatazione ed Erosione
% Definisco operatore morfologico: Applico maschere quadrate

mask=strel('disk',10,8);
mask1=strel('square',10);

% imclose() applica operatori morfologici su immagini in b/n  o greyscale
imgBW3 = imclose(imgBW2, mask);
imgBW3 = imopen(imgBW3, mask1);

% Eliminazione "buchi" dall'immagine
% permette di eliminare artefatti grafici simili a riflessi sulla
% superficie dell'oggetto, o buchi nello stesso.
imgBW4 = imfill(imgBW3, 'holes');

r=imgBW4;
end
