function feierabend_philipp_plot_noisy(signal, T)
    disp('-------------------------------------------------------------');
    disp('Task 2.1');
    disp('-------------------------------------------------------------');
    
    % Health Bot Introduction
    disp('Health Bot: Hello! I am the Health Bot, here to assist you with your ECG signal analysis.');

    % Warning if 'signal' is not a valid numeric vector
    if isempty(signal) || ~isnumeric(signal)
        warning('Health Bot: The signal is not a valid numeric vector. Continuing with the input data, but results may be inaccurate.');
    end

    % Warning if 'T' is not a valid positive scalar
    if ~isscalar(T) || T <= 0
        warning('Health Bot: The total time T is not a valid positive scalar. Proceeding with the provided value.');
    end

    % Warning if signal contains fewer than two data points
    if length(signal) < 2
        warning('Health Bot: The signal contains fewer than two data points. Plot might not be meaningful.');
    end
    
    % Proceeding with plotting, even if there are warnings
    t = linspace(0, T, length(signal));         % Reconstruct the time vector from total time
    idx = t >= 0 & t <= 30;                     % Define the index for the first 30 seconds
    plot(t(idx), signal(idx));                  % Plot the signal with a length of 30 seconds
    title('ECG Signal with 30 seconds duration');
    xlabel('Zeit /s');
    ylabel('Amplitude');

    % Information message for longer signal duration
    if T > 30
        disp('Health Bot: The signal is longer than 30 seconds. Only the first 30 seconds are displayed.');
    end
    
    % Health Bot confirmation message for successful plot generation
    disp('Health Bot: The plot has been successfully generated and displayed.');
end
