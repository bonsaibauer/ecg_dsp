function pulse = feierabend_philipp_heartrate_modified(signal, t)
    
    disp('Step 5.1');
    disp('-------------------------------------------------------------');   
    disp('Health Bot: I feel the heartbeat... one moment, let me see the frequencies...');
  
    % Calculate sampling frequency
    fs = 1 / (t(2) - t(1));  
    if fs <= 0
        disp('Health Bot: Invalid sampling frequency detected.');
        pulse = NaN;
        return;
    end

    % Compute FFT
    N = length(signal);  
    Y = abs(fft(signal));  
    Y = Y(1:N/2);  
    f = (0:N/2-1) * (fs / N);  
    heart_rate_freq = f(find(Y .* (f >= 0.5 & f <= 3) == max(Y .* (f >= 0.5 & f <= 3))));  
    pulse = heart_rate_freq * 60;  % BPM

    if pulse < 40 || pulse > 220
        disp('Health Bot: Implausible heart rate detected.');
        pulse = NaN;
        return;
    end
    disp(['Health Bot: Your Heart Rate is: ', num2str(pulse), ' BPM']);

    % Find and mark the R-peaks (peaks)
    [peaks, locs] = findpeaks(signal);  
    if isempty(locs)
        disp('Health Bot: No peaks detected in the signal.');
        pulse = NaN;
        return;
    end

    % Plot signal and mark R-peaks
    figure;
    plot(t, signal);
    hold on;
    plot(t(locs), peaks, 'ro');  % Mark R-peaks
    title('ECG Signal with All-detected Peaks');
    xlabel('Time (s)');
    ylabel('Amplitude');
    xlim([min(t) t(end)]);
end