%%

clear all
close all
clc
%%
IPaddr="127.0.0.1";
Port_TX=12346;
Port_RX=12345;
UDPm = UDPMatlab;
%%
UDPm=UDPm.InitializeParam(IPaddr,Port_TX,Port_RX);
UDPm= UDPm.InitializeConnection();

