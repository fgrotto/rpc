function [sweep, suggested_sweep, t_sweep] = reference_signal(start_T, end_T, start_freq, end_freq, duration, amplitude, u_sat, CS, dt)    
    t_sweep = start_T:dt:end_T;
	m = end_freq / duration; % m = final_value/final_time
	freq = (m)*t_sweep;
    sweep = amplitude * sin(2*pi*t_sweep.*freq);

    for i = 1:length(freq) 
        [mag,~] = bode(u_sat/CS, 2*pi*freq(i));
        limit(i) = mag;
    end
    
    sweep_expected = limit .* sin(2*pi*t_sweep.*freq);
    
    epsilon = 0.001;
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