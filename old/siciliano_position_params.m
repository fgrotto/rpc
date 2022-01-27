clear all;
close all;

% PD Controller
P = 10;
D = 0.9;
I = 0;
FF = 0;

% Motor
Jm = 0.0104;
dm = 0.0068;
u_sat = 2;
Kt = 1.5038;
Ra = 0.68;
Kv = Kt;
gear = 103;