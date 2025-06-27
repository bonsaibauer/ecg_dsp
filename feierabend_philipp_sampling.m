function [y_s, y_t] = feierabend_philipp_sampling(signal, T, T_orig, k, plot_sampling)
    
    disp('Step 2.2');
    disp('-------------------------------------------------------------');   
    disp('Health Bot: Sampling the signal...');

    % Validation
    if isempty(signal) || ~isnumeric(signal)
        warning('Health Bot: Invalid signal. No plot.');
        return;  % Exit if validation fails
    end
    if ~isscalar(T) || T <= 0
        warning('Health Bot: Invalid time T. No plot.');
        return;  % Exit if validation fails
    end
    if length(signal) < 2
        warning('Health Bot: Signal too short. No plot.');
        return;  % Exit if validation fails
    end
    
    % Calculate the new sampling frequency
    T_s = T_orig / k;

    % Perform down-sampling by the factor 'k'
    sampled_signal = signal(1:k:end);  % Downsampling by selecting every k-th sample

    % Create a new time vector for the sampled signal based on the new sampling rate
    t_sampled = (0:length(sampled_signal)-1) / T_s;  % Time vector for the sampled signal

    % Check the actual duration of the signal
    signal_duration = t_sampled(end);

    % Plot the first 30 seconds, but at most up to the length of the signal
    plot_duration = min(signal_duration, 30);  % If the signal is shorter than 30 seconds, use the actual length

    idx_plot = t_sampled <= plot_duration;  % Indices for the plot
    
    % Plot only if plot_sample is true
    if plot_sampling
        figure;
        
        % Plot the original ECG signal for comparison
        subplot(2,1,1);  % First subplot for original signal
        t_original = linspace(0, T, length(signal));
        idx_original = t_original >= 0 & t_original <= 30;
        plot(t_original(idx_original), signal(idx_original));  % Plot original signal for first 30 seconds
        title('Original ECG Signal (30 seconds)');
        xlabel('Time (s)');
        ylabel('Amplitude');
        grid on;

        % Plot the sampled ECG signal
        subplot(2,1,2);  % Second subplot for sampled signal
        plot(t_sampled(idx_plot), sampled_signal(idx_plot));  % Plot sampled signal for first 30 seconds
        title('Sampled ECG Signal (30 seconds)');
        xlabel('Time (s)');
        ylabel('Amplitude');
        grid on;

        % Message for longer signals
        if T > 30
            disp('Health Bot: The signal is shown for only the first 30 seconds.');
        end

        disp('Health Bot: Plot successfully created!');
    else
        disp('Health Bot: Plotting skipped.');
    end

    % Return both the sampled signal and the corresponding time vector
    y_s = sampled_signal;
    y_t = t_sampled;  % Return the time vector for the sampled signal

    disp('Health Bot: Sampling complete!');
end






   
