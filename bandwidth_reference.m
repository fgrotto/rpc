clear all

% PD Controller
P = 15;
D = 0.1;
I = 0.1;
FF = 0;

% Motor
Jm = 0.0064;
dm = 0.0068;

% Series Spring
Ks = 12.04;

% Link
Jl = 0.02; % inertia
Bl = 0.1; % friction
Kl = 100; % stiffness

% Environment
qe = 0; %always in contact
Ke = 1e-2;
Je = 1e-1;
Be = 2 * sqrt(Ke * Je);

sweep_amplitude = 1;
sweep_duration = 10;
sweep_max_freq = 10;
start_T = 0;
end_T = 10;
duration = end_T - start_T;
dt = 0.01;
start_freq = 1;
end_freq = 10;
amplitude = 1;

%% Saturation experiments with PD + Simple DC Motor model (Position Control)
s = tf('s');
M = 1 / (Jm * s^2 + dm * s);
C = P + I / s;

L = C * M;

CS = C / (1 + L);
T = L / (1 + L);

options = bodeoptions;
options.FreqUnits = 'Hz';
figure;
bode(CS, T, options);
title('Position control noise sensitivity and complementary sensitivity functions');
legend('Noise Sensitivity', 'Complementary Sensitivity');

% Calculate the sweep function 
t = linspace(start_T, end_T, duration/dt);
sweep = amplitude * sin(2*pi*t.*(start_freq + ((end_freq-start_freq)/(duration))*t ));
freq = (start_freq + ((end_freq-start_freq)/(duration))*t);

% Calculate the scaling factor for the modified sweep
n = -1;
for i=1:length(freq)
   factor(i) = real(freqresp(CS,2*pi*freq(i)));
   if factor(i) <= 1
    factor(i) = 1;
   else
    if n == -1
        fprintf("scaling frequency = %sHz\n", freq(i));
        n = i; % step at which I need to scale my reference signal
    end
    factor(i) = amplitude-((amplitude-amplitude/4)/(length(freq)-n))*(i-n);
   end
end
modified_sweep = sweep.*factor;

% Plot the modified sweep vs original sweep
figure;
subplot(211);
plot(t,sweep);
xlabel('time');
ylabel('amplitude position rad');
title('original signal');
subplot(212);
plot(t,modified_sweep);
title('scaled signal');
xlabel('time');
ylabel('amplitude position rad');

%% Saturation experiments (SEA with link) (Force Control)

s = tf('s');
r = Ks / Ke;
E = (Je / Ke) * s^2 + (Be / Ke) * s + 1;
F = E / ((E + r) * (Jm / Ks) * s^2 + E);
C = P + D * s;

L = C * F;

CS = C / (1 + L);
T = L / (1 + L);

options = bodeoptions;
options.FreqUnits = 'Hz';
figure;
bode(CS, T, options);
title('SEA with link force control noise sensitivity and complementary sensitivity functions');
legend('Noise Sensitivity', 'Complementary Sensitivity');
