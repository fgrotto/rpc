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

%% Saturation experiments with PD + Simple DC Motor model (Position Control)
s = tf('s');
M = 1 / (Jm * s^2 + dm * s);
C = P + I / s;

L = C * M;

S = C / (1 + L);
T = L / (1 + L);

options = bodeoptions;
options.FreqUnits = 'Hz';
figure(1)
bode(S, T, options);
title('Position motor bode plot of control sensitivity and complementary sensitivity functions');
legend('Control Sensitivity', 'Complementary Sensitivity');

%% Saturation experiments (SEA with link) (Force Control)

s = tf('s');
r = Ks / Ke;
E = (Je / Ke) * s^2 + (Be / Ke) * s + 1;
F = E / ((E + r) * (Jm / Ks) * s^2 + E);
C = P + D * s;

L = C * F;

S = C / (1 + L);
T = L / (1 + L);

options = bodeoptions;
options.FreqUnits = 'Hz';
figure(2)
bode(S, T, options);
title('SEA with link force bode plot of control sensitivity and complementary sensitivity functions');
legend('Control Sensitivity', 'Complementary Sensitivity');
