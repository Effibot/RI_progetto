classdef UDPMatlab <handle
    properties
        IP_Addr
        Port_TX
        data
        UDP
        Port_RX
        
    end
    methods
        function obj = clearBuffer(obj)
            obj=flush(obj.UDP,"output");
            return
        end
        function obj=InitializeParam(obj,addr,port1,port2)
            obj.IP_Addr = addr;
            obj.Port_TX = port1;
            obj.Port_RX = port2;
            
            return
        end
        function obj= InitializeConnection(obj)
            obj.UDP=udpport("datagram","LocalHost",obj.IP_Addr,"LocalPort",obj.Port_TX,"EnablePortSharing",true,"OutputDatagramSize",64);
            configureCallback(obj.UDP,"datagram",1,@readUDPData);
            return
        end
        function [IP,Port_TX] = getParameters(obj)
            IP=obj.IP_Addr;
            Port_TX=obj.Port_TX;
            return
        end
        
        function obj= writeData(obj,data)
            write(obj.UDP,data+"\n","uint8",obj.IP_Addr,obj.Port_TX);
        end
    end
end
