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
saturation = 1.0;
kt = 1.5038;
kv = kt;
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
amplitude = 1;

s = tf('s');
M = 1 / (Jm * s^2 + dm * s);
C = P + D*s;
L = C * M;
CS = (kt/Ra) * C / (1 + L);
T = L / (1 + L);

t = linspace(start_T, end_T, duration/dt);
sweep = amplitude * sin(2*pi*t.*(start_freq + ((end_freq-start_freq)/(duration))*t));
freq = (start_freq + ((end_freq-start_freq)/(duration))*t);

for i = 1:length(freq) 
    [mag,~] = bode(u_sat/CS, 2*pi*freq(i));
    limit(i) = mag;
end

sweep_expected = limit .* sin(2*pi*t.*freq);

epsilon = 0.0001;
saturation_reached_at = -1;
for i = 1:length(sweep)
   if (sweep(i) > 0 && sweep(i) > sweep_expected(i) + epsilon)
       saturation_reached_at = i;
       break;
   end
   if (sweep(i) < 0 && sweep(i) < sweep_expected(i) - epsilon)
       saturation_reached_at = i;
       break;
   end
end

suggested_sweep = sweep;
if (saturation_reached_at > 0)
    suggested_sweep(saturation_reached_at:end) = sweep_expected(saturation_reached_at:end);
end

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