%% Clearance  
clear all  
close all 
 
%% Parameters 
angled=30; %tolerance angle in degree  
V=0.25; %velocity of the robot  
r=0.05; %radius of the wheel  
L=0.15; %length between the two wheel 
 
%% Set of points studied 
%% Main 
map=@maprec1; % map choice 
figure(1) 
subplot(1,2,1); hold on;  
rec=map(); 
 
[u,v]=ginput; %function that allows the user to draw the points on the map 
u=u'; v=v';  
u1=u;v1=v; 
plot(u,v,'r+'); %the first set of points is drawn in red  
N=length(u); 
 
%Create a new set of points from the latest using the tolerance condition  
for i=1:N-2 
theta=angle([u(i) v(i)],[u(i+1) v(i+1)],[u(i+2) v(i+2)]); 
theta=abs(theta)*180/pi;  
if (180-angled<theta && theta<180+angled)  
u(i+1)=u(i);  
v(i+1)=v(i);  
end  
end 
 
%We erase from that new set the duplications  
P=[u' v']; 
P=union(P,P,'rows','stable'); 
P=P'; 
u=P(1,:); 
v=P(2,:); 
 
plot(u,v,'g+') %the set obtained is drawn in green 
 
%Initialisation of the different variable  
N=length(u); 
M1=[u(1) v(1)];  
d1=0;d2=0; 
t1=zeros( 1,N); t2=zeros( 1,N) ;t3=zeros( 1,N-1);  
w_L=zeros( 1 ,N-2) ;w_R=zeros( 1,N -2);
%Drawing of the best arcs possible for every two consecutive segments 
for k=1:N-2
[M2,M3,O,w_L(k),w_R(k)]=virage([u(k) v(k)],[u(k+1) v(k+1)],[u(k+2) v(k+2)],rec,V,r,L); 
plot([M1(1) M2(1)],[M1(2) M2(2)]); 
 darc=dessiner_arc(M2,M3,O); 
d1=d1 +distance (M1,M2)+darc; 
t1(k+1)=t3(k); 
t2(k+1)=distance(M1,M2)/V+t1(k+1);  
t3(k+1)=darc/V+t2(k+1); 
d2=d2+distance([u(k) v(k)],[u(k+1) v(k+1)]); 
M1=M3; 
end 
plot([M3(1) u(N)],[M3(2) v(N)]);  
d1=d1+distance(M3,[u(N) v(N)]);  
d2=d2+distance([u(N-1) v(N-1)],[u(N) v(N)]);  
t1(N)=t3(N-1); 
t2(N)=distance(M1,M2)/V+t1(N); 
 
str = sprintf('Path with curve optimization (longueur=%f)',d1); 
title(str); 
 
%Drawing of the second graph with the path unoptimized  
subplot(1,2,2); 
str2 = sprintf('Path without curve optimization (longueur=%f)',d2); 
title(str2);hold on; 
map(); 
plot(u1,v1,'r+')  
plot(u,v,'g+');  
for k=1:N-1 
plot([u(k) u(k+1)],[v(k) v(k+1)],'k');  
end 
 
%Drawing of the variation of the angular velocities  
figure(2); hold on; 
fplot(velocity(x,w_L,V,r,t2,t3),[0,t2(N)] ,'b');  
fplot(velocity(x,w_R,V,r,t2,t3),[0,t2(N)],'r','LineStyle','--'); 
