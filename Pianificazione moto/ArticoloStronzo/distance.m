function dist=distance(A,B) 
% This function gives the distance between two points. 
AB=B'-A'; 
dist=realsqrt(AB(1,:)^2+AB(2,:)^2); 
end
