function Name_Vorname_filtering(signal, t)
    load('noisy_ecg.mat');
    % FFT des verrauschten Signals
    Y = fft(noisy_ecg);
    % Frequenzvektor erstellen
    f = (0:length(Y)-1) * (1 / (t(2) - t(1))) / length(Y);
    % Filter anwenden (z. B. Tiefpassfilter)
    Y_filtered = Y;
    Y_filtered(f > 50) = 0; % Setze Frequenzen über 50 Hz auf Null (Beispiel)
    yf = ifft(Y_filtered);
    figure;
    plot(t, real(yf));
    xlabel('Zeit [s]');
    ylabel('Amplitude');
    title('Gefiltertes EKG-Signal');
end
