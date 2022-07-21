clc
clear
clf
%%
load("pp.mat")
%%
nPoints = nPoints';
newPoints = [];
p = nPoints(1,:);
p1=nPoints(2,:);
% tf1=5;
% delta_t1=0.01;
% t1=ti:delta_t1:tf1;

% ti=0;
% tf2=10;
% delta_t2=0.01;
% t2=tf1:delta_t2:tf2;
% time=[t1,t2];
ti = 0;
tf2 = length(p)-4;
delta = 0.01;
time=ti:delta:tf2;
% time = linspace(0,7,7000);
px=[];
vx = [];
py=[];
vy=[];
k = 1;
for j = 2:length(p)-1
    p_i = p(j-1);
    pf2 = p(j);
    p_i1= p1(j-1);
    pf21=p1(j);
    vi = diff(p(j-1:j))*delta;
    vf = diff(p(j:j+1))*delta;
    vi1 = diff(p1(j-1:j))*delta;
    vf1 = diff(p1(j:j+1))*delta;
    if j == 1
        vi =0;
        vi1=0;
    elseif j==length(p)-1
        vf = 0;
        vf1 = 0;
    end

    for i = 1: size(time,2)-1
        currtime = time(i);
        [a,b] = CartesianPlanner(p_i, pf2,ti, tf2,currtime,vi,vf);
        [c,d] = CartesianPlanner(p_i1, pf21,ti, tf2, currtime,vi1,vf1);
        px = [px,a];
        vx = [vx,b];
        py = [py,c];
        vy = [vy,d];
    end
    %     plot(px)
    %     pause();
end

subplot(2,3,1)
plot(px)
subplot(2,3,2)
plot(py)
subplot(2,3,3)
plot(px,py)
subplot(2,3,4)
plot(vx)
subplot(2,3,5)
plot(vy)



%%
xp =px;
yp = py;
vxp=vx;
vyp=vy;
x0 = xp(1);
y0 = yp(1);
v0x = vxp(1);
v0y = vyp(1);
%%
function [pd, pdot] = CartesianPlanner(p_i,  pf2, ti, tf1,t,vin,vf1)

s = length(p_i);

if t<ti
    pd=p_i;
    pdot=zeros(s,1);

elseif t<=tf1

%     A=[ti^5 ti^4 ti^3 ti^2 ti 1;
%         tf1^5 tf1^4 tf1^3 tf1^2 tf1 1;
%         5*ti^4 4*ti^3 3*ti^2 2*ti 1 0;
%         5*tf1^4 4*tf1^3 3*tf1^2 2*tf1 1 0;
%         20*ti^3 12*ti^2 6*ti 2 0 0;
%         20*tf1^3 12*tf1^2 6*tf1 2 0 0];
%     b1=[0;norm(p_i-pf2);vin;vf1;0;0];
            A = [ti^3 ti^2 ti 1;
                tf1^3 tf1^2 tf1 1;
                3*ti^2 2*ti 1 0;
                3*tf1^2 2*tf1 1 0];
            b1 = [0;norm(pf2-p_i);vin;vin+vf1];
    x=inv(A)*b1;
    %
%     s=x(1)*t^5+x(2)*t^4+x(3)*t^3+x(4)*t^2+x(5)*t+x(6);
%     sdot=5*x(1)*t^4+4*x(2)*t^3+3*x(3)*t^2+2*x(4)*t+x(5);
    %
            s= x(1)*t^3+x(2)*t^2+x(3)*t+x(4);
            sdot= 3*x(1)*t^2+2*x(2)*t+x(3);

    if norm(p_i-pf2)~=0
        pd=p_i+(s/norm(p_i-pf2))*(pf2-p_i);
        pdot=(sdot/norm(p_i-pf2))*(pf2-p_i);
    else
        pd = p_i;
        pdot = 0;
    end
end
end

% Af =@(ti,tf)[ti^3 ti^2 ti 1
%     3*ti^2 2*ti 1 0
%     tf^3 tf^2 tf 1
%     3*tf^2 2*tf 1 0];
% Bf = @(pi,pf,vi,vf)[pi;vi;pf;vf];
%
% qt=@(A,B,C,D,t) A*t^3+B*t^2+C*t+D;
% vt=@(A,B,C,t) 3*A*t^2+2*B*t+C;
% p = [-1.5,-0.2,1,5,10,15,20];
% tc = 0:11;
% X=[];
% for i = 1:length(p)-1
%     ti = tc(i);
%     tf=tc(i+1);
%     A=Af(ti,tf);
%     B=Bf(p(i),p(i+1),0,0);
%     %     B=Bf(p(i,1),p(i+1,1),0,0,0,0);
%     X=[X,A\B];
% end
% X=X';
% sx = size(p,2);
% t = linspace(0,sx+1,sx*100);
% ptp =[];
% vtp=[];
% for i=1:sx-1
%     interv = t(i:4*i);
%     for l = 1:length(interv)
%     ptp = [ptp,qt(X(i,1),X(i,2),X(i,3),X(i,4),interv(l))];
%     vtp =[vtp, vt(X(i,1),X(i,2),X(i,3),interv(l))];
%     end
% en