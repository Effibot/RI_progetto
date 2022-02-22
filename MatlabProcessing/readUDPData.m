function readUDPData(src,~)
IPaddr="127.0.0.1";
Port_TX=12345;
src.UserData = src.UserData + 1;
disp("Callback Call Count: " + num2str(src.UserData));
data = read(src,src.NumDatagramsAvailable,"string");
disp(data);
%Ricezione dei dati ora è possibile manipolarli
%Invio dei dati appena calcolati
write(src,data.Data+"\n","uint8",IPaddr,Port_TX);

end
