function toSend = proporzionale(K,q1,q2,q3,q1v,q2v,q3v)
                q1v = q1v + K * (q1 - q1v);
                q2v = q2v + K * (q2 - q2v);
                q3v = q3v + K * (q3 - q3v);
                toSend=[q1v,q2v,q3v];
                return;
end
