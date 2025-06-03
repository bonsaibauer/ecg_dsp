% Aufgabe 2
% Aufgabe 2.1 - Laden und Plotten des verrauschten Signals
%
% Die Funktion Name_Vorname_plot_noisy soll folgende Parameter erhalten:
% - Den Signalnamen signal (z.B. 'noisy_ecg.mat').
% - Die Gesamtzeit T.
% Ausgabe ist der resultierende Plot.
%
% Aufgaben:
% 1. Laden Sie die Daten aus der übergebenen Datei signal.
% 2. Plotten Sie das verrauschte EKG-Signal gegen die Zeit.
% 3. Stellen Sie den Plot mit passenden Beschriftungen der x-Achse (Zeit /s) und y-Achse (Amplitude) dar.
% 4. Stellen Sie nur die ersten 30 Sekunden des Signals dar.

% Funktion zum Laden und Plotten des verrauschten EKG-Signals
% Eingabe:
% signal - Der Name des zu ladenden Signals (z.B. 'noisy_ecg.mat')
% T - Die Gesamtzeit des Signals

function feierabend_philipp_plot_noisy(file_name, signal, T)
    
    % Lädt die Datei und dynamisch den Signal- und Zeitvektor
    loaded_data = load(file_name);            % Lädt die ganze Datei in eine Struktur

    % Dynamisch das Signal und den Zeitvektor aus der Struktur holen
    signal_name = loaded_data.(signal);       % Signalvariable dynamisch anhand des Namens
    t = loaded_data.t;                        % Der Zeitvektor bleibt gleich, wenn 't' immer vorhanden ist.

    % Rekonstruktion des Zeitvektors aus der übergebenen Gesamtzeit
    t_reconstruction = linspace(0,T,length(signal_name)); 

    % Festlegen des Indexes für die ersten 30 Sekunden
    idx = t_reconstruction >= 0 & t_reconstruction <= 30;  % Nur Werte von 0 bis 30 Sekunden

    % Plotten des verrauschten EKG-Signals gegen den Zeitvektor 't' (nur die ersten 30 Sekunden)
    plot(t_reconstruction(idx), signal_name(idx));

    % Beschriftung der x-Achse: Zeit in Sekunden
    xlabel('Zeit [s]');
    
    % Beschriftung der y-Achse: Amplitude des EKG-Signals
    ylabel('Amplitude');
    
    % Titel des Plots
    title('Verrauschtes EKG-Signal mit 30 Sekunden Länge');
end


