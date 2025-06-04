function pulse = feierabend_philipp_heartrate_modified(signal, t)
    % Default output for pulse in case of errors
    pulse = NaN;
    
    disp('Step 5.1');
    disp('-------------------------------------------------------------');   
    disp('Health Bot: I feel the heartbeat... one moment, let me see the frequencies...');
  
    % Calculate sampling frequency
    fs = 1 / (t(2) - t(1));  
    if fs <= 0
        disp('Health Bot: Invalid sampling frequency detected.');
        return;  % Return here if invalid frequency
    end

    % Compute FFT (Frequency Domain Analysis)
    N = length(signal);  
    Y = abs(fft(signal));  
    Y = Y(1:N/2);  % Get the first half of the FFT output (positive frequencies)
    f = (0:N/2-1) * (fs / N);  % Frequency axis
    heart_rate_freq = f(find(Y .* (f >= 0.5 & f <= 3) == max(Y .* (f >= 0.5 & f <= 3))));  
    pulse_fft = heart_rate_freq * 60;  % Heart rate from FFT in BPM
    
    % Display the pulse from FFT
    disp(['Health Bot: Your Heart Rate from FFT is: ', num2str(pulse_fft), ' BPM']);
    
    % Check if pulse is valid
    if pulse_fft < 40 || pulse_fft > 220
        disp('Health Bot: Implausible heart rate detected from FFT.');
        return;  % Return here if implausible heart rate
    end
    
    % MODWT with sym4 wavelet (to isolate the R-peaks)
    wt = modwt(signal, 5, 'sym4');  % Maximal Overlap Discrete Wavelet Transform (MODWT)
    wtrec = zeros(size(wt));  % Initialize reconstructed signal
    wtrec(4:5, :) = wt(4:5, :);  % Use scales 4 and 5
    y = imodwt(wtrec, 'sym4');  % Reconstruct the signal using these scales
    
    % Square the absolute value to emphasize R-peaks
    y = abs(y).^2;

    % Dynamically calculate MinPeakHeight
    peak_threshold = mean(y) + 2 * std(y);
    
    % Find R-peaks based on the wavelet reconstruction
    [qrspeaks, locs] = findpeaks(y, t, 'MinPeakHeight', peak_threshold, 'MinPeakDistance', 0.150);
    
    % Check for R-peaks
    if isempty(locs)
        disp('Health Bot: No R-peaks detected.');
        return;  % Return here if no R-peaks detected
    end
    
    % Calculate RR-intervals in seconds
    rr_intervals = diff(locs) / fs;  % RR-Intervalle in Sekunden
    mean_rr = mean(rr_intervals);  % Calculate mean RR-interval
    pulse_rr = 60 / mean_rr;  % Heart rate from RR-intervals
    
    % Display results
    disp(['Pulse from RR intervals: ', num2str(pulse_rr), ' BPM']);
    
    % Save these features in the workspace
    assignin('base', 'pulse_fft', pulse_fft);  % Pulse from FFT
    assignin('base', 'pulse_rr', pulse_rr);  % Pulse from RR intervals

    % Plot results
    figure;
    subplot(3,1,1);
    plot(t, signal);
    title('Original ECG Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    subplot(3,1,2);
    plot(f, Y);
    title('FFT Magnitude Spectrum');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    grid on;

    subplot(3,1,3);
    plot(t, y);
    hold on;
    plot(locs, qrspeaks, 'ro');  % Mark R-peaks
    title('R-Peaks Detected by Wavelet');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    % Combine both methods for a final result
    pulse = (pulse_fft + pulse_rr) / 2;  % Average pulse from both methods
    disp(['Health Bot: Final average heart rate: ', num2str(pulse), ' BPM']);
end
