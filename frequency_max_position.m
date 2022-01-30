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
kt = 1.5038;
kv = kt;
saturation = 10 * kt;
gear = 103;
u_sat = saturation;
v_sat = 18;
Ra = 0.68;

start_T = 0;
end_T = 10;
duration = end_T - start_T;
dt = 0.001;
start_freq = 1;
end_freq = 6;
amplitude = 5;

s = tf('s');
M = 1 / (Jm * s^2 + dm * s);
C = P + D*s;
L = C * M;
CS = C / (1 + L);
T = L / (1 + L);

t = start_T:dt:end_T;
phaseInit = -90;
method = 'linear';
sweep = amplitude * chirp(t, start_freq, end_T, end_freq, method, phaseInit);

freq = start_freq:0.1:end_freq;

stop = length(freq);
for i = 1:length(freq) 
    [mag,~] = bode((CS*amplitude)/(u_sat), 2*pi*freq(i));
    if (mag >= 1)
       stop = i;
       break
    end
end

%start_freq = freq(stop);
end_freq = freq(stop);

t = start_T:dt:end_T;
phaseInit = -90;
method = 'linear';
suggested_sweep = amplitude * chirp(t, start_freq, end_T, end_freq, method, phaseInit);

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
title('original signal');

subplot(212);
plot(t,suggested_sweep);
title('suggested sweep to take into account saturation');
xlabel('time');
ylabel('amplitude');

var.time=[t'];
var.signals.values=[suggested_sweep'];
var.signals.dimensions=[1];