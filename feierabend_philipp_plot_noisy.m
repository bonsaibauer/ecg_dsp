% Aufgabe 2
% Aufgabe 2.1 - Laden und Plotten des verrauschten Signals
%
% Die Funktion Name_Vorname_plot_noisy soll folgende Parameter erhalten:
% - Den Signalnamen signal.
% - Die Gesamtzeit T.
% Ausgabe ist der resultierende Plot.
%
% Aufgaben:
% 1. Laden Sie die Daten aus noisy_ecg.mat.
% 2. Plotten Sie das verrauschte EKG-Signal gegen die Zeit.
% 3. Stellen Sie den Plot mit passenden Beschriftungen der x-Achse (Zeit /s) und y-Achse (Amplitude) dar.
% 4. Stellen Sie nur die ersten 30 Sekunden des Signals dar.

% Funktion zum Laden und Plotten des verrauschten EKG-Signals
% Eingabe:
% signal - Der Name des zu ladenden Signals
% T - Die Gesamtzeit des Signals

function feierabend_philipp_plot_noisy(signal, T)
    % Laden der Datei 'noisy_ecg.mat', die das verrauschte EKG-Signal enthält
    load('noisy_ecg.mat');
    
    % Erstellen einer neuen Figur für den Plot
    figure;
    
    % Plotten des verrauschten EKG-Signals gegen den Zeitvektor 't'
    plot(t, noisy_ecg);
    
    % Beschriftung der x-Achse: Zeit in Sekunden
    xlabel('Zeit [s]');
    
    % Beschriftung der y-Achse: Amplitude des EKG-Signals
    ylabel('Amplitude');
    
    % Festlegen der x-Achse, um nur die ersten 30 Sekunden anzuzeigen
    xlim([0 30]);
    
    % Titel des Plots
    title('Verrauschtes EKG-Signal');
end



