function ret=proporzionale(K,q1,q2,q3,q1v,q2v,q3v)
%PROPORZIONALE Summary of this function goes here
%   Detailed explanation goes here
q1vNew = q1v + K * (q1 - q1v);
q2vNew = q2v + K * (q2 - q2v);
q3vNew = q3v + K * (q3 - q3v);
ret=[q1vNew,q2vNew,q3vNew];
end

