function [d,M]=distpd(V,A,B) 
% This fucntion calculate the distance between a line and a rectangle 
% assuming that the line does not go through the rectangle. V is the vector  
% that contains all the coordinates of the vertices. 
 
% Calculation of the distance between the line and each vertices 
d=abs(det( [B-A;V-A] ))/norm(B -A); 
 
% Calculation of its orthogonal projection 
D=eqdroite(A,B); 
M1=[-D(1) 1;A(1)-B(1) A(2)-B(2)]; 
M2=[D(2) 1;(A( 1)-B(1))*V(1) (A(2)-B(2))*V(2)]; 
H=M1\M2; 
 
% Calculation of the coordinates of the point M  
HV=V-H'; 
HM=2/3*HV; 
M=HM+H'; 
end
