function [pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(signal, t, plot_heartrate_modified)
    
    disp('Step 5.2');
    disp('-------------------------------------------------------------');   
    disp('Health Bot: Let me help you with machine learning, let me see the frequencies...');

    % Default output for pulse in case of errors
    pulse = NaN;
    RR_intervals = NaN;
    avg_RR = NaN;
    max_RR = NaN;
    min_RR = NaN;
    std_RR = NaN;

    % Calculate sampling frequency
    fs = 1 / (t(2) - t(1));  
    if fs <= 0
        disp('Error: Invalid sampling frequency detected.');
        return;  % Return here if invalid frequency
    end

    % Compute FFT (Frequency Domain Analysis)
    N = length(signal);  
    Y = abs(fft(signal));  
    Y = Y(1:N/2);  % Get the first half of the FFT output (positive frequencies)
    f = (0:N/2-1) * (fs / N);  % Frequency axis

    % Ensure that the heart rate frequency calculation is valid
    heart_rate_freq_idx = find(Y .* (f >= 0.5 & f <= 3) == max(Y .* (f >= 0.5 & f <= 3)));
    if isempty(heart_rate_freq_idx)
        disp('Error: Unable to detect heart rate frequency');
        return;
    end
    
    heart_rate_freq = f(heart_rate_freq_idx);  
    pulse = heart_rate_freq * 60;  % Heart rate from FFT in BPM
    
    % Display the pulse from FFT
    disp(['Health Bot: Your Heart Rate from FFT is: ', num2str(pulse), ' BPM']);
    
    % Adaptive R-Peak Detection
    threshold_factor = 0.5;  % Threshold factor
    [~, R_peak_locations] = findpeaks(signal, 'MinPeakHeight', threshold_factor * max(signal), 'MinPeakDistance', round(fs * 0.6));  % Minimum distance between peaks = 600ms

    % Check if R-peaks were found
    if length(R_peak_locations) < 2
        disp('Error: Not enough R-peaks detected.');
        return;  % No diagnosis if not enough R-peaks
    end

    % Calculate RR intervals (differences between consecutive R-peaks)
    RR_intervals = diff(R_peak_locations) / fs;  % Convert to seconds

    % Calculate additional parameters
    avg_RR = mean(RR_intervals);  % Average RR interval
    max_RR = max(RR_intervals);  % Maximum RR interval
    min_RR = min(RR_intervals);  % Minimum RR interval
    std_RR = std(RR_intervals);  % Standard deviation of RR intervals

    % Check for NaN values in the calculated parameters
    if any(isnan([pulse, avg_RR, max_RR, min_RR, std_RR]))
        disp('Error: One or more calculated parameters are NaN.');
        return;  % No diagnosis if NaN values are present
    end
    
    % Optional: Output of the detected R-peaks and RR intervals
    if plot_heartrate_modified  % Only plot if this flag is true
        figure;
        subplot(2, 1, 1);
        plot(signal);
        hold on;
        plot(R_peak_locations, signal(R_peak_locations), 'ro');
        title('R-Peak Detection');
        xlabel('Samples');
        ylabel('Amplitude');
        legend('Denoised ECG', 'Detected R-peaks');

        subplot(2, 1, 2);
        plot(RR_intervals);
        title('RR Intervals');
        xlabel('Beat Number');
        ylabel('Interval Duration (s)');
        legend('RR Intervals');
    else
        disp('Health Bot: Plots have been skipped as plot_heartrate_modified is false.');
    end
end
