clc
clear all
clf
%%
r=rateControl(100);
syms mu x y z alpha gamma beta t...
    x_dot y_dot z_dot


q=sym('a',[6,1]);
qd=sym('a',[6,1]);
qdd=sym('a',[6,1]);
L=[40;62;0;60;0;12];

D=sym('a',[6,1]);
R=sym('a',[3,3]);

for i=1:6
    q(i,1)=sym(str2sym(strcat('q',num2str(i))));
    qd(i,1)=sym(str2sym(strcat('q_dot',num2str(i),'(t)')));
    qdd(i,1)=sym(str2sym(strcat('q_ddot',num2str(i),'(t)')));
    %     L(i,1)=sym(str2sym(strcat('L_',num2str(i))));
    D(i,1)=sym(str2sym(strcat('D_',num2str(i))));
end
for i=1:3
    for j=1:3
        Rij=strcat('R_',num2str(i*10+j));
        R(i,j)=sym(str2sym(Rij));
    end
end
% assume(q,'real');
% assume(qd,'real');
% assume(qdd,'real');
% assume(D,'real');
% assume(R,'real');

%%
dof=6;
col=4;
dhparams=sym('b',[dof,col]);
dhparams(1,1:end)=[q(1,1),L(1,1),-pi/2,0];
dhparams(2,1:end)=[q(2,1),0,0,L(2,1)];
dhparams(3,1:end)= [q(3,1),0,-pi/2,L(3,1)];
dhparams(4,1:end)= [q(4,1),L(4,1),pi/2,0];
dhparams(5,1:end)= [q(5,1),0,-pi/2,0];
dhparams(6,1:end)=[q(6,1),L(6,1),0,0];

dr=DH(dhparams(1:6,:));
d=dr(1:3,4);
directKinematics = matlabFunction(d);

drr = DH(dhparams(1:6,:));
Rq =drr(1:3,1:3);
% Tomega1= eye(3);
% Romega1= Tomega1(1:3,1:3);
% omega1 = Romega1*[0;0;1];
% Tomega2= DH(dhparams(1:1,:));
% Romega2= Tomega2(1:3,1:3);
% omega2 = Romega2*[0;0;1];
% Tomega3= DH(dhparams(1:2,:));
% Romega3= Tomega3(1:3,1:3);
% omega3 = Romega3*[0;0;1];
% Tomega4= DH(dhparams(1:3,:));
% Romega4= Tomega4(1:3,1:3);
% omega4 = Romega4*[0;0;1];
% Tomega5= DH(dhparams(1:4,:));
% Romega5= Tomega5(1:3,1:3);
% omega5 = Romega5*[0;0;1];
% Tomega6= DH(dhparams(1:5,:));
% Romega6= Tomega6(1:3,1:3);
% omega6 = Romega6*[0;0;1];
% omega = [omega1,omega2,omega3,omega4,omega5,omega6];
% % Jp= jacobian(d,q);
% % J=[Jp;omega];
% J=Jac(dhparams,L);
%
% Rx = [1 0 0; 0 cos(alpha) -sin(alpha); 0 sin(alpha) cos(alpha)]
% Ry = [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)]
% Rz = [cos(gamma) -sin(gamma) 0; sin(gamma) cos(gamma) 0; 0 0 1]
% % Rnautic=Rz*Ry*Rx
% xdes = 5;
% ydes = -40;
% zdes = 60;
% roll = 0;
% pitch = 0;
% yaw = 0;
% P=[xdes;ydes;zdes;roll;pitch;yaw];
%
% q0=[0;pi/2;pi/2;0.1;0;0];
% J=matlabFunction(J);
% d=matlabFunction(d);
% R06 = matlabFunction(Rq);
%%
xdes = 40;
ydes = 50;
zdes = 100;
roll = 0;
pitch = 0;
yaw = 0;
P=[xdes;ydes;zdes;roll;pitch;yaw];
q0=[0.01;-pi/2;-pi/2;0.01;0.01;0.01];
%%
de = DH(dhparams);
dep = de(1:3,4);
pitchp = atan2(sqrt(1-Rq(3,3)^2),Rq(3,3));
rollp=atan2(Rq(3,2)/sqrt(1-Rq(3,3)^2),Rq(3,1)/(-sqrt(1-Rq(3,3)^2)));
yawp = atan2(Rq(2,3)/sqrt(1-Rq(3,3)^2),Rq(1,3)/sqrt(1-Rq(3,3)^2));
hq = matlabFunction([dep;pitchp;rollp;yawp]);
j = jacobian([dep;pitchp;rollp;yawp],q);
J= matlabFunction(j);
k=0.01;
err = [dep;pitchp;rollp;yawp]-P;
E = matlabFunction(err);
%%
T01 = DH(dhparams(1,:));
d01 = T01(1:3,4);
d1=d01;
T02 = DH(dhparams(1:2,:));
d02 = T02(1:3,4);
d2=matlabFunction(d02);
T03 = DH(dhparams(1:3,:));
d03 = T03(1:3,4);
d3=matlabFunction(d03);
T04 = DH(dhparams(1:4,:));
d04 = T04(1:3,4);
d4=matlabFunction(d04);
T05 = DH(dhparams(1:5,:));
d05 = T05(1:3,4);
d5=matlabFunction(d05);
T06 = DH(dhparams(1:6,:));
d06 = T06(1:3,4);
d6=matlabFunction(d06);
rho = norm([xdes;ydes;zdes]);
theta=0;
%%
figure(1)
hold on
h=plot3(xdes,ydes,zdes,'*r');
grid on
out=link2draw(q0,d1,d2,d3,d4,d5,d6);
i=0;
while 1
    % Newton
    Jval =J(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1),q0(6,1));
    Jinv = Jval*(Jval');
    errnorm =norm(E(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1),q0(6,1)))
    if errnorm>15
                disp('Newton');
        %         qdot = -JJt(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1))\...
        %             Jt(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1))*...
        %         (errf(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1),q0(6,1)));
        qdot = -pinv(Jval)*E(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1),q0(6,1));
        q1 = q0+0.005*qdot;

        %Gradient
    else
        disp('Gradiente');
        qdot = -Jval'*(E(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1),q0(6,1)));
        q1 = q0+5e-5*qdot;
    end
    q0=q1;

    hold off

    h=plot3(xdes,ydes,zdes,'*r');
    view([-41 13]);
    hold on
    grid on
    link2draw(q1,d1,d2,d3,d4,d5,d6);

    Pi=double(hq(q1(1,1),q1(2,1),q1(3,1),q1(4,1),q1(5,1),q1(6,1)));
    plot3(Pi(1,1),Pi(2,1),Pi(3,1),'-ob');
    pause(0.01);
    if errnorm<1.5 && i==0
         theta = wrapToPi(theta+20);
         xdes=rho*cos(theta);
         ydes=rho*sin(theta);
         zdes=zdes;
         i=1;
    else
        i=1;
    end
end

function out = link2draw(q0,d1,d2,d3,d4,d5,d6)

d01f = double(d1);
%Link 1
h1=plot3([0 d01f(1,1)],[0 d01f(2,1)],[0 d01f(3,1)],'LineWidth',3,'Color','b');

d02f = double(d2(q0(1,1),q0(2,1)));
%Link 1
h2=plot3([d01f(1,1) d02f(1,1)],[d01f(2,1) d02f(2,1)],[d01f(3,1) d02f(3,1)],...
    'LineWidth',3,'Color','y');


d03f = double(d3(q0(1,1),q0(2,1)));
%Link 1
h3=plot3([d02f(1,1) d03f(1,1)],[d02f(2,1) d03f(2,1)],[d02f(3,1) d03f(3,1)],'LineWidth',3 ...
    ,'Color','g');

d04f = double(d4(q0(1,1),q0(2,1),q0(3,1)));
%Link 1
h4=plot3([d03f(1,1) d04f(1,1)],[d03f(2,1) d04f(2,1)],[d03f(3,1) d04f(3,1)],'LineWidth',3 ...
    ,'Color','k');

d05f = double(d5(q0(1,1),q0(2,1),q0(3,1)));
%Link 1
h5=plot3([d04f(1,1) d05f(1,1)],[d04f(2,1) d05f(2,1)],[d04f(3,1) d05f(3,1)],'LineWidth',3 ...
    ,'Color','c');

d06f = double(d6(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1)));
%Link 1
h6=plot3([d05f(1,1) d06f(1,1)],[d05f(2,1) d06f(2,1)],[d05f(3,1) d06f(3,1)],'LineWidth',3 ...
    ,'Color','m');
out=[h1,h2,h3,h4,h5,h6];
end
%%
% dr03 = DH(dhparams(1:3,:));
% dr36 = DH(dhparams(4:6,:));
% d36=dr36(1:3,4);
% R36=dr36(1:3,1:3);
% d1= sym('d1',[3 1]);
% d0 = sym('d0',[3 1]);
% eq = d36==R36*d1;
% sol = solve(eq,[d1]);
% simplify(sol.d11)
% simplify(sol.d12)
% simplify(sol.d13)
% %159
% eqq=subs(eq,q(5,1),0)
% soll=solve([eqq(1,1)==0,eqq(2,1)==0,eqq(3,1)==0],[d1,d0]);

%%
% figure(1)
% hold on
% plot3(xdes,ydes,zdes,'*r')
% while 1
%     % Newton
%     determinant = det(J(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1)))
%     dcurr = d(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1));
%     Rcurr = R06(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1),q0(6,1));
%     pitchcurr = atan2(sqrt(1-Rcurr(3,3)^2),Rcurr(3,3)); %Bisogna mettere gomita
%     rollcurr=atan2(Rcurr(3,2)/sqrt(1-Rcurr(3,3)^2),Rcurr(3,1)/(-sqrt(1-Rcurr(3,3)^2)));
%     yawcurr = atan2(Rcurr(2,3)/sqrt(1-Rcurr(3,3)^2),Rcurr(1,3)/sqrt(1-Rcurr(3,3)^2));
%     %if abs(determinant)>eps && ~isnan(determinant)
%     disp('Newton');
%     %         qdot = -JJt(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1))\...
%     %             Jt(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1))*...
%     %         (errf(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1),q0(6,1)));
%     qdot = -J(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1))\([dcurr;rollcurr;pitchcurr;yawcurr]-P);
%     q1 = q0+1e-2*qdot;
%
%     %Gradient
%     % else
%     %       disp('Gradiente');
%     %         qdot = -Jt(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1),q0(6,1))*...
%     %        (errf(q0(1,1),q0(2,1),q0(3,1),q0(4,1),q0(5,1),q0(6,1)));
%     %    q1 = q0+5e-5*qdot;
%     % %
%     %  end
%     q0=q1
%     %% Proof
%     Pi=double(directKinematics(q1(1,1),q1(2,1),q1(3,1),q1(4,1),q1(5,1)));
%     plot3(Pi(1,1),Pi(2,1),Pi(3,1),'-ob');
%     hold on
%     grid on
%     drawnow
%     pause(0.5);
%     waitfor(r);
%
% end


function J = Jac(d,L)
R0 = eye(3);
R1 = DH(d(1,:));
R2 = DH(d(1:2,:));
R3 = DH(d(1:3,:));
R4 = DH(d(1:4,:));
R5 = DH(d(1:5,:));
R6= DH(d(1:6,:));
Pe = R6(1:3,4);
ez=[0;0;1];
%     R0(1:3,1:3)*ez,
I1 =R1(1:3,1:3)*ez;
I2=R2(1:3,1:3)*ez;
I3=R3(1:3,1:3)*ez;
I4=R4(1:3,1:3)*ez;
I5=R5(1:3,1:3)*ez;
I6=R6(1:3,1:3)*ez;
J_R = [I1,I2,I3,I4,I5,I6];

%d6=R6(1:3,1:3)*zeros(3,1);
ex=[1;0;0];
ey=[0;1;0];
d6=Pe;
d5=Pe-R5(1:3,4);
d4=Pe-R4(1:3,4);
d3=Pe-R3(1:3,4);
d2=Pe-R2(1:3,4);
d1=Pe-R1(1:3,4);

J_P = [cross(I1,d1),cross(I2,d2),cross(I3,d3),cross(I4,d4),cross(I5,d5),cross(I6,d6)];

J=[J_P;J_R];
end