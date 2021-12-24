figure;
subplot(221);
plot(tau_des.time,tau_des.Data);
hold on;
plot(tau_e.time,tau_e.Data);
xlabel('time');
ylabel('force');
legend('tau\_des', 'tau\_e');
title('Original signal');

hold off;

subplot(223);
plot(current.time, current.Data);
title('Motor current');
yline(2.26,'-', "saturation");
yline(-2.26,'-');
xlabel('time');
ylabel('current');

subplot(222);
plot(tau_des1.time,tau_des1.Data);
hold on;
plot(tau_e1.time,tau_e1.Data);
xlabel('time');
ylabel('force');
legend('tau\_des', 'tau\_e');
title('Suggested signal');
hold off;

subplot(224);
plot(current1.time, current1.Data);
title('Motor current');
yline(2.26,'-', "saturation");
yline(-2.26,'-');
xlabel('time');
ylabel('current');