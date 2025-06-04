function y_f = feierabend_philipp_filtering(y_s, y_t)

    disp('Step 2.3');
    disp('-------------------------------------------------------------');   
    disp('Health Bot: Filtering the ECG signal...');

    % Calculate the sampling frequency based on the time vector y_t
    fs = 1 / (y_t(2) - y_t(1));  % Calculate the sampling frequency
    
    % Define the relevant frequencies for the ECG signal
    f_low = 0.5;  % Lower cutoff frequency (Hz)
    
    % Adjust the upper cutoff frequency to be slightly below the Nyquist frequency
    nyquist_freq = fs / 2;  % Nyquist frequency (half of the sampling frequency)
    f_high = min(40, nyquist_freq * 0.99);  % Set f_high slightly below the Nyquist frequency

    % Normalize the frequencies to the [0,1] range
    f_low_norm = f_low / nyquist_freq;  % Normalized lower cutoff frequency
    f_high_norm = f_high / nyquist_freq;  % Normalized upper cutoff frequency
    
    % Design the bandpass filter with the normalized frequencies
    [b, a] = butter(4, [f_low_norm f_high_norm], 'bandpass');  % Butterworth bandpass filter

    % Apply the filter to the signal with zero-phase filtering
    signal_filtered = filtfilt(b, a, y_s);  % Zero-phase filtering

    % Define the duration for plotting (30 seconds or the length of the signal)
    plot_duration = min(30, y_t(end));  % Plot only the first 30 seconds or the entire signal if shorter
    idx_plot = y_t <= plot_duration;  % Indices for the plot

    % Plot the original signal and filtered signal for comparison
    figure;
    subplot(2,1,1);  % First subplot for original signal
    plot(y_t(idx_plot), y_s(idx_plot));  % Plot original signal for first 30 seconds
    title('Sampled ECG Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    subplot(2,1,2);  % Second subplot for filtered signal
    plot(y_t(idx_plot), signal_filtered(idx_plot));  % Plot filtered signal for first 30 seconds
    title('Filtered ECG Signal with Band-Pass Filter');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    % Dynamically adjust the xlim based on the time vector
    xlim([min(y_t(idx_plot)) max(y_t(idx_plot))]);

    disp('Health Bot: Yay! Your ECG signal is successfully filtered.');

    % Return the filtered signal
    y_f = signal_filtered;
end

