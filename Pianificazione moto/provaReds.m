clc
clear
clf
%%
load("pp.mat")
%%
nPoints = nPoints';
newPoints = [];
for i = 1: size(nPoints,2)-1
    curr= nPoints(:,i);
    succ = nPoints(:,i+1);
    mid = [(curr(1,1)+succ(1,1))/2;(curr(2,1)+succ(2,1))/2];
    newPoints =unique([newPoints,curr,mid,succ]','rows','stable')';
end
plot(nPoints(1,:),nPoints(2,:),'-b');
hold on
plot(newPoints(1,:),newPoints(2,:),'*r');
%%
clf
x=newPoints(1,:);
y=newPoints(2,:);
nPoints=nPoints';
step=0.001;
% tspan = linspace(0,1,1000);
tf = 7;
%%
% tinterp = linspace(0,1,7000);
% [q,dt,foft,step,spld]=interparc(7000,x,y,'makima');ppd2 = fnder(spld{1},2);
% d2zerolocs = slmsolve(ppd2,0);
% devpoint = fnval(ppd2,tspan);
% zci = @(x) find(diff([sign(x(:));0])~=0);                    % Returns Zero-Crossing Indices Of Argument Vector
% zx = zci(devpoint);
% figure(1)
% plot(tspan, devpoint, '-r')
% hold on
% plot(tspan(zx), devpoint(zx), 'bp')
% hold off
% grid
% legend('Signal', 'Approximate Zero-Crossings')
%%
[xp,vxp]= minimumEnergyLaw(tf,x');
[yp,vyp]= minimumEnergyLaw(tf,y');
figure(1)
subplot(2,2,1)
plot(xp,'-b');
subplot(2,2,2)
plot(yp,'-r');
subplot(2,2,3)
plot(vxp,'-b')
subplot(2,2,4)
plot(vyp,'-r')


% [a,t_interval,td]=trajectory_blend_quintic(x',7000,2);
% [a,t_interval,td]=trajectory_blend_quintic(y',7000,2);

%% Simulation
v0x = vxp(1);
v0y = vyp(1);
x0=xp(1);
y0=yp(1);
%% Function Utility
function [point,vpoint,apoint] = minimumEnergyLaw(tfinal,p)
point = double.empty;
vpoint =double.empty;
apoint = double.empty;

Af =@(ti,tf)[ti^3 ti^2 ti 1
    3*ti^2 2*ti 1 0
    tf^3 tf^2 tf 1
    3*tf^2 2*tf 1 0];
% Af =@(ti,tf)[
%     ti^5   ti^4   ti^3   ti^2 ti 1;
%     5*ti^4 4*ti^3 3*ti^2 2*ti  1 0;
%     20*ti^3 12*ti^2 6*ti 2     0 0;
%     tf^5   tf^4   tf^3   tf^2 tf 1;
%     5*tf^4 4*tf^3 3*tf^2 2*tf  1 0;
%     20*tf^3 12*tf^2 6*tf 2     0 0;
%     ];

Bf = @(pi,pf,vi,vf)[pi;vi;pf;vf];
% Bf = @(pi,pf,vi,vf,ai,af)[pi;vi;ai;pf;vf;af];

qt=@(A,B,C,D,t) A*t^3+B*t^2+C*t+D;
vt=@(A,B,C,t) 3*A*t^2+2*B*t+C;
% qt=@(A,B,C,D,E,F,t) A*t^5+B*t^4+C*t^3+D*t^2+E*t+F;
% vt=@(A,B,C,D,E,t) 5*A*t^4+4*B*t^3+3*C*t^2+2*D*t+E;
% at =@(A,B,C,D,t) 20*A*t^3+12*B*t^2+6*C*t+2*D;
interval = @(ti,tf,step) ti:step:tf;
timepoint = linspace(0,tfinal,7000);
deltat = max(timepoint)/length(p);
X=[];
ti = 0;
tf = deltat;
vf = 0;
for i = 1:length(p)-1
    

    A=Af(ti,tf);
    if i == length(point)-1
        vf = 2;

    end
    B=Bf(p(i,1),p(i+1,1),0,vf);

    %     B=Bf(p(i,1),p(i+1,1),0,0,0,0);
    X=[X,A\B];
    ti = ti+deltat;
    tf= tf+deltat;
end
tint=interval(0,7,0.001);
% tint = linspace(0,7,7000);
X=X';
k=1;
tf = 7;
T = 0.5;
ti = 0;
while T < tf    
    tx = linspace(ti,T,500);
    px = zeros(1,500);
    for t = tx
        px(ismember(tx,t)) = qt(X(k,1),X(k,2),X(k,3),X(k,4),t);
    end
    plot(tx,px);
    hold on
    k = k+1;
    ti = ti+0.5;
    T = T +0.5;
end

ti = tint(1,1);
for j = 2:size(tint,2)    
    %         tf = tint(i+1);
    %         pti = qt(X(1,1),X(2,1),X(3,1),X(4,1),X(5,1),X(6,1),ti);
    %         ptf = qt(X(1,1),X(2,1),X(3,1),X(4,1),X(5,1),X(6,1),tf);
    %         vti = vt(X(1,1),X(2,1),X(3,1),X(4,1),X(5,1),ti);
    %         vtf = vt(X(1,1),X(2,1),X(3,1),X(4,1),X(5,1),tf);
    %         ati = at(X(1,1),X(2,1),X(3,1),X(4,1),ti);
    %         atf = at(X(1,1),X(2,1),X(3,1),X(4,1),tf);
    pti = qt(X(k,1),X(k,2),X(k,3),X(k,4),ti);
    %     ptf = qt(X(1,1),X(2,1),X(3,1),X(4,1),tspan(i+1));
    vti = vt(X(k,1),X(k,2),X(k,3),ti);
    %     vtf = vt(X(1,1),X(2,1),X(3,1),tspan(i+1));
    %     vti = (vt(X(1,1),X(3,1),X(2,1),tspan(i));
    %     vtf = (vt(X(1,1),X(3,1),X(2,1),tspan(i+1));
    point(end+1)= pti;
    %         point(end+1) = ptf;
    vpoint(end+1)=vti;
    %         vpoint(end+1)=vtf;
    %         apoint(end+1)=ati;
    %         apoint(end+1)=atf;
    ti = tint(1,j);
end
end
function v = trapvel(tm,tc,am)
st = length(tm);
% tc = abs(max(tm)-min(tm))*20/100;
% am= vm/tc;

t0=min(tm);
v=zeros(1,st);
% sgn=-sgn;
for i = 2:st-1
    tcurr = tm(i);
    if tcurr<=t0+tc
        v(1,i)=am*tcurr+v(i-1);
        %         if v(1,i)>sgn*vm
        %             v(1,i)=sgn*vm;
        %         end
    elseif tcurr>t0+tc && tcurr< t0+4*tc
        %         +am*tc*(tcurr-tc)/2
        v(1,i)=v(i-1);
    elseif tcurr>=t0+4*tc
        v(1,i)=-am*tcurr+v(i-1);

    end
    %             plot(tm(1:i),v(1:i),'-b');
    %             drawnow
end
end

function [r,sgn] = intervalIndex(time,breaks,spld)
r=cell.empty;
dpdt = fnder(spld);
sgn = [];
breaks = [0;breaks];
for b = 1:length(breaks)-1
    %     breraks(b)
    r{end+1}=time(breaks(b)+1:breaks(b+1));
    %     sgn = [sgn,-sign(fnval(dpdt,time(min(breaks(b+1)+1,7000)))- ...
    %         fnval(dpdt,time(breaks(b+1)-1)))];
end
end
function [a,t_interval,td] = trajectory_blend_quintic(x,tf,afigure)
%This function blends quintic continuous polynomial between given path's
%via points.
%The inputs are via points vector, blend velocities vector, blend
%accelerations vector, time span, and logial operator to plot or not.
%It returns a matrix that includes the cofficients of each segment
%polynomial in a row order.

%% Initialization
j=size(x,2);
a=zeros((j-1),6);           % Initiating the cofficients matrix.
t=linspace(0,tf,j);         %Segmenting the time span into equal spans along each polynomial
step=0.003     ;             %Time step used for generating points along the polynomial
x_d=zeros(1,j);          %Initiating the Velocities vector.
x_dd=zeros(1,j);           %Initiating the accelerations vector.

%% Velocities Constraints Automatic Generating
for ii=1:(j-2)
    dk1=(x(ii+1)-x(ii))/(t(ii+1)-t(ii));
    dk2=(x(ii+2)-x(ii+1))/(t(ii+2)-t(ii+1));
    if sign(dk1)~=sign(dk2)
        x_d(ii+1)=0;
    else
        x_d(ii+1)=(dk1+dk2/2);
    end
end

%% Accelerations Constraints Automatic Generating
for ii=1:(j-2)
    dk1=(x_d(ii+1)-x_d(ii))/(t(ii+1)-t(ii));
    dk2=(x_d(ii+2)-x_d(ii+1))/(t(ii+2)-t(ii+1));
    if sign(dk1)~=sign(dk2)
        x_dd(ii+1)=0;
    else
        x_dd(ii+1)=(dk1+dk2/2);
    end
end

%% Calculating the polynomial cofficients at each pair of via points by iterations
for ii=1:(j-1)
    tr=t(ii+1)-t(ii); %time of the segment referenced to the initial time of the segment
    %M is the polynomial matrix for position, velocity, acceleration for
    %initial and final conditions of the segment
    M = [1   0   0     0      0        0;
        0   1   0     0      0        0;
        0   0   2     0      0        0;
        1   tr tr^2  tr^3   tr^4     tr^5;
        0   1  2*tr 3*tr^2 4*tr^3   5*tr^4;
        0   0   2    6*tr  12*tr^2  20*tr^3];
    %b is the initial and final conditions of the segment vector
    b = [x(ii);x_d(ii);x_dd(ii);x(ii+1);x_d(ii+1);x_dd(ii+1)];
    %a is the polynomial coffecients matrix
    a(ii,:)=(M\b)';       %a=inv(M)*b

    t_interval=t(ii):step:t(ii+1);
    td=t_interval-t(ii);
    %% Plotting the trajectories
    if afigure==1
        figure(2);
        hold on
        plot(t_interval,a(ii,1)+a(ii,2)*td+a(ii,3)*td.^2+a(ii,4)*td.^3+a(ii,5)*td.^4+a(ii,6)*td.^5,'k','LineWidth',2.5);


        figure(3)
        hold on
        plot(t_interval,a(ii,2)+ 2*a(ii,3)*td+3*a(ii,4)*td.^2+4*a(ii,5)*td.^3+5*a(ii,6)*td.^4,'k','LineWidth',2.5);


        figure(4);
        hold on
        plot(t_interval, 2*a(ii,3) +6*a(ii,4)*td+12*a(ii,5)*td.^2+20*a(ii,6)*td.^3,'k','LineWidth',2.5);

    end
    if afigure==2
        figure(2);
        hold on
        plot(t_interval,a(ii,1)+a(ii,2)*td+a(ii,3)*td.^2+a(ii,4)*td.^3+a(ii,5)*td.^4+a(ii,6)*td.^5,'b','LineWidth',2.5);
        title('Position Trajectory')
        xlabel('Time','FontSize',12,'FontWeight','bold','Color','r')
        ylabel('Position (X,Y) Value in m','FontSize',12,'FontWeight','bold','Color','r')

        grid on

        figure(3)
        hold on
        plot(t_interval,a(ii,2)+ 2*a(ii,3)*td+3*a(ii,4)*td.^2+4*a(ii,5)*td.^3+5*a(ii,6)*td.^4,'b');
        title('Velocity Trajectory')
        xlabel('Time','FontSize',12,'FontWeight','bold','Color','r')
        ylabel('Velocity (X,Y) Value in m/s','FontSize',12,'FontWeight','bold','Color','r')

        grid on

        figure(4);
        hold on
        plot(t_interval, 2*a(ii,3) +6*a(ii,4)*td+12*a(ii,5)*td.^2+20*a(ii,6)*td.^3,'b','LineWidth',2.5);
        title('Acceleration Trajectory')
        xlabel('Time','FontSize',12,'FontWeight','bold','Color','r')
        ylabel('Acceleration (X,Y) Value in m/s2','FontSize',12,'FontWeight','bold','Color','r')

        grid on
    end

end

end


