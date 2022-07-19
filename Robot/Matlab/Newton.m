clc
clear
close all
%%
syms q_1(t) q_2(t) q_3(t) q_4(t) q_5(t) q_6(t) ...
    L_1 L_2 L_3 L_4 L_5 L_6 ...
    mu x y z alpha gamma beta...
    d_1 d_2
%%
dof=3;
col=4;
%%
dhparams=sym('b',[dof,col]);
dhparams(1,1:end)=[q1,L1,-pi/2,0];
dhparams(2,1:end)=[q2-pi/2,0,0,L2];
dhparams(3,1:end)= [q3,0,-pi/2,0];
dhparams(4,1:end)= [q4,L4,pi/2,0];
dhparams(5,1:end)= [q5,0,-pi/2,0];
dhparams(6,1:end)=[q6,L6,0,0];

dr=simplify(DH(dhparams));
d=dr(1:3,4);
R = reshape(dr(1:3,1:3),9,1);
hq=[d;R];
%% Jacobian
J=simplify(expand(jacobian(hq,[q1(t) q2(t) q3(t) q4(t) q5(t) q6(t)])));

Jpseudo=J'*J;
qdot=-mu*Jpseudo^(-1)*J'*(-P);




%%
dhparams=sym('b',[dof,col]);
dhparams(1,1:end)=[q1,L1,0,d1];
dhparams(2,1:end)=[q2,0,0,d2];
dhparams(3,1:end)=[0,q3,0,0];
dr=simplify(DH(dhparams));