function feierabend_philipp_heartrate(signal, t)
    disp('-------------------------------------------------------------');
    disp('Task 5.1');
    disp('-------------------------------------------------------------');    

    % Health Bot Introduction
    disp('OMG! I''m back to save the day! Let me help you with your signal.'); 
    pause(2);

    % Signal Validation: Is the signal too short?
    if length(signal) < 1000
        disp('Health Bot: Signal is too short. Please provide a longer signal.');
        pulse = NaN;
        return;
    end

    % Check if the time vector and signal length match
    if length(t) ~= length(signal)
        disp('Health Bot: Time vector and signal length do not match. Please check your data.');
        pulse = NaN;
        return;
    end

    % Check how many time series (rows) are in the signal
    [num_rows, ~] = size(signal);
    disp(['Health Bot: Found ', num2str(num_rows), ' time series in the signal.']);

    % Choose the first time series if there are multiple
    if num_rows > 1
        signal_row_1 = signal(1, :);  % Select the first time series
        disp('Health Bot: Using the first one.');
    else
        signal_row_1 = signal;  % If there's only one, use it
        disp('Health Bot: Only one time series found. Using it.');
    end

    % Calculate the sampling rate
    fs = 1 / (t(2) - t(1));  % Sampling frequency in Hz
    if fs <= 0
        disp('Health Bot: Invalid sampling frequency detected. Ensure your time vector is correct.');
        pulse = NaN;
        return;
    end

    % Compute the FFT
    try
        N = length(signal_row_1);  
        Y = fft(signal_row_1);  
        Y = abs(Y(1:N/2));
    catch
        disp('Health Bot: Error in FFT computation. Please check the signal data.');
        pulse = NaN;
        return;
    end

    % Frequency analysis
    f = (0:N/2-1) * (fs / N);  
    valid_range = f >= 0.5 & f <= 3;  
    Y_filtered = Y .* valid_range;  
    [~, idx] = max(Y_filtered);  
    heart_rate_freq = f(idx);  
    pulse = heart_rate_freq * 60;  % BPM

    % Check the heart rate
    if pulse < 40 || pulse > 220
        disp('Health Bot: Implausible heart rate detected. Pulse value out of realistic range.');
        pulse = NaN;
        return;
    end

    % Output the calculated heart rate
    disp(['Health Bot: Your Heart Rate is: ', num2str(pulse), ' BPM']);

    % Assign the pulse rate to the global workspace as pulse
    assignin('base', 'pulse', pulse);  % 'base' specifies the global workspace

    % Find the peaks in the signal without minimum distance (MinPeakDistance removed)
    [peaks, locs] = findpeaks(signal_row_1);  % No restrictions on peak distance
    
    % Check if the number of peaks is reasonable
    if isempty(locs)
        disp('Health Bot: No peaks detected in the signal. Please check the signal quality.');
        pulse = NaN;
        return;
    end

    % Calculate the distances between the peaks
    peak_distances = diff(t(locs));  % Distances in seconds between the peaks
    
    % Calculate the expected time between the peaks
    expected_distance = 60 / pulse;  % Expected time between peaks in seconds
    
    % Check if the distances vary significantly from the expected heart rate
    if any(abs(peak_distances - expected_distance) > 0.1)  % Tolerance of 0.1 seconds
        disp('Health Bot: Inconsistent peak distances detected. The signal may contain noise or artifacts.');
        pulse = NaN;
    end

    % Plot the signal and mark the peaks
    try
        figure;
        plot(t, signal_row_1);
        hold on;
        plot(t(locs), peaks, 'ro');  % Mark all peaks
        title('ECG Signal with Detected Heart Rate Peaks');
        xlabel('Time (s)');
        ylabel('Amplitude');
        
        % Dynamically adjust the xlim based on the last time value
        xlim([min(t) t(end)]);  % The right limit will be set to the last value of t
        
    catch
        disp('Health Bot: Error plotting the ECG signal. Please check the data format.');
        pulse = NaN;
    end

    disp('-------------------------------------------------------------');
    disp('Task 5.2');
    disp('-------------------------------------------------------------');    

    % Check how many time series (rows) are in the signal
    [num_rows, ~] = size(signal);
    disp(['Health Bot: Found ', num2str(num_rows), ' time series in the signal.']);

    % Calculate the sampling rate
    fs = 1 / (t(2) - t(1));  % Sampling frequency in Hz
    if fs <= 0
        disp('Health Bot: Invalid sampling frequency detected. Ensure your time vector is correct.');
        pulse = NaN;
        return;
    end

    % Loop over all time series (rows) in the signal
    for i = 1:num_rows
        signal_row = signal(i, :);  % Select the i-th time series

        % Compute the FFT
        try
            N = length(signal_row);  
            Y = fft(signal_row);  
            Y = abs(Y(1:N/2));
        catch
            disp(['Health Bot: Error in FFT computation for time series ', num2str(i), '. Please check the signal data.']);
            pulse = NaN;
            return;
        end

        % Frequency analysis
        f = (0:N/2-1) * (fs / N);  
        valid_range = f >= 0.5 & f <= 3;  
        Y_filtered = Y .* valid_range;  
        [~, idx] = max(Y_filtered);  
        heart_rate_freq = f(idx);  
        pulse = heart_rate_freq * 60;  % BPM

        % Check the heart rate
        if pulse < 40 || pulse > 220
            disp(['Health Bot: Implausible heart rate detected for time series ', num2str(i), '. Pulse value out of realistic range.']);
            pulse = NaN;
            return;
        end

        % Output the calculated heart rate
        disp(['Health Bot: Heart Rate for time series ', num2str(i), ' is: ', num2str(pulse), ' BPM']);

        % Find the peaks in the signal without minimum distance (MinPeakDistance removed)
        [peaks, locs] = findpeaks(signal_row);  % No restrictions on peak distance
        
        % Check if the number of peaks is reasonable
        if isempty(locs)
            disp(['Health Bot: No peaks detected in time series ', num2str(i), '. Please check the signal quality.']);
            pulse = NaN;
            return;
        end

        % Create a new figure every 5 time series
        if mod(i-1, 5) == 0
            figure;  % Create a new figure every time we process 5 time series
        end

        % Create a subplot for the current time series
        subplot(5, 1, mod(i-1, 5) + 1);  % Create a new subplot (5 per page)
        plot(t, signal_row);
        hold on;
        plot(t(locs), peaks, 'ro');  % Mark all peaks
        title(['ECG Signal with Detected Peaks - Time Series ', num2str(i)]);
        xlabel('Time (s)');
        ylabel('Amplitude');
        xlim([min(t) t(end)]);  % Adjust x-axis to match the time vector
        
        % Additional checks for peak distances and warnings
        peak_distances = diff(t(locs));  % Distances in seconds between the peaks
        expected_distance = 60 / pulse;  % Expected time between peaks in seconds
        
        % Check if the distances vary significantly from the expected heart rate
        if any(abs(peak_distances - expected_distance) > 0.1)  % Tolerance of 0.1 seconds
            disp(['Health Bot: Inconsistent peak distances detected in time series ', num2str(i), '. The signal may contain noise or artifacts.']);
            pulse = NaN;
        end
    end

end