clear all
warning('off');

% PD Controller
P = 15;
D = 0.1;
I = 0.1;
FF = 0;

% Motor
Jm = 0.0064;
dm = 0.0068;
saturation = 2.26; % A
u_sat = saturation;

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
C = P + D*s;

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

for i = 1:length(freq) 
    [mag,~] = bode(u_sat/CS, 2*pi*freq(i));
    limit(i) = mag;
end

sweep_expected = limit .* sin(2*pi*t.*freq);

epsilon = 0.2;
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

% Plot the expected sweep vs original sweep
figure;
subplot(211);
plot(t,sweep);
xlabel('time');
ylabel('amplitude position rad');
title('original signal');
if (saturation_reached_at > 0)
    xline(t(saturation_reached_at),'-',{'Saturation','Limit'});
end
subplot(212);
plot(t,sweep_expected);
title('expected limited aware signal');
xlabel('time');
ylabel('amplitude position rad');
if (saturation_reached_at > 0)
    xline(t(saturation_reached_at),'-',{'Saturation','Limit'});
end

modified_sweep = sweep;
if (saturation_reached_at > 0)
    modified_sweep(saturation_reached_at:end) = sweep_expected(saturation_reached_at:end);
end

% Plot the modified sweep to take into account saturation
figure;
plot(t,modified_sweep);
title('modified sweep to take into account saturation');
xlabel('time');
ylabel('amplitude position rad');

%% Basic Force Control
h = 100;                                       % Stiff environment
G = 1 / ((Jm/h)*s^2 + (dm/h)*s + 1);           % Motor
C = P + D*s + I/s;                             % PID control

L = C * G;
CS = C / (1 + L);
T = L / (1 + L);

options = bodeoptions;
options.FreqUnits = 'Hz';
figure;
bode(CS, T, options);
title('Force control noise sensitivity and complementary sensitivity functions');
legend('Noise Sensitivity', 'Complementary Sensitivity');

% Calculate the sweep function 
t = linspace(start_T, end_T, duration/dt);
sweep = amplitude * sin(2*pi*t.*(start_freq + ((end_freq-start_freq)/(duration))*t ));
freq = (start_freq + ((end_freq-start_freq)/(duration))*t);

for i = 1:length(freq) 
    [mag,~] = bode(u_sat/CS, 2*pi*freq(i));
    limit(i) = mag;
end

sweep_expected = limit .* sin(2*pi*t.*freq);

epsilon = 0.2;
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

% Plot the expected sweep vs original sweep
figure;
subplot(211);
plot(t,sweep);
xlabel('time');
ylabel('amplitude force');
title('original signal');
if (saturation_reached_at > 0)
    xline(t(saturation_reached_at),'-',{'Saturation','Limit'});
end
subplot(212);
plot(t,sweep_expected);
title('expected limited aware signal');
xlabel('time');
ylabel('amplitude force');
if (saturation_reached_at > 0)
    xline(t(saturation_reached_at),'-',{'Saturation','Limit'});
end

modified_sweep = sweep;
if (saturation_reached_at > 0)
    modified_sweep(saturation_reached_at:end) = sweep_expected(saturation_reached_at:end);
end

% Plot the modified sweep to take into account saturation
figure;
plot(t,modified_sweep);
title('modified sweep to take into account saturation');
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
title('Force control SEA with link noise sensitivity and complementary sensitivity functions');
legend('Noise Sensitivity', 'Complementary Sensitivity');

% Calculate the sweep function 
t = linspace(start_T, end_T, duration/dt);
sweep = amplitude * sin(2*pi*t.*(start_freq + ((end_freq-start_freq)/(duration))*t ));
freq = (start_freq + ((end_freq-start_freq)/(duration))*t);

for i = 1:length(freq) 
    [mag,~] = bode(u_sat/CS, 2*pi*freq(i));
    limit(i) = mag;
end

sweep_expected = limit .* sin(2*pi*t.*freq);

epsilon = 0.2;
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

% Plot the expected sweep vs original sweep
figure;
subplot(211);
plot(t,sweep);
xlabel('time');
ylabel('amplitude force');
title('original signal');
if (saturation_reached_at > 0)
    xline(t(saturation_reached_at),'-',{'Saturation','Limit'});
end
subplot(212);
plot(t,sweep_expected);
title('expected limited aware signal');
xlabel('time');
ylabel('amplitude force');
if (saturation_reached_at > 0)
    xline(t(saturation_reached_at),'-',{'Saturation','Limit'});
end

modified_sweep = sweep;
if (saturation_reached_at > 0)
    modified_sweep(saturation_reached_at:end) = sweep_expected(saturation_reached_at:end);
end

% Plot the modified sweep to take into account saturation
figure;
plot(t,modified_sweep);
title('modified sweep to take into account saturation');
xlabel('time');
ylabel('amplitude position rad');
