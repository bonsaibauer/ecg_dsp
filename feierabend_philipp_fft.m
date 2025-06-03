function Name_Vorname_fft(signal, t)
    load('noisy_ecg.mat');
    % FFT des gefilterten Signals
    Y = fft(signal);
    f = (0:length(Y)-1) * (1 / (t(2) - t(1))) / length(Y);
    figure;
    plot(f, abs(Y));
    xlabel('Frequenz [Hz]');
    ylabel('Magnitude');
    title('Magnitudespektrum des gefilterten EKG-Signals');
end
