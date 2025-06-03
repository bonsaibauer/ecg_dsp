function feierabend_philipp_fft(signal, t)
    disp('-------------------------------------------------------------');
    disp('Task 2.4');
    disp('-------------------------------------------------------------');    

    % Health Bot Introduction
    disp('Health Bot: Now, let me perform the Fourier Transform on your ECG signal to analyze it in the frequency domain!'); 
    pause(2);
    
    % Calculate the sampling frequency from the time vector
    fs = 1 / (t(2) - t(1));  % Sampling frequency (in Hz)

    % Perform the Fourier Transform on the signal to get frequency components
    N = length(signal);  % Length of the signal
    f = (0:N-1)*(fs/N);  % Frequency axis (in Hz)
    signal_fft = abs(fft(signal));  % Magnitude of the Fourier Transform
    
    % Visualize the frequency spectrum
    figure;
    plot(f, signal_fft);  % Plot magnitude spectrum vs frequency
    title('Magnitude Spectrum of ECG Signal');
    xlabel('Frequenz (Hz)');
    ylabel('Magnitude');

    % Dynamische Anpassung des xlim, basierend auf dem letzten Frequenzwert
    xlim([min(f) f(end)]);  % Der rechte Rand wird auf den letzten Frequenzwert gesetzt

    % Assign the fft signal to the global workspace as y_f
    assignin('base', 'y_fft', signal_fft);  % 'base' specifies the global workspace
    
    % Health Bot confirmation message for successful FFT analysis
    disp('Health Bot: Here is the frequency spectrum of your ECG signal!');
end
