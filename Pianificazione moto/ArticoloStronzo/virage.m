function [M1,M2,O,w_L,w_R]=virage(P,N,Q,rec,V,r,L) 
 
%% Initialisation of the variables  
theta=angle(P,N,Q); 
Rtheta=[cos(theta/2) -sin(theta/2) 0 ;sin(theta/2) cos(theta/2) 0; 0 0 1];  
Rtheta2=[cos(theta) -sin(theta) 0 ;sin(theta) cos(theta) 0; 0 0 1]; 
T1=[1 0 N(1);0 1 N(2); 0 0 1]; 
T2=[1 0 -N(1);0 1 -N(2); 0 0 1]; 
T=T1*Rtheta*T2; 
T3=T1*Rtheta2*T2; 
 
%% Preliminary study % Creation of the bisector  
B=T*[P(1) P(2) 1]'; 
B=[B(1) B(2)]; 
D=eqdroite(N,B); 
 
% Intersection point of the perpendicular in P and the bisector  
O1=centre(P,N,D); 
 
%% Finding the largest arc possible 
% Calculate dmin the minimum between half of the distance PN and NQ 
d1=distance(N,P); 
d2=distance(N,Q); 
d=[d1 d2]; 
dmin=1/2*min(d); 
 
% M is the point on PN that satisfies NM=dmin  
NP=P-N; 
NM=dmin*NP/d1; 
M=NM+N; 
 
%% Find the radius and the centre of the arc that is tangent NP and NQ and goes through M 
R=(dmin*distance(P,O1))/(distance(N,P));  
 
%thanks to the theorem of Thales  
O=centre(M,N,D); 
 
 
%% Deduce the point M1 and M2  
M1=M; 
M2=T3*[M(1) M(2) 1]'; 
M2=[M2(1) M2(2)]; 
 
%% Find the coordinates of the more distant vertex that belongs to T and its distance from O 
[dmax,V1]=restriction(rec,P,N,Q,O,M1,M2); 
 
%% Test the value and do accordingly 
% 1st Case : dmax<R then the best arc is the largest arc possible  
% 2nd case : we have to find an arc that do not collide  
if dmax>R 
[d3,M3]=distpd(V1,P,N); 
[d4,M4]=distpd(V1,P,Q);  
distmin=min(d3,d4);  
if distmin==d3 
M=M3; 
else 
M=M4; 
end 
 
%% Find the radius of the arc, the point M1, M2 and O 
R=rayon_pt(P,N,O1,M); 
 
%Solution using the theorem of Thales and the fact that NM and NP are 
%collinear and in the same sens 
nPO1=distance(P,O1); 
NP=P-N; 
lambda=R/nPO1;  
 
%we also have lambda=nNM/nNP  
NM1=lambda*NP; 
M1=NM1+N; 
M2=T3*[M1(1) M1(2)]'; 
 
% M2 is the image of M1 with a rotation with angle theta  
M2=[M2(1) M2(2)]; 
O=centre(M1,N,D); 
end 
 
%% Calculation of the angular speeds needed to follow such arc 
if theta<0 
w_L=V/r*(1-L/(2*R)); 
w_R=V/r*(1+L/(2*R)); 
else 
w_L=V/r*(1+L/(2*R));  
w_R=V/r*( 1 -L/(2*R));  
end  
end
