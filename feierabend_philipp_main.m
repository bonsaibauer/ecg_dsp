%% feierabend_philipp_main.m
% Main script for loading, processing, and plotting the ECG signals
% The code is designed in a way that it can work with different datasets.

%% Task 2.1 - Loading and Plotting the Noisy Signal

clear;                   % Clears all variables from the workspace and closes all open figures.
clc;                     % Clears the command window and resets the display.
load('noisy_ecg.mat');   % Load noisy ECG data from 'noisy_ecg.mat'
signal = noisy_ecg;      % Store ECG signal
T = t(end);              % Total time duration of the ECG    
feierabend_philipp_plot_noisy(signal, T); 

%% Task 2.2  - Sampling the Noisy Signal

T_orig = 128;             % Original sampling rate (e.g., 128 Hz for original signal)
k = 4;                    % Downsampling factor (e.g., 4 for downsampling)
plot_sampling = true;     % Set to false if you want to skip plotting for 5.2
[y_s, y_t] = feierabend_philipp_sampling(signal, T, T_orig, k, plot_sampling);  

%% Task 2.3 - Filter the Noisy sampled Signal

plot_filtering = true;    % Set to false if you want to skip plotting for 5.2
y_f = feierabend_philipp_filtering(y_s, y_t, plot_filtering); % Signal Processing Toolbox is required

%% Task 2.4 - FFT for sampled and filtered Signal

y_f_fft = feierabend_philipp_fft(y_f, y_t);

%% Task 5.1 - Heart Rate Calculation

clear;                                          % Clears all variables from the workspace and closes all open figures.
clc;                                            % Clears the command window and resets the display.
load('ECGData_Ex2_labeled.mat'); 
combined_signal = [ECG_SR; ECG_ARR; ECG_CHF];   % Add them vertically
signal = combined_signal(1, :);                 % Extract the first time series (first row)
pulse = feierabend_philipp_heartrate(signal, t);

%% Task 5.2 - Heart Rate Calculation modified for 5.2

clear;                                          % Clears all variables from the workspace and closes all open figures.
clc;                                            % Clears the command window and resets the display.
load('ECGData_Ex2_labeled.mat'); 
combined_signal = [ECG_SR; ECG_ARR; ECG_CHF];    % Add them vertically
signal = combined_signal(53, :);                 % Extract the first time series (first row)
plot_heartrate_modified = false;
[pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(signal, t, plot_heartrate_modified);
%% Task 5.2

%% Task 5.2

% Declare global variables
global ECG_ARR ECG_CHF ECG_SR combined_signal

% You are provided with labeled datasets stored in a file named
% ECGData_Ex2_labeled.mat, which contains 5 variables:
% 
% 1. t: Time vector (in seconds)
% 2. ECG_ARR: Dataset with Arrhythmias (ARR)
% 3. ECG_CHF: Dataset with Congestive Heart Failures (CHF)
% 4. ECG_SR: Dataset with Sinus Rhythms (SR)
% 5. ECG_SR: The unlabeled test dataset

clear;                                          % Clears all variables from the workspace and closes all open figures.
clc;                                            % Clears the command window and resets the display.

% Load the data
load('ECGData_Ex2_labeled.mat'); 

% Combine the datasets vertically
combined_signal = [ECG_SR; ECG_ARR; ECG_CHF];    % Combine the datasets vertically
signal = combined_signal(6, :);                 % Extract the 30th time series (30th row)

% Determine which dataset the signal belongs to
if 1 <= 30 && 18 >= 30  % If the signal is from Sinus Rhythm (SR)
    dataset_label = 'SR (Sinus Rhythm)';
elseif 19 <= 30 && 36 >= 30  % If the signal is from Arrhythmia (ARR)
    dataset_label = 'ARR (Arrhythmia)';
elseif 37 <= 30 && 54 >= 30  % If the signal is from Congestive Heart Failure (CHF)
    dataset_label = 'CHF (Congestive Heart Failure)';
else
    dataset_label = 'Unknown Dataset';
end

disp(['Training Dataset: ', dataset_label]);  % Output the training dataset

T = t(end);  
T_orig = 128; 
k = 1; 
plot_sampling = false;  
plot_filtering = false;
plot_heartrate_modified = false;

% Further processing
[y_s, y_t] = feierabend_philipp_sampling(signal, T, T_orig, k, plot_sampling); 
y_f = feierabend_philipp_filtering(y_s, y_t, plot_filtering);
[pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(y_f, y_t, plot_heartrate_modified);
diagnosis = feierabend_philipp_classification(RR_intervals, pulse, avg_RR, max_RR, min_RR, std_RR, dataset_label);














%% Task 5.2

%% Task 5.2

clear;                                          % Clears all variables from the workspace and closes all open figures.
clc;                                            % Clears the command window and resets the display.
load('ECGData_Ex2_labeled.mat');                % Load the training data
load('ECGData_test.mat');                      % Load the test data (ECG and t)

% Kombiniere die Signale und bereite die Labels vor
combined_signal = [ECG_SR; ECG_ARR; ECG_CHF];  % SR: 1-18, ARR: 19-36, CHF: 37-54
labels = [ones(18, 1); 2 * ones(18, 1); 3 * ones(18, 1)];  % 1 = SR, 2 = ARR, 3 = CHF

% Initialisiere leere Arrays für Merkmale
features = [];

% Extrahiere Merkmale für jedes Signal
for i = 1:size(combined_signal, 1)
    signal = combined_signal(i, :);
    
    % Vorverarbeitung: Sampling und Filtering
    T = t(end);  
    T_orig = 128; 
    k = 1; 
    plot_sampling = false;  
    plot_filtering = false;
    plot_heartrate_modified = false;
    [y_s, y_t] = feierabend_philipp_sampling(signal, T, T_orig, k, plot_sampling); 
    y_f = feierabend_philipp_filtering(y_s, y_t, plot_filtering);

    % Extrahiere Merkmale
    [pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(y_f, y_t, plot_heartrate_modified);
    
    % Wenn NaN-Werte vorhanden sind, überspringe diese Iteration
    if any(isnan([pulse, avg_RR, max_RR, min_RR, std_RR]))
        continue;
    end
    
    % Füge die Merkmale zu einem Array hinzu
    features = [features; avg_RR, max_RR, min_RR, std_RR];  % Hier können auch weitere Merkmale hinzugefügt werden
end

% Zufällige Aufteilung der Daten in Trainings- und Testdatensätze
cv = cvpartition(length(labels), 'HoldOut', 0.3); % 70% Training, 30% Test

% Trainingsdaten
train_features = features(training(cv), :);
train_labels = labels(training(cv));

% Testdaten
test_features = features(test(cv), :);
test_labels = labels(test(cv));

% Training des k-NN Modells
Mdl = fitcknn(train_features, train_labels, 'NumNeighbors', 3);

% Teste das Modell mit den Testdaten
predicted_labels = predict(Mdl, test_features);

% Berechne die Genauigkeit
accuracy = sum(predicted_labels == test_labels) / length(test_labels);
disp(['Accuracy: ', num2str(accuracy * 100), '%']);

% Optional: Confusion Matrix für detaillierte Evaluation
confusionchart(test_labels, predicted_labels);

% Jetzt wird der Testdatensatz für die manuelle Klassifikation verwendet:
% Benutzer wählt die Zeitreihe aus, die getestet werden soll
disp('Please choose the time series to test from the ECG data (1 to N):');
chosen_index = input('Enter the index of the ECG signal to classify: ');

% Auswahl des Signals für die Klassifikation
test_signal = ECG(chosen_index, :);   % Die gewählte Zeitreihe aus den Testdaten

% Vorverarbeitung des Testsignals
T_test = t(end);  
T_orig_test = 128;
k_test = 1; 
plot_sampling_test = false;  
plot_filtering_test = false; 
[y_s_test, y_t_test] = feierabend_philipp_sampling(test_signal, T_test, T_orig_test, k_test, plot_sampling_test); 
y_f_test = feierabend_philipp_filtering(y_s_test, y_t_test, plot_filtering_test);

% Extrahiere Merkmale für die Klassifikation des Testsignals
[pulse_test, RR_intervals_test, avg_RR_test, max_RR_test, min_RR_test, std_RR_test] = feierabend_philipp_heartrate_modified(y_f_test, y_t_test);

% Manuelle Klassifikation mit der ursprünglichen Funktion feierabend_philipp_classification
diagnosis = feierabend_philipp_classification(RR_intervals_test, pulse_test, avg_RR_test, max_RR_test, min_RR_test, std_RR_test);
disp(['Manual Diagnosis: ', diagnosis]);








