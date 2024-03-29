clear all;
close all;

% PD Controller
P = 10;
D = 0.9;
FF = 0;

% Motor Parameters
Jm = 0.0104;
dm = 0.0068;
kt = 1.5038;
u_sat = 2.26 * kt;

% Sea spring
k = 30;

% Environment parameters
h = 10;
J = 0;
d = 0.2;

% Signal parameters
start_T = 0;
end_T = 10;
duration = end_T - start_T;
dt = 0.0001;
start_freq = 1;
end_freq = 10;
amplitude = 2;

% Force Control transfer functions
s = tf('s');

M = 1/(Jm*s^2+dm*s);
E = 1/(J*s^2+d*s+h);

F = k*M / (1+k*E+k*M);
C = P + D * s;

L = C * F;
CS = C / (1 + L);
T = L / (1 + L);

% Calculate time and frequencies vectors (they must have the same length)
t = start_T:dt:end_T;
freq = start_freq + ((end_freq-start_freq)/duration * t);

% Build original swept function
sweep = amplitude * chirp(t, start_freq, end_T, end_freq, 'linear', -90);

% Compute the magnitude vector /m
[magnitude_vector,~] = bode((CS*amplitude)/(u_sat), 2*pi*freq);

% Calculate deamplification factor only when the magnitude is larger than
% 0db (1 in linear scale).
deamplification = zeros(1,size(magnitude_vector, 3));
for i = 1:size(magnitude_vector,3)
    if magnitude_vector(:,:,i) >= 1 
        deamplification(i) = amplitude/magnitude_vector(:,:,i);
    else
        deamplification(i) = amplitude;
    end
end

% Build the suggested sweep
suggested_sweep = deamplification .* chirp(t, start_freq, end_T, end_freq, 'linear', -90);

options = bodeoptions;
options.FreqUnits = 'Hz';
figure;
bode(CS, T, options);
legend('Noise Sensitivity', 'Complementary Sensitivity');

figure;
subplot(211);
plot(t,sweep);
xlabel('time');
ylabel('amplitude');
title('Original signal');

subplot(212);
plot(t,suggested_sweep);
title('Suggested sweep to take into account saturation');
xlabel('time');
ylabel('amplitude');

% Prepare the suggested sweep for the simulink model
var.time=[t'];
var.signals.values=[suggested_sweep'];
var.signals.dimensions=[1];