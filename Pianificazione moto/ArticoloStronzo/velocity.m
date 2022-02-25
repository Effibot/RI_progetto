function y=velocity(x,w_L,V,r,t2,t3)
% This function create the variation of the angular speed of a wheel  
% knowing the different values over time 
y=V/r; 
for k=1: length(w_L) 
y=y+(w_L(k)-V/r)*(heaviside(x-t2(k+1))-heaviside(x-t3(k+1))); 
end 
end
