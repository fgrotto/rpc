clear all
% PD Controller
P = 15;
D = 0.1;
I = 0.1;
FF = 0;

% Motor
Jm = 0.0064;
dm = 0.0068;
saturation = 2.26; % A
kt = 1.46; % mNm/inv(A)
u_sat = saturation;

% Series Spring
Ks = 12.04;

% Link
Jl = 0.02; % inertia
Bl = 0.1; % friction
Kl = 100; % stiffness

% Environment
qe = 0;
Ke = 1e-2;
Je = 1e-1;
Be = 2 * sqrt(Ke * Je);

start_T = 0;
end_T = 10;
duration = end_T - start_T;
dt = 0.01;
start_freq = 1;
end_freq = 10;
amplitude = 4;

%% Saturation experiments with PD + Simple DC Motor model (Position Control)
s = tf('s');
M = 1 / (Jm * s^2 + dm * s);
C = P + D*s;
L = C * M;
CS = C / (1 + L);
T = L / (1 + L);

[sweep, suggested_sweep, t] = reference_signal(start_T, end_T, start_freq, end_freq, duration, amplitude, u_sat, CS, dt);
show_plots(CS, T, t, sweep, suggested_sweep, 'Position Control');

var.time=[t'];
var.signals.values=[suggested_sweep'];
var.signals.dimensions=[1];

%% Basic Force Control
h = 100;                                       % Stiff environment
G = 1 / ((Jm/h)*s^2 + (dm/h)*s + 1);           % Motor
C = P + D*s + I/s;                             % PID control

L = C * G;
CS = C / (1 + L);
T = L / (1 + L);

[sweep, suggested_sweep, t] = reference_signal(start_T, end_T, start_freq, end_freq, duration, amplitude, u_sat, CS, dt);
show_plots(CS, T, t, sweep, suggested_sweep, 'Force Control Basic');

var.time=[t'];
var.signals.values=[suggested_sweep'];
var.signals.dimensions=[1];

%% Saturation experiments (SEA with link) (Force Control)

s = tf('s');
r = Ks / Ke;
E = (Je / Ke) * s^2 + (Be / Ke) * s + 1;
F = E / ((E + r) * (Jm / Ks) * s^2 + E);
C = P + D * s;

L = C * F;

CS = C / (1 + L);
T = L / (1 + L);

[sweep, suggested_sweep, t] = reference_signal(start_T, end_T, start_freq, end_freq, duration, amplitude, u_sat, CS, dt);
show_plots(CS, T, t, sweep, suggested_sweep, 'Force Control SEA with link');

var.time=[t'];
var.signals.values=[suggested_sweep'];
var.signals.dimensions=[1];
