function feierabend_philipp_filtering(signal, t)
    disp('-------------------------------------------------------------');
    disp('Task 2.3');
    disp('-------------------------------------------------------------');    

    % Health Bot Introduction
    disp('Health Bot: Oh dear, your signal is a bit noisy! Let me check if I can clean it up for you.'); 
    pause(2);
    
    % Check if Signal Processing Toolbox is installed using 'ver'
    installed_toolboxes = ver;  % Get list of installed toolboxes
    toolbox_installed = false;  % Assume it's not installed

    % Loop through the installed toolboxes and check for Signal Processing Toolbox
    for i = 1:length(installed_toolboxes)
        if strcmp(installed_toolboxes(i).Name, 'Signal Processing Toolbox')
            toolbox_installed = true;  % Set to true if the toolbox is found
            break;
        end
    end
    
    if toolbox_installed
        % Output message confirming that the toolbox is installed
        disp('Signal Processing Toolbox is installed.');
        
        % Calculate the sampling frequency from the time vector
        fs = 1 / (t(2) - t(1));  % Calculate the sampling frequency from the time vector

        % Determine the frequencies that are important for the ECG signal
        % Example: We know that the relevant range for ECG is between 0.5 Hz and 40 Hz.
        f_low = 0.5;  % Low cutoff frequency (Hz)
        f_high = 40;  % High cutoff frequency (Hz)

        % Design a band-pass filter based on the determined frequencies
        [b, a] = butter(4, [f_low f_high] / (fs / 2), 'bandpass');  % Butterworth Bandpass Filter

        % Apply the band-pass filter to the signal using zero-phase filtering
        signal_filtered = filtfilt(b, a, signal);  % Zero-phase filtering
        
        % Plot the filtered signal
        figure;
        plot(t, signal_filtered);  % Time vs filtered signal
        title('Filtered ECG Signal with Band-Pass Filter');
        xlabel('Zeit /s');
        ylabel('Amplitude');
        
        % Assign the filtered signal to the global workspace as y_f
        assignin('base', 'y_filtered', signal_filtered);  % 'base' specifies the global workspace
        
        % Health Bot confirmation message for successful filtering
        disp('Health Bot: Yay! Your ECG signal is successfully filtered.');
    else
        % Inform the user that the toolbox is not installed
        disp('Signal Processing Toolbox is not installed.');
    end
end
