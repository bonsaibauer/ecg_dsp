
% Aufgabe 2.2 - Abtastung des Signals
%
% Aufgabenstellung:
% 2.2 Abtastung
% Die Funktion Name_Vorname_sampling soll folgende Parameter erhalten:
% - Den Signalnamen signal.
% - Die Gesamtzeit T.
% - Abtastrate Torig des originalen Signals.
% - Abtastfaktor k.
% Ausgabe ist das abgetastete Signal ys.
%
% Aufgaben:
% 1. Führen Sie eine Abtastung des Signals mit einem Faktor von 4 durch. Die ursprüngliche Abtastfrequenz betrug 128 Hertz.
% 2. Plotten Sie das abgetastete Signal gegen die Zeit.
% 3. Stellen Sie den Plot mit passenden Beschriftungen der x-Achse (Zeit /s) und y-Achse (Amplitude) dar.
% 4. Stellen Sie nur die ersten 30 Sekunden des Signals dar.

% Funktion zur Abtastung des Signals
% Eingabe:
% signal - Der Name des zu ladenden Signals
% T - Die Gesamtzeit des Signals
% Torig - Die ursprüngliche Abtastrate des Signals
% k - Der Abtastfaktor

function feierabend_philipp_sampling(signal, T, Torig, k)
    % Laden der Datei 'noisy_ecg.mat', die das verrauschte EKG-Signal enthält
    load('noisy_ecg.mat');
    
    % Berechnung der neuen Abtastrate
    fs_new = Torig / k;
    
    % Abtastung des Signals
    ys = noisy_ecg(1:k:end);
    t_new = t(1:k:end);
    
    % Erstellen einer neuen Figur für den Plot
    figure;
    
    % Plotten des abgetasteten Signals gegen den neuen Zeitvektor
    plot(t_new, ys);
    
    % Beschriftung der x-Achse: Zeit in Sekunden
    xlabel('Zeit [s]');
    
    % Beschriftung der y-Achse: Amplitude des abgetasteten EKG-Signals
    ylabel('Amplitude');
    
    % Festlegen der x-Achse, um nur die ersten 30 Sekunden anzuzeigen
    xlim([0 30]);
    
    % Titel des Plots
    title('Abgetastetes EKG-Signal');
end

k = 4 
Torig = 128