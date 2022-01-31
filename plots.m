figure;
subplot(221);
plot(theta_des.time,theta_des.Data);
hold on;
plot(theta_m.time,theta_m.Data);
xlabel('time');
ylabel('tau');
legend('tau\_des', 'tau\_e');
title('Suggested signal');

hold off;

subplot(223);
plot(current.time, current.Data);
title('Motor current');
yline(2.35,'-', "saturation");
yline(-2.35,'-');
xlabel('time');
ylabel('current');

subplot(222);
plot(theta_des1.time,theta_des1.Data);
hold on;
plot(theta_m1.time,theta_m1.Data);
xlabel('time');
ylabel('tau');
legend('tau\_des', 'tau\_e');
title('Original signal');
hold off;

subplot(224);
plot(current1.time, current1.Data);
title('Motor current');
yline(2.35,'-', "saturation");
yline(-2.35,'-');
xlabel('time');
ylabel('current');