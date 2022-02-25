function O=centre(P,N,D) 
% Function that give the coordinate of the centre O of the circle which is  
% tangent to PN in P. The centre must belong to the line D 
M1=[D(1)-1;P(1)-N(1)*P(2)-N(2)]; 
M2=[-D(2);P(1)*(P(1)-N(1))+P(2)*(P(2)-N(2))]; 
O=M1\M2; 
O=O'; 
end
