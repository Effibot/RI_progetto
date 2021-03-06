function readUDPData(src,~)
IPaddr="127.0.0.1";
Port_TX=12345;
data = read(src,src.NumDatagramsAvailable,"string");
if size(data,2)>=1
    values =str2num(data(end).Data);
    data=udpport.datagram.Datagram.empty(0,1);
    %Ricezione dei dati ora è possibile manipolarli
    switch(values(1))
        %Formato datagramma: [Proc,const,q1,q2...]
        case 1 %Specific format:[Proc,K,q1,q2,q3,q1v,q2v,q3v]
            K=values(2);
            q1=values(3);
            q2=values(4);
            q3=values(5);
            q1v=values(6);
            q2v=values(7);
            q3v=values(8);
            while(abs(q1v-q1)>0.001 && abs(q2v-q2)>0.001 && abs(q3v-q3)>0.001)
                
%                 q1v = q1v + K * (q1 - q1v);
%                 q2v = q2v + K * (q2 - q2v);
%                 q3v = q3v + K * (q3 - q3v);
%                 toSend=[q1v,q2v,q3v];

                   toSend=proporzionale(K,q1,q2,q3,q1v,q2v,q3v);
               %Invio dei dati appena calcolati prima verifico se è
                %cambiato
                
                    q1v=toSend(1);
                    q2v=toSend(2);
                    q3v=toSend(3); 
                data=read(src,src.NumDatagramsAvailable,"string");
                if isempty(data)
                    write(src,"["+strjoin(""+strjoin(compose("%d",toSend),", ") ,", ")+"]","string",IPaddr,Port_TX);
                else
                    values =str2num(data(end).Data);
                    K=values(2);
                    q1=values(3);
                    q2=values(4);
                    q3=values(5);
                    q1v=values(6);
                    q2v=values(7);
                    q3v=values(8);
                end
            end
            %Visione
        case 2 %Specific format:[Proc,x,y,obstacleTarget]
            x=values(2);
            y=values(3);
            %TOADD:Z
            obsTarg=values(4);
            %pointToReach [z,y,z] a cui applicare la cinematica inversa
            pointToReach=visione(x,y,obsTarg);
            write(src,"["+strjoin(""+strjoin(compose("%d",double(pointToReach)),", ") ,", ")+"]","string",IPaddr,Port_TX);
        % Pianificazione moto
        case 3 %Specific format:[Proc,sizemapX,sizemapY,sizeRobot,obsx1,obsy1,sizeObs1,...,obsx3,obsy3,sizeObs3]
            mapsize=[values(2),values(3)];
            sizeRobot=values(4);
            obs=double.empty(0,3);
            numObs = size(values,2)-5;
            for i=5:3:size(values,2)-2
                obs(end+1,:)=[values(i),values(i+1),values(i+2)];
            end
            path=fPathPlanning(mapsize,sizeRobot,obs);
            %Controllo
        otherwise
            disp("Not mapped case")
    end
end

end


