function [d,M]=distrd(rectangle,A,B) 
% This fucntion calculate the distance between a line and a rectangle 
% assuming that the line does not go through the rectangle. 
 
%Calculation the coordinates of each vertice 
Xr=rectangle.Position; 
X1=[Xr(1) Xr(2)]; 
X2=[Xr(1)+Xr(3) Xr(2)]; 
X3=[Xr(1)+Xr(3) Xr(2)+Xr(4)]; 
X4=[Xr(1) Xr(2)+Xr(4)]; 
X=[X1;X2;X3;X4]; 
 
% Calculation of the distance between the line and each vertices 
d1=abs(det( [B-A;X1 -A] ))/norm(B -A);  
d2=abs(det([B-A;X2-A]))/norm(B-A);  
d3=abs(det([B-A;X3-A]))/norm(B-A);  
d4=abs(det([B-A;X4-A]))/norm(B-A); 
[d,i]=min([d1 d2 d3 d4]); % distance and index of the nearest vertex 
 
%Calcululation of its orthogonal projection 
D=eqdroite(A,B); 
C=X(i,:); 
M1=[-D(1) 1;A(1)-B(1) A(2)-B(2)]; M2=[D(2);(A(1)-B(1))*C(1)+(A(2)-B(2))*C(2)]; 
H=M1\M2; 
 
%Calculation of the coordinates of the point M 
HC=C-H'; 
HM=2/3*HC; 
M=HM+H'; 
end  
