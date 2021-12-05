function show_plots(CS, T, t, sweep, suggested_sweep, plot_title)
    options = bodeoptions;
    options.FreqUnits = 'Hz';
    figure;
    bode(CS, T, options);
    title(plot_title);
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
end