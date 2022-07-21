clc
clear
clf
%%
load("pp.mat")
%%
dim = length(nPoints);
tstart = 0;
tend = dim-1;
stepsize = 0.001;
time = tstart:stepsize:floor(tend/2);
x = nPoints(:,1);
y = nPoints(:,2);
[qx,qxd,qxdd]=smoothSpline(dim,x,time,tstart);
subplot(4,2,1)
plot(qx,'b')

subplot(4,2,3)
plot(qxd,'c')

subplot(4,2,5)
plot(qxdd,'m')

[qy,qyd,qydd]=smoothSpline(dim,y,time,tstart);
subplot(4,2,2)
plot(qy,'b')

subplot(4,2,4)
plot(qyd,'c')

subplot(4,2,6)
plot(qydd,'m')

subplot(4,2,[7 8])
plot(qx,qy,'k')

xp = qx;
yp = qy;
vxp=qxd;
vyp=qyd;
apx = qxdd;
apy = qydd;
x0=xp(1);
y0=yp(1);
v0x=vxp(1);
v0y =vyp(1);
%%
function [q,qd,qdd] = smoothSpline(dim,nPoints,time,tstart)
q = double.empty;
qd = double.empty;
qdd = double.empty;
vi=0;
ai=0;
for i = 2:dim
    interval = time((i-2)*100*floor(dim/2)+1:(i-1)*100*floor(dim/2));
    pi = nPoints(i-1,:);
    pf = nPoints(i,:);
    ti = interval(1);
    tf1 = interval(end);


    %     if i==dim
    %         vf=0;
    %     elseif i == 2
    %         vf = Rk1;
    % %     elseif sign(Rk)==sign(Rk1)
    % %         vf = (Rk1+Rk)*(0.5);
    % %
    % %     else
    % %         vf = 0;
    %     end
    for t=interval
        if t ==tstart
            q(end+1)=pi;
            qd(end+1)=0;
            qdd(end+1)=0;
        else
            Rk = (q(end)-pi)/((t-1e-3)-ti);
            Rk1 = (pf-q(end))/(tf1-(t-1e-3));
            if i==dim
                vf =0;
            else
                interval1 = time((i-1)*100*floor(dim/2)+1:(i)*100*floor(dim/2));
                pf2 = nPoints(i+1,:);
                tf2 = interval1(end);
                Rk = (pf-pi)/(tf1-ti);
                Rk1 = (pf2-pf)/(tf2-tf1);
                if sign(Rk)==sign(Rk1) && i~=2 && i<dim-1
                    vf = (Rk+Rk1)*0.5;
                else
                    vf=0;
                end
            end
            %             A = [
            %                 ti^3 ti^2 ti 1;
            %                 tf1^3 tf1^2 tf1 1;
            %                 3*ti^2 2*ti 1 0;
            %                 3*tf1^2 2*tf1 1 0;
            %                 ];
            A=[ti^5 ti^4 ti^3 ti^2 ti 1;
                tf1^5 tf1^4 tf1^3 tf1^2 tf1 1;
                5*ti^4 4*ti^3 3*ti^2 2*ti 1 0;
                5*tf1^4 4*tf1^3 3*tf1^2 2*tf1 1 0;
                20*ti^3 12*ti^2 6*ti 2 0 0;
                20*tf1^3 12*tf1^2 6*tf1 2 0 0];
            b = [pi;pf;vi;vf;0;0];
            x = inv(A)*b;
            %             s= x(1)*t^3+x(2)*t^2+x(3)*t+x(4);
            %             sdot= 3*x(1)*t^2+2*x(2)*t+x(3);
            s = x(1)*t^5+x(2)*t^4+x(3)*t^3+x(4)*t^2+x(5)*t+x(6);
            sdot = 5*x(1)*t^4+4*x(2)*t^3+3*x(3)*t^2+2*x(4)*t+x(5);
            sddot = 20*x(1)*t^3+12*x(2)*t^2+6*x(3)*t+2*x(4);
            q(end+1)=s;
            qd(end+1)=sdot;
            qdd(end+1)=sddot;

        end

    end
    vi = vf;
    %     ai = sddot;
    %     subplot(4,2,1)
    %     plot(time(1:length(trajectory(:,1))),trajectory(:,1),'b')
    %     subplot(4,2,2)
    %     plot(time(1:length(trajectory(:,1))),trajectory(:,2),'r')
    %     subplot(4,2,3)
    %     plot(time(1:length(trajectory(:,1))),dtrajectory(:,1),'c')
    %     subplot(4,2,4)
    %     plot(time(1:length(trajectory(:,1))),dtrajectory(:,2),'y')
    %     subplot(4,2,5)
    %     plot(time(1:length(trajectory(:,1))),ddtrajectory(:,1),'m')
    %     subplot(4,2,6)
    %     plot(time(1:length(trajectory(:,1))),ddtrajectory(:,2),'g')
    %     subplot(4,2,7)
    %     plot(trajectory(:,1),trajectory(:,2),'b')
end
end


