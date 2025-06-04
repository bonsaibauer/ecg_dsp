function feierabend_philipp_plot_noisy(signal, T)
    disp('Step 2.1 ');
    disp('-------------------------------------------------------------');   
    disp('Health Bot: Analyzing the signal...');

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
    
    % Plotting
    t = linspace(0, T, length(signal));
    idx = t >= 0 & t <= 30;
    plot(t(idx), signal(idx));
    title('ECG Signal (30 seconds)');
    xlabel('Time (s)');
    ylabel('Amplitude');

    % Message for longer signals
    if T > 30
        disp('Health Bot: Signal is longer than 30 seconds.');
    end

    disp('Health Bot: Plot successfully created!');
end

