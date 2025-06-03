%% Task 2  
% Task 2.1 - Loading and Plotting the Noisy Signal  
%
% The function Name_Lastname_plot_noisy should receive the following parameters:
% - The signal name 'signal' (e.g., 'noisy_ecg.mat').
% - The total time 'T'.
% The output is the resulting plot.
%
% Tasks:
% 1. Load the data from the provided signal file.
% 2. Plot the noisy ECG signal against time.
% 3. Display the plot with appropriate labels for the x-axis (Time / s) and y-axis (Amplitude).
% 4. Only display the first 30 seconds of the signal.

% Function to Load and Plot the Noisy ECG Signal
% Input:
% signal - The name of the signal to load (e.g., 'noisy_ecg.mat')
% T - The total time of the signal

function feierabend_philipp_plot_noisy(signal, T)
    % Health Bot Introduction
    disp('Hello! I am the Health Bot, here to assist you with your ECG signal analysis.');

    % Warning if 'signal' is not a valid numeric vector
    if isempty(signal) || ~isnumeric(signal)
        warning('Health Bot Warning: The signal is not a valid numeric vector. Continuing with the input data, but results may be inaccurate.');
    end

    % Warning if 'T' is not a valid positive scalar
    if ~isscalar(T) || T <= 0
        warning('Health Bot Warning: The total time T is not a valid positive scalar. Proceeding with the provided value.');
    end

    % Warning if signal contains fewer than two data points
    if length(signal) < 2
        warning('Health Bot Warning: The signal contains fewer than two data points. Plot might not be meaningful.');
    end
    
    % Proceeding with plotting, even if there are warnings
    t = linspace(0, T, length(signal));         % Reconstruct the time vector from total time
    idx = t >= 0 & t <= 30;                     % Define the index for the first 30 seconds
    plot(t(idx), signal(idx));                  % Plot the signal with a length of 30 seconds
    title('ECG Signal with 30 seconds duration');
    xlabel('Time (seconds)');
    ylabel('Amplitude');

    % Information message for longer signal duration
    if T > 30
        disp('Health Bot Information: The signal is longer than 30 seconds. Only the first 30 seconds are displayed.');
    end
    
    % Health Bot confirmation message for successful plot generation
    disp('Health Bot Information: The plot has been successfully generated and displayed.');
end
