clear all;
close all;

% PD Controller
P = 2;
D = 0;
I = 1;
FF = 0;

% Motor
Jm = 0.0104;
dm = 0.0068;
saturation = 2;
kt = 1.5038;
kv = kt;
gear = 103;
u_sat = saturation;
v_sat = 18; %V
Ra = 0.68;

% Environment
qe = 0;
Ke = 20;
Be = 2 * sqrt(Ke * 0.0001);

start_T = 0;
end_T = 10;
duration = end_T - start_T;
dt = 0.01;
start_freq = 1;
end_freq = 10;
amplitude = 1;

%% Saturation siciliano
s = tf('s');
C = P + D*s;
CS = (kt)*((kt/Ra)*C) / (1+C*1*1/(Jm*s^2*dm*s)+kv*(1/(Jm*s+dm)));
T = 1/s;

[sweep, suggested_sweep, t] = reference_signal(start_T, end_T, start_freq, end_freq, duration, amplitude, u_sat, CS, dt);
show_plots(CS, T, t, sweep, suggested_sweep, 'Position Control');

lsim(CS,sweep,t);
var.time=[t'];
var.signals.values=[suggested_sweep'];
var.signals.dimensions=[1];


%% Saturation experiments with PD + Simple DC Motor model (Position Control)
s = tf('s');
M = 1 / (Jm * s^2 + dm * s);
C = P + D*s;
L = C * M;
CS = (1/kt) * C / (1 + L);
T = L / (1 + L);

[sweep, suggested_sweep, t] = reference_signal(start_T, end_T, start_freq, end_freq, duration, amplitude, u_sat, CS, dt);
show_plots(CS, T, t, sweep, suggested_sweep, 'Position Control');

var.time=[t'];
var.signals.values=[suggested_sweep'];
var.signals.dimensions=[1];

%% Saturation experiments with PI + Simple DC Motor model (Velocity Control)
s = tf('s');
P = 1;
I = 0.2;
M = 1 / (Jm * s + dm);
C = P + I/s;
L = C * M;
CS = C / (1 + L);
T = L / (1 + L);

[sweep, suggested_sweep, t] = reference_signal(start_T, end_T, start_freq, end_freq, duration, amplitude, u_sat, CS, dt);
show_plots(CS, T, t, sweep, suggested_sweep, 'Velocity Control');

var.time=[t'];
var.signals.values=[sweep'];
var.signals.dimensions=[1];

%% Saturation experiments with PD + Simple DC Motor model (Cascaded Position Control)
s = tf('s');
Cv = (0.9*(s+39.08))/s;
r = 1;
Kt = 0.0705*r; 
Im = 0.0003*r^2;
Fm = 0.00001*r^2; 
Kv = 1/(2*pi*135/60)*r;
Ra = 0.343;
La = 0.000264;

fw_path = Kt / ((s*La + Ra) * (s*Im + Fm));
fb_path = Kv;
Gv = feedback(fw_path, fb_path);
Gv = minreal(Gv);
Gp = ((Cv*Gv)/(1+Cv*Gv))*(1/s);
Gp = minreal(Gp);

C = (241.1*(s+986.4))/(s+4281);
L = C * Gp;
CS = C / (1 + L);
T = L / (1 + L);

[sweep, suggested_sweep, t] = reference_signal(start_T, end_T, start_freq, end_freq, duration, amplitude, u_sat, CS, dt);
show_plots(CS, T, t, sweep, suggested_sweep, 'Cascaded Control');

var.time=[t'];
var.signals.values=[suggested_sweep'];
var.signals.dimensions=[1];

%% Simple Force Control with PD+FF
s = tf('s');

P = 1;
D = 0.2;
h = 100;                                     % Stiff environment
G = 1 / ((Jm/h)*s^2 + (dm/h)*s + 1);         % Motor
C = P + D*s;                                 % PD control

T = (G*(C+1)) / (1+G*C);
CS = 1+C-((G*C*(1+C))/(1+C*G));

[sweep, suggested_sweep, t] = reference_signal(start_T, end_T, start_freq, end_freq, duration, amplitude, u_sat, CS, dt);
show_plots(CS, T, t, sweep, suggested_sweep, 'Force Control Basic');

var.time=[t'];
var.signals.values=[sweep'];
var.signals.dimensions=[1];