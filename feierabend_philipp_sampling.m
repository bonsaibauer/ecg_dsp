function feierabend_philipp_sampling(signal, T, T_orig, k)
    disp('-------------------------------------------------------------');
    disp('Task 2.2');
    disp('-------------------------------------------------------------');  
    
    % Health Bot Introduction
    disp('Health Bot: Oh, I have a new task! Let me get started on sampling your ECG signal...'); 
    pause(2);
    disp('Health Bot: Just a moment, I am almost done...');
    pause(2);

    % Calculation of the new sampling rate
    T_s = 1 / (T_orig / k);  % New sampling time (s) needed to sample the signal with a factor of k

    % Create the time vector for the sampled signal
    t_sampled = 0:T_s:T;  % Time vector for the sampled signal, from 0 to T

    t = linspace(0, T, length(signal));         % Reconstruct the time vector from total time

    % Interpolation for signal resampling
    signal_sampled = interp1(t, signal, t_sampled, 'spline');  % Interpolate the signal to the new time axis

    % Limit the plot to the first 30 seconds
    t_sampled_30sec = t_sampled(t_sampled <= 30);  % Time vector limited to 30 seconds
    signal_sampled_30sec = signal_sampled(1:length(t_sampled_30sec));  % Corresponding sampled signal

    % Plot the sampled signal
    figure;
    plot(t_sampled_30sec, signal_sampled_30sec); % Plot first 30 seconds
    title('Sampled ECG Signal with 30 seconds duration');
    xlabel('Zeit /s');
    ylabel('Amplitude');

    % Health Bot confirmation message for successful sampling
    disp('Health Bot: And... done! Your sampled ECG signal is ready.');
end




   
