%%Visione
clearvars
close all
clc

%% Inserimento immagine
path='Immagini/Cubo.jpg';
I=imread(path);
subplot(2,3,1);
imshow(I);
%%
% Immagine in scala di grigi
Igray=rgb2gray(I);
subplot(2,3,2);
imshow(Igray);
% Immagine in bianco e nero
thresh=160;
IBW=Igray;
[m,n]=size(IBW);
for i=1:m
    for j=1:n
        if(IBW(i,j)<=thresh)
            IBW(i,j)=0;
        else
            IBW(i,j)=255;
        end
    end
end
subplot(2,3,3);

imshow(IBW);
%% Applico maschere di erosione e dilatazione
% Primo parametro serve a definire la forma dei pixel che vengono presi
% nell'immagine, il secondo è la dimensione della maschera
sel=strel('disk',50,8);
%imclose applicala maschera all'immagine e restituisce l'immagine
%modificata
Idilate=imdilate(IBW,sel);
Ierode=imerode(IBW,sel);
IBW1=imclose(IBW,sel);
subplot(2,3,4);

imshow(Idilate);
subplot(2,3,5);

imshow(Ierode);
subplot(2,3,6);

imshow(IBW1);       
            
