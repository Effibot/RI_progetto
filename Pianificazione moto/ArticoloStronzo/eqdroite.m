function D=eqdroite(A,B) 
% Function that gives the coefficients a and b that satisfy the following 
% equation of the line (AB) y=a*xb 
a=(B(2)-A(2))/(B(1)-A(1)); 
b=A(2)-a*A(1); 
D=[a b]; 
end 
