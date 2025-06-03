function Name_Vorname_heartrate(signal, t)
    load('ECGData_Ex2_labeled.mat');
    % Berechnung der Herzfrequenz (Peak-Erkennung)
    [peaks, locs] = findpeaks(signal);
    % Berechnung der Herzfrequenz basierend auf der Frequenz der Peaks
    pulse = length(locs) / (t(end) - t(1)) * 60;
    figure;
    plot(t, signal);
    hold on;
    plot(t(locs), peaks, 'ro'); % Markierung der Peaks
    xlabel('Zeit [s]');
    ylabel('Amplitude');
    title(['Herzfrequenz: ' num2str(pulse) ' BPM']);
end
