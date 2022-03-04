clc;
clear
close all;
%x = [1 6 11 27 31];
% y = [1 -2 10 3 6.5];
% xx = 0:.25:31;
% yy = spline(x,y,xx);
% figure;
% plot(x,y,'o',xx,yy,'g--');

%definire i vertici
v1=15;
v2=50;
%generico vertice v1
%baricentri celle
b1=[9 19];
b2=[41 53];
%dimensioni robot
r=[4 4];

%random points

if b1(1)>b1(2)
    x_UpperBound=b1(1);
    x_LowerBound=b1(2);
else
    x_UpperBound=b1(2);
    x_LowerBound=b1(1);

    if b2(1)>b2(2)
        y_UpperBound=b2(1);
        y_LowerBound=b2(2);
    else
        y_UpperBound=b2(2);
        y_LowerBound=b2(1);

    end
end

n=1; %numero rp
sp=[b1(1) b1(2)]; %starting point
dp=[b2(1) b2(2)]; %destination point

%se l'ostacolo è sopra
if y_LowerBound<v2
   y_LowerBound=v2;
end
%se l'ostacolo è a destra
if  x_UpperBound>v1
    x_UpperBound =v1;
end
%se l'ostacolo è sotto
if y_UpperBound>v2
   y_UpperBound=v2;
end
%se l'ostacolo è a sinistra
if x_LowerBound<v1
    x_LowerBound=v1;
end
%coordinate punti random
x=unifrnd(x_LowerBound, x_UpperBound, [1,n]);
y=unifrnd(y_LowerBound, y_UpperBound, [1,n]);

x=[b1(1) x b1(2)];
y=[b2(1) y b2(2)];

t=linspace(0, 1, numel(x));
m=200;
tt=linspace(0, 1, m);
xx=spline(t, x, tt);
yy=spline(t, y, tt);

figure;
plot(x,y,'o',xx,yy,'r',LineStyle=':',LineWidth=1.5);



