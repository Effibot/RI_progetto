%Matrice di avvitamento
function M = Av(v,theta,d)
  S=skM(v);
  ex = expLap(S,theta);
  row=zeros(1,4);
  row(1,4)=1;
  dv=d*v;
  T=[ex,dv];
  T=[T;row];
  M=simplify(T);
end