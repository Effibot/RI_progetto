P = tf(1, [1 -1]);
W1 = tf(1,[1 1]);
W2 = tf(2,[1 10]);
C = tf(1,1);

L = P*C;
S = minreal(1/(1+L));
T = minreal(L/(1+L));


%% Condizione su k per stabilità su impianto nominale
figure(1);
rlocus(L);
title("L root locus");
grid on;
% deve essere k > 1 per avere stabilità nominale


%% Condizione su k per stabilità robusta
% la condizione di stabilità robusta è ||W2*T|| < 1/2    (||Delta||<=2)
% deve essere k > 5/3 per avere stabilità robusta
omega = logspace(-2, 2, 4*1000+1);

kk = 5/3;
W2T = @(s,k) (2.*k)./((s+10).*(s-1+k)); 
W1S = @(s,k) (s-1)./((s+1).*(s-1+k));

W2T0 = @(k) k./(5.*(k-1));
W1S0 = @(k) k./(k-1);
amin = @(k) 5./(3.*k-5);

%%
figure(2);
jomega = 1i.*omega;

k = 3;
subplot(5,2,1);
w2t = abs(W2T(jomega,k));
w1s = abs(W1S(jomega,k));
semilogx(omega, w2t, omega, w1s);
grid on;
legend("W2T","W1S");
title("k = " + string(k));
subplot(5,2,2);
nyquist(k*P);
grid on;

k = 2;
subplot(5,2,3);
w2t = abs(W2T(jomega,k));
w1s = abs(W1S(jomega,k));
semilogx(omega, w2t, omega, w1s);
grid on;
legend("W2T","W1S");
title("k = " + string(k));
subplot(5,2,4);
nyquist(k*P);
grid on;

k = kk;
subplot(5,2,5);
w2t = abs(W2T(jomega,k));
w1s = abs(W1S(jomega,k));
semilogx(omega, w2t, omega, w1s);
grid on;
legend("W2T","W1S");
title("k = " + string(k));
subplot(5,2,6);
nyquist(k*P);
grid on;

k = 1.2;
subplot(5,2,7);
w2t = abs(W2T(jomega,k));
w1s = abs(W1S(jomega,k));
semilogx(omega, w2t, omega, w1s);
grid on;
legend("W2T","W1S");
title("k = " + string(k));
subplot(5,2,8);
nyquist(k*P);
grid on;

k = 1;
subplot(5,2,9);
w2t = abs(W2T(jomega,k));
w1s = abs(W1S(jomega,k));
semilogx(omega, w2t, omega, w1s);
grid on;
legend("W2T","W1S");
title("k = " + string(k));
subplot(5,2,10);
nyquist(k*P);
grid on;


%%
K = (ceil(kk*10)/10):0.01:3;
A = amin(K);

figure(3);
hold on;
plot(K, A);
plot([kk, kk], [0, max(A)], '--k');
grid on;
xlabel("k");
ylabel("a");
axis([1.6 max(K) 0 max(A)/2]);
legend("a_{min}");