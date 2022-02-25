function [dmax,V]=restriction(r,P,N,Q,O,M1,M2) 
% The function returns the coordinates of the more distant vertex that  
% belongs to T and its distance from O  
 
%% Initialisation 
n=length(r);  
theta=angle(P,N,Q);  
theta2=angle(M1,O,M2);  
k=1; 
anglerec=zeros( 1,n);  
halfdiag=zeros( 1 ,n);  
indice=zeros(1,n); 
 
%% We erase all the rectangles whose centre is not in S  
for i=1:n 
Q2=r(i).Position; 
anglerec(i)=angle(P,N,[Q2(1)+Q2(3)/2 Q2(2)+Q2(4)/2]);  
halfdiag(i)=distance([Q2(1)+Q2(3)/2 Q2(2)+Q2(4)/2],[Q2(1) Q2(2)]);  
if (abs(anglerec(i))<abs(theta) && sign(anglerec(i))==sign(theta))  
indice(k)=i;  
k=k+1;  
end  
end 
 
indice(indice==0)=[]; 
% If S is empty then we stop then it is finished  
if isempty(indice)==1  
dmax=0; 
V=0; 
else 
 
%% We erase all the rectangles whose centre is not in S'  
indice2=zeros( 1,length(indice)); 
halfdiagmax=max(halfdiag);  
drec=zeros(1,length(indice));  
drecmax=halfdiagmax+distance(N,M1); 
u=1; 
for m=1:length(indice) 
Q2=r(indice(m)).Position; 
drec(m)=distance(N,[Q2(1)+Q2(3)/2 Q2(2)+Q2(4)/2]);  
if drec(m)<drecmax  
indice2(u)=indice(m); 
u=u+1;  
end  
end 
indice2(indice2==0)=[]; 
 
% If S' is empty then we can stop  
if isempty(indice2)==1  
dmax=0; 
V=0; 
else 
 
% Else we have to find all the vertices that are in T 
vertex=zeros(4,2); 
t=1; 
for u=1:length(indice2) 
Q2=r(indice2(u)) .Position;  
vertex(1,:)=[Q2(1) Q2(2)];  
vertex(2,:)=[Q2(1)+Q2(3) Q2(2)];  
vertex(3,:)=[Q2(1)+Q2(3) Q2(2)+Q2(4)];  
vertex(4,:)=[Q2(1) Q2(2)+Q2(4)];  
for v=1:4 
anglevertex=angle(M1,O,vertex(v,:)); 
if (abs(anglevertex)<abs(theta2) && sign(anglevertex)==sign(theta2))  
goodvertex(t,: )=vertex(v,:);  
t=t+1;  
end  
end  
end 
 
% If T is empty then we can stop  
if t==1  
dmax=0; 
V=0; 
else 
 
%% We have to find the more distant from O 
d=zeros(1,t-1); 
for w=1:t-1 
d(w)=distance(O,[goodvertex(w,1) goodvertex(w,2)]); 
end 
[dmax,I] =max(d); 
V=goodvertex(I,:);  
end  
end  
end  
end 
