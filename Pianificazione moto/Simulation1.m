clc
close all
clear
%%
load("trajectory.mat")
% waypoints=interparc(1000,points(:,1)',points(:,2)','makima');


% tau = step;
% t=tau.*T;
% dt=gradient(t);
% dtaudt=gradient(tau,t);
% 
% chordlen = sqrt(sum(diff(waypoints,[],1).^2,2));
% 
% % Normalize the arclengths to a unit total
% chordlen = chordlen/sum(chordlen);
% 
% % cumulative arclength
% cumarc = [0;cumsum(chordlen)];
% 
% dsdtau=gradient(cumarc,tau);
% velBound=[gradient(waypoints(:,1))./gradient(sampletime(1:end-1))',gradient(waypoints(:,2))./gradient(sampletime(1:end-1))'];
% adiff= [fnder(fnder(foft{1})),fnder(fnder(foft{2}))];
% aBound = [fnval(adiff(1),sampletime);fnval(adiff(2),sampletime)]';
% aBound=[gradient(velBound(:,1))./gradient(sampletime(1:end-1))',gradient(velBound(:,2))./gradient(sampletime(1:end-1))'];
% v1=velBound(1,:)
% v2=velBound(2,:);
waypoints=points;
w1=waypoints(:,2)';
w2=waypoints(:,1)';
theta=[];
conds=[0 0];
sampletime=linspace(0,1,length(w1));
%%
vX = fnder(foft{1});
aX = fnder(vX);
% vXp = fnval(vX,sampletime);
vXp= gradient(w1)./gradient(sampletime);
% aXp = fnval(aX,sampletime);
aXp = gradient(vXp)./gradient(sampletime);
vY = fnder(foft{1});
aY = fnder(vY);
% vYp = fnval(vY,sampletime);
vYp= gradient(w2)./gradient(sampletime);

% aYp = fnval(aY,sampletime);
aYp = gradient(vYp)./gradient(sampletime);





%%
% [q,qd,qdd,t] = trapveltraj(waypoints,7278,PeakVelocity=0.5);
% % points = csape(sampletime,waypoints(:,1)',[0,0]);
% pointX = waypoints(:,1);
% % figure
% % fnplt(points);
% vX = gradient(pointX')./gradient(sampletime);
% % vX = fnval(csape(sampletime,[0,fnval(fnder(points),sampletime),0],[0,0]),sampletime);
% 
% % pointssY = csape(sampletime,pointX,[0 0]);
% pointY = waypoints(:,2);
% vY = gradient(pointY')./gradient(sampletime);
% % vY= fnval(csape(sampletime,[0,fnval(fnder(pointssY),sampletime),0],[0,0]),sampletime);
% 
% 
% velBound=[vX;vY]';
% aBound = (gradient(velBound',1)./gradient(sampletime));
% velBound=[vX;vY];
% aBound = aBound';
% theta= atan2(pointY,pointX);
% omega = gradient(theta',1)./gradient(sampletime);
% alpha = gradient(omega)./gradient(sampletime);
% % [q,qd,qdd,t] = trapveltraj(waypoints',7278,PeakVelocity=0.5);
% % waypoints=q';
% % velBound = qd';
% % aBound = qdd';
%  waypoints=waypoints';
%  %%
x0 = w1(1);
y0 = w2(1);
v0x= vXp(1);
v0y= vYp(1);
% theta0=theta(1);
% omega0=omega(1);
M=1;
I=1;

%%
% clear
% close all
% clc
% load('pp.mat')
% % [a,b,c,d,e]=interparc(50,nPoints(:,2)',nPoints(:,1)','makima');
% % 
% % DX=gradient(a(:,1),0.1);
% % quiver(linspace(0,50,50)',a(:,1)',gradient(linspace(0,50,50),0.2)',DX);
% % hold on
% % plot(50,a(end,1),'*r')
% % figure
% % plot(linspace(0,50,50),DX);
% % t=linspace(0,1,11)';
% % dx = [gradient(nPoints(:,1)),gradient(nPoints(:,2))]./gradient(t);
% pp=csape({nPoints(:,1)',nPoints(:,2)'},magic(11),{'clamped','second'});
% 
% 
% %%
% function plotraj(titleText,t,q,qd,wpts,tpts)
% 
% % Plot 2D position 
% figure
% sgtitle(titleText);
% 
% subplot(2,2,[1 3]);
% plot(q(1,:),q(2,:));
% hold all
% plot(wpts(1,:),wpts(2,:),'x','MarkerSize',7,'LineWidth',2);
% xlim('padded');
% ylim('padded');
% xlabel('X');
% ylabel('Y');
% title('2-D Trajectory')
% 
% % Plot X and Y position with time
% subplot(2,2,2);
% plot(t,q);
% if nargin > 5
%     hold all
%     plot(tpts,wpts,'x','MarkerSize',7,'LineWidth',2);
% end
% ylim('padded')
% xlabel('Time');
% ylabel('Position');
% title('Position vs Time');
% legend({'X','Y'})
% 
% % Plot X and Y velocity with time
% subplot(2,2,4);
% plot(t,qd)
% ylim('padded')
% xlabel('Time');
% ylabel('Velocity');
% title('Velocity vs Time');
% legend({'X','Y'})
% 
% end


