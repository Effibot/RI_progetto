function spline = makePath(nodeidList,nodeList)
%MAKEPATH Summary of this function goes here
%   Detailed explanation goes here
dimPath=size(nodeidList,2);
nPoints=double.empty(0,2);
t=1:1:dimPath;
for i =1:dimPath
    node = findobj(nodeList,'id',nodeidList(i));
    if ~isempty(node)
        nPoints(end+1,:)=node.bc;
    end
end
%% Example Spline two Points
% Grafico (x,t)
dist=pdist([nPoints(1,1),nPoints(1,2);nPoints(2,1),nPoints(2,2)],'euclidean');
tbc=[0,128];
t=0:1:dist;
xbc=[nPoints(1,2),nPoints(2,2),0,0];
ybc=[nPoints(1,1),nPoints(2,1),0,0];

[x,y,yyy]=splineEq(xbc(1),xbc(2),xbc(3),xbc(4),ybc(1),ybc(2));
% plot spline
figure
hold on
xx=double(subs(x,t));
yy=double(subs(y,t));
% yx=double(subs(yyy,t));
plot(t,xx);
plot(tbc,[xbc(1),xbc(2)],'or')
% fplot(x);
% plot([xbc(1),xbc(2)],'or');
title('x vs. t for Cubic Spline Equation')
%Grafico (y,t)
figure
hold on

% y=splineEq(,ybc(3),ybc(4));
plot(t,yy);
plot([ybc(1),ybc(2)],'or');
title('y vs. t for Cubic Spline Equation')

figure
plot(xx,yy,xbc(end-1),ybc(end-1),'or');
title('y vs. x for Cubic Spline Equation')
end

function [x,y,yyy]=splineEq(x0,xf,slope0,slopef,y0,yf)
%Cubic Spline: solving
% xdot0 = 1; xdotf = 1;
% x(t0) = x0; % position of initial coordinate
% x(tf) = xf; % position of final coordinate
% xdot(t0) = xdot0; % slope of initial coordinate
% xdot(tf) = xdotf; % slope of final coordinate
syms x xdot a0 a1 a2 a3 t y ydot yyy
x = a0+a1*t+a2*t^2+a3*t^3;
xdot = a1+2*a2*t+3*a3*t^2;
% Boundary Conditions [C]*[a0;a1;a2;a3]=bc
%Inserting the values of the initial conditions for t, 
% we get x and xdot as a function of a1,a2,a3,a4.
bc0=subs(x,t,x0);
bc1=subs(x,t,xf);
bc2=subs(xdot,t,slope0);
bc3=subs(xdot,t,slopef);
%Coefficients to define a spline equation taking coeff of bc
[C,~]=equationsToMatrix(bc0,bc1,bc2,bc3,[a0,a1,a2,a3]);
%Solving the eq to obtain a coeffs
%N.B.: '\': x = A\B solves the system of linear equations A*x = B.
% The matrices A and B must have the same number of rows. 
% MATLAB® displays a warning message if A is badly scaled or nearly singular, 
% but performs the calculation regardless.
% If A is a scalar, then A\B is equivalent to A.\B.
% 
% If A is a square n-by-n matrix and B is a matrix with n rows, then x = A\B is a solution to the equation A*x = B, if it exists.
% 
% If A is a rectangular m-by-n matrix with m ~= n, and B is a matrix with m rows, then A\B returns a least-squares solution to the system of equations A*x= B.
xbc=[y0;yf;slope0;slopef];
a = C\xbc; % a = [a1 a2 a3 a4]';
display(a);
%Equazione della spline
yyy = a(1)+a(2)*x+a(3)*x.^2+a(4)*x.^3;


x=a(1)+a(2)*t+a(3)*t.^2+a(4)*t.^3;


%y
y=a0+a1*t+a2*t^2+a3*t^3;
ydot =a1+2*a2*t+3*a3*t^2;
% Boundary Conditions [C]*[a0;a1;a2;a3]=bc
bc0=subs(y,t,y0);
bc1=subs(y,t,yf);
bc2=subs(ydot,t,45);
bc3=subs(ydot,t,45);
%Coefficients to define a spline equation taking coeff of bc
[C,~]=equationsToMatrix(bc0,bc1,bc2,bc3,[a0,a1,a2,a3]);
%Solving the eq to obtain a coeffs
%N.B.: '\': x = A\B solves the system of linear equations A*x = B.
% The matrices A and B must have the same number of rows. 
% MATLAB® displays a warning message if A is badly scaled or nearly singular, 
% but performs the calculation regardless.
% If A is a scalar, then A\B is equivalent to A.\B.
% 
% If A is a square n-by-n matrix and B is a matrix with n rows, then x = A\B is a solution to the equation A*x = B, if it exists.
% 
% If A is a rectangular m-by-n matrix with m ~= n, and B is a matrix with m rows, then A\B returns a least-squares solution to the system of equations A*x= B.
ybc=[x0;xf;slope0;slopef];
a = C\ybc; % a = [a1 a2 a3 a4]';
y = a(1)+a(2)*t+a(3)*t.^2+a(4)*t.^3;

end
