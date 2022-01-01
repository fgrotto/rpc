figure;
subplot(221);
plot(theta_des.time,theta_des.signals.values);
hold on;
plot(theta_m.time,theta_m.signals.values);
xlabel('time');
ylabel('position');
legend('theta\_des', 'theta\_m');
title('Original signal');

hold off;

subplot(223);
plot(current.time, current.signals.values);
title('Motor current');
yline(2.26,'-', "saturation");
yline(-2.26,'-');
xlabel('time');
ylabel('current');

subplot(222);
plot(theta_des1.time,theta_des1.signals.values);
hold on;
plot(theta_m1.time,theta_m1.signals.values);
xlabel('time');
ylabel('position');
legend('theta\_des', 'theta\_m');
title('Suggested signal');
hold off;

subplot(224);
plot(current1.time, current1.signals.values);
title('Motor current');
yline(2.26,'-', "saturation");
yline(-2.26,'-');
xlabel('time');
ylabel('current');