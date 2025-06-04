function y_f_fft = feierabend_philipp_fft(y_f, y_t)
    
    disp('Step 2.4');
    disp('-------------------------------------------------------------');   
    disp('Health Bot: FFT the ECG signal...');

    % Sampling frequency
    fs = 1 / (y_t(2) - y_t(1));  

    % Fourier Transform and positive frequencies
    N = length(y_f);  
    f = (0:N-1)*(fs/N);  
    y_f_fft = abs(fft(y_f));  
    half_N = ceil(N/2);  
    f = f(1:half_N);  
    y_f_fft = y_f_fft(1:half_N);  

    % Plotting
    figure;
    subplot(2,1,1);  
    plot(y_t, y_f);  
    title('Filtered ECG Signal (Time Domain)');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    subplot(2,1,2);  
    plot(f, y_f_fft);  
    title('Magnitude Spectrum of Filtered ECG Signal (One-Sided FFT)');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    xlim([0 f(end)]);  

    % Return the fft signal
    disp('Health Bot: FFT complete!');
end
