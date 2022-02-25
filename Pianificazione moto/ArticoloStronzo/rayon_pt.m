function R1=rayon_pt(P,N,O1,M) 
% This function calculate the radius of the circle tangent to PN that  
% goes through M, knowing the centre of the circle tangent to PN in P  
Da=eqdroite(N,M);  
r=distance(O1,P); 
[xout,yout]=linecirc(Da(1),Da(2),O1(1),O1(2),r); 
M1=[xout(1) yout(1)]; 
M2=[xout(2) yout(2)]; 
R(1)=distance(N,M) *r/distance(N,M1); 
R(2)=distance(N,M) *r/distance(N,M2); 
R1=max(R); 
end 

