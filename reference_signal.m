function [sweep, suggested_sweep, t] = reference_signal(start_T, end_T, start_freq, end_freq, duration, amplitude, u_sat, CS, dt)
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
    
    suggested_sweep = sweep;
    if (saturation_reached_at > 0)
        suggested_sweep(saturation_reached_at:end) = sweep_expected(saturation_reached_at:end);
    end
end