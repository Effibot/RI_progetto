function d=dessiner_arc(M1,M2,O) 
% This function draws the arc with centre O knowing the point where it 
% begins and ends. It also returns the length of the arc.  
R=distance(M1,O);  
theta1=angle(M1,O,M2); 
M3=[O(1)+4 O(2)];  
theta2=angle(M3,O,M1); 
k=0:0.1:1; 
x=O( 1)+R*cos(theta2+k*theta1); 
y=O(2)+R*sin(theta2+k*theta1); 
plot(x,y); 
d=R*abs(theta1); 
end
