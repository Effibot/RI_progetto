t=tcpclient("192.168.0.104",12345);
k=0;
while t.NumBytesAvailable==0
data = read(t,1,"uint8");
disp(data);
k=k+1;
write(t,k,"uint8");
end
t.close();
