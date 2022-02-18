% - Procedura 31
% Visione Artificiale
% Edoardo Tagliacozzi
% 09/01/2021

clearvars
close all
clc

syms x diag1(x) diag2(x)
pixToDel = 40;  % Pixels threshold for area opening.
desRow = 500;
desCols = 300;

%% Initialize computations and read image, take initial time.

pathImage = 'telefono.jpg';
%pathImage = 'fiches.jfif';

RGB = imread(pathImage);
if( size(RGB, 1) > desRow )
    RGB = imresize(RGB, [500 NaN]);
end
if( size(RGB, 2) > desCols )
    RGB = imresize(RGB, [NaN 300]);
end
width = size(RGB, 2);
height = size(RGB, 1);
center = [floor((width+1)/2), floor((height+1)/2)];

tic;  % Start stopwatch.

%% Turn image to grayscale.
GR = rgb2gray(RGB);

%% Turn image to B/W.
BW1 = imbinarize(GR);

%% Compute the negative (if the object is dark).
nPixelW = sum( sum(BW1) );  % Count white pixels.
if ( nPixelW >= (width*height)/2 )
    BW = imcomplement(BW1);
else
    BW = BW1;
end

%% Remove artifacts (area opening).
BW2 = bwareaopen(BW, pixToDel);

%% Dilation and erosion: image closing.
% Using a square mask with fixed size.
se1 = strel('square', 10);
BW3 = imclose(BW2, se1);

%% Fill "noise holes".
BW4 = imfill(BW3, 'holes');

%% Determine object area and perimeter.
% L is a matrix of "regions" in which each pixel is identified with a
% number of a region it belongs to.
[B, L] = bwboundaries(BW4, 'noholes');
props = regionprops(L, 'Area', 'Perimeter');
allAreas = [props.Area];
allPerimeters = [props.Perimeter];
obPerimeter = max(allPerimeters);
obArea = max(allAreas);
% Compute of the apothem to recognize the figure
% test -> l = apothem/nf = P/#l
apothem = obArea*2/obPerimeter;
epsilon = 5;
obShape = "Irregular figure";
if( apothem/0.5 - obPerimeter/4 < epsilon)
	obShape = "Quadrilateral";
elseif( apothem/0.688 - obPerimeter/5 < epsilon)
	obShape = "Pentagon";
elseif( apothem/0.866 - obPerimeter/6 < epsilon)
	obShape = "Hexagon";
elseif( apothem*2*pi - obPerimeter < epsilon)
	obShape = "Circle";
end

%% Compute Radon Transform, then determine object's center and orientation.
theta = 0:179;  % Angles for the Radon Transform.
[R, xp] = radon(BW4, theta);

% Calculate the Radon transform of the image for some angles
[R1, xp1] = radon(BW4, [8,16,32,49,65,81,98,114,130,147,163,180]);



% Find local maxima to determine two diagonal lines.
maxRadon = max(R);
[pk, locs] = findpeaks(maxRadon, 'SortStr', 'descend', 'NPeaks', 2);

angle1 = locs(1);
offset1 = xp( R(:, locs(1)) == pk(1) );
angle2 = locs(2);
offset2 = xp( R(:, locs(2)) == pk(2) );

% Determine diagonal lines from the image center.
diag1(x) = tand(angle1 + 90) * ( x - offset1*cosd(angle1) ) + offset1*sind(angle1);
diag2(x) = tand(angle2 + 90) * ( x - offset2*cosd(angle2) ) + offset2*sind(angle2); 

% Find object center as the diagonal lines intersection.
x_bc = solve( diag1 == diag2 );
y_bc = diag1(x_bc);

% Orientation angle from the horizon is derived from the two Radon's
% angles.
angleOrient = (angle1 + angle2)/2;
if ( sign(sind(angle1)) ~= sign(sind(angle2)) || sign(cosd(angle1)) ~= sign(cosd(angle2)) )
    % Diagonals lie in different quadrants, so this is necessary to choose
    % the angle from the image's horizon.
    angleOrient = angleOrient - 90;
end
% Ensure the angle is between -90° and +90°.
angleOrient = atand(sind(angleOrient)/cosd(angleOrient));

elapsTime = toc;  % Stop stopwatch.

%% Plots and figures.
fprintf("Object area: %f, perimeter: %f.\n", obArea, obPerimeter);
fprintf("Object shape: %s.\n", obShape)
fprintf("Object center (offsets from image center): %f, %f.\n", x_bc, y_bc);
fprintf("Object orientation: %f°.\n", angleOrient);
fprintf("Processing time: %f.\n", elapsTime);

figure(1);
title('Original Image');
imshow(RGB);

figure(2);
imshow(GR);
title('Grayscale Image');

figure(3);
imshow(BW1);
title('Black/White Image');

if ( nPixelW >= (width*height)/2 )
    figure(4);
    imshow(BW);
    title('Black/White Negative');
end

figure(5);
imshow(BW2);
title('Area Opening');

figure(6);
imshow(BW3);
title('Dilation and Erosion');

figure(7);
imshow(BW4)
title('Noise-Holes Filling');

figure(8);
imagesc(theta, xp, R); colormap();
xlabel('\theta (degrees)');
ylabel('x^{\prime} (pixels from center)');
title('R_{\theta} (x^{\prime})');
colorbar

figure(9);
imshow(BW4);
hold on
boundary = B{1};
for i = 2:length(B)
    % Find largest object, i.e. our object.
    if( size(B{i}, 1) > size(boundary, 1) )
        boundary = B{i};
    end
end
plot(boundary(:,2), boundary(:,1), 'b', 'LineWidth', 2);
title('Object Recognition');
hold on
plot(center(1) + offset1*cosd(angle1), center(2) - offset1*sind(angle1), 'r*', 'MarkerSize', 10);
plot(center(1) + offset2*cosd(angle2), center(2) - offset2*sind(angle2), 'g*', 'MarkerSize', 10);
plot(center(1) + x_bc, center(2) - y_bc, 'bo', 'MarkerSize', 10);
diag1_p = center(2) - tand(angle1 + 90) * ( x - center(1) - offset1*cosd(angle1) ) - offset1*sind(angle1);
diag2_p = center(2) - tand(angle2 + 90) * ( x - center(1) - offset2*cosd(angle2) ) - offset2*sind(angle2);
lineOrient = center(2) - tand(angleOrient) * ( x - center(1) - x_bc ) - y_bc;
fplot(diag1_p, 'r', 'LineWidth', 1.5);
fplot(diag2_p, 'g', 'LineWidth', 1.5);
fplot(lineOrient, 'y', 'LineWidth', 2);

figure (10)
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
t11=nexttile;
plot(xp1,R1(:,11));
title(t11,'163°','Color','#EDB120')
t12=nexttile;
plot(xp1,R1(:,12));
title(t12,'180°','Color','#7E2F8E')

%% Grafico delle Diagonali
figure
imshow(BW4)
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
plot(center(1) + offset1*cosd(theta1), center(2) - offset1*sind(theta1), 'r*', 'MarkerSize', 10);
plot(center(1) + offset2*cosd(theta2), center(2) - offset2*sind(theta2), 'g*', 'MarkerSize', 10);
plot(center(1) + x_bc, center(2) - y_bc, 'bo', 'MarkerSize', 10);
diag1Plot = center(2) - tand(theta1+90) * (x - center(1) - offset1*cosd(theta1)) - offset1*sind(theta1);
diag2Plot = center(2) - tand(theta2+90) * (x - center(1) - offset2*cosd(theta2)) - offset2*sind(theta2);
lineOrient = center(2) - tand(orient) * (x - center(1) - x_bc) - y_bc;
fplot(diag1Plot, 'r', 'LineWidth', 1.5);
fplot(diag2Plot, 'g', 'LineWidth', 1.5);
fplot(lineOrient, 'y', 'LineWidth', 2);

