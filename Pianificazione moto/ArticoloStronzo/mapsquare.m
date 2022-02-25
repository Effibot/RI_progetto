function r=mapsquare() 
% Map function with squares only called mapsquare 
taille=2; ecart=2; 
axis([-2 16 -2 16]); axis square; hold on; 
A1=[0 0]; 
r(1)=rectangle('Position',[A1(1) A1(2) taille taille],'FaceColor','k'); 
A2=A1; 
for k=1:3 
A2(2)=A2(2)+ecart+taille; 
r(1+k)=rectangle('Position',[A2(1) A2(2) taille taille],'FaceColor','k'); 
end 
for i=0:2 
A1( 1)=A 1(1)+ecart+taille; 
r(5+4*i)=rectangle('Position',[A1(1) A1(2) taille taille],'FaceColor','k');  
A2=A1; 
for k=1:3 
A2(2)=A2(2)+taille+ecart; 
r(5+4*i+k)=rectangle('Position',[A2(1) A2(2) taille taille],'FaceColor','k'); 
end 
end 
end
