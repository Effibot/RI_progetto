function h = circle(x,y,r,color)
d = r*2;
px = x-r;
py = y-r;
h = rectangle('Position',[px py d d],'Curvature',[1,1],...
    'FaceColor',color);
end