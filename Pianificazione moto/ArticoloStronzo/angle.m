function theta=angle(B,A,C) 
% This function calculate the value of the oriented angle between the  
% vectors AB and AC using the scalar product and the determinant  
AB=B'-A'; 
AC=C'-A'; 
Na=realsqrt(AB (1,: )^2+AB (2,:)^2); 
Nb=realsqrt(AC( 1 ,:)^2+AC(2,:)^2); 
C=(AB(1,:)*AC(1,:)+AB(2,:)*AC(2,:))/(Na*Nb); 
S=(AB(1,:)*AC(2,:)-AB(2,:)*AC(1,:)); 
if (abs(C+1)<10^(-6))  
theta=pi; 
else 
theta=sign(S)*acos(C); 
end 
end 
