function rec=procherect(r,P,N,Q) 
% First approach of the no-collision condition  
n=length(r);  
theta=angle(P,N,Q);  
k=1; 
anglerec=ones( 1,n);  
indice=zeros(1,n);  
for i=1:n 
Q2=r(i).Position; 
anglerec(i)=angle(P,N,[Q2(1)+Q2(3)/2 Q2(2)+Q2(4)/2]);  
if (abs(anglerec(i))<abs(theta) && sign(anglerec(i))==sign(theta))  
indice(k)=i; k=k+1;  
end  
end 
 
indice(indice==0)=[]; 
 
I=length(indice); 
d=zeros(1,I); 
 
for p=1:I 
A=r(indice(p)).Position;  
d(p)=distance(N,[A( 1)+A(3)/2 A(2)+A(4)/2]);  
end 
 
[~,m]=min(d); 
rec=r(indice(m)); 
end 
