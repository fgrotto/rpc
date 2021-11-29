% Force Control
% Crical frequency below 30-50 Hz since force sensors are noisy 
% Above 100Hz we can find poles due to structural flexibility of 
% robot that may led to instability.

clear all;
close all;

set(cstprefs.tbxprefs,'FrequencyUnits','Hz')
s = tf([1 0],1);

J = 0.1;  
d = 0.01;
h_vec = [1 10 100 1000];

%% Use sistool to design your controller
h = h_vec(4);
G = 1 / ((J/h)*s^2 + (d/h)*s + 1);
% sisotool(G);

%% PID step responses
%      kf (s+0.2)^2
%   -------------------
%       s (s+3e04)
% 
% For h = 1     Kf = 1.4025e06
% For h = 10    Kf = 1.3222e05
% For h = 100   Kf = 13618
% For h = 1000  Kf = 1337.8

% For h = 1
%   5.2806e07 (s+0.9103)^2
%   ----------------------
%       s (s+1.039e06)

% For h = 10
%   1.8355e06 (s+7.937) (s+8.32)
%   ----------------------------
%          s (s+4.624e05)

% For h = 100
%   1.7574e08 (s+0.363)
%   -------------------
%       (s+3.57e08)

% For h = 1000
%   31459 (s+87.82) (s+91.1)
%   ------------------------
%        s (s+5.343e05)
 
C = (5.2806e07*(s+0.9103)^2)/(s*(s+1.039e06));   
for i=1:length(h_vec)
    G = 1 / ((J/h_vec(i))*s^2 + (d/h_vec(i))*s + 1);
    sys = (C*G)/(1+C*G);
    figure;
    step(sys);
    title(strcat('PID h=', string(h_vec(i)),'Kgm^2'));
end

%% PD + FF step responses
%      kf(s+0.2)
%   --------------
%      (s+3e04)
% 
% For h = 1     Kf = 1.3907e06
% For h = 10    Kf = 1.5e05
% For h = 100   Kf = 15010
% For h = 1000  Kf = 1489.2
     
% For h = 1
% 3.507e06 (s+0.2093)
%   -------------------
%      (s+7.489e04)

% For h = 10
% 2.2762e07 (s+0.2753)
%   --------------------
%       (s+4.74e06)

% For h = 100
% 1.7574e08 (s+0.363)
%   -------------------
%      (s+3.57e08)

% For h = 1000
% 8.6133e05 (s+0.7771)
%   --------------------
%       (s+5.398e06)

C = 3.507e06*(s+0.2093)/(s+7.489e04);
for i=1:length(h_vec)
    G = 1 / ((J/h_vec(i))*s^2 + (d/h_vec(i))*s + 1);
    sys = (G*(1+C))/(1+C*G);
    figure;
    step(sys);
    title(strcat('PD+FF h=', string(h_vec(i)),'Kgm^2'));
end

