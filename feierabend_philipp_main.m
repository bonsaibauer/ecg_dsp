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
plot_sampling = true;     % Set to false if you want to skip plotting for Task 5.2
[y_s, y_t] = feierabend_philipp_sampling(signal, T, T_orig, k, plot_sampling);  

%% Task 2.3 - Filter the Noisy sampled Signal

plot_filtering = true;    % Set to false if you want to skip plotting for Task 5.2
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

%% Task 5.2 - Modul: Heart Rate Calculation modified for 5.2

clear;                                          % Clears all variables from the workspace and closes all open figures.
clc;                                            % Clears the command window and resets the display.
load('ECGData_Ex2_labeled.mat'); 
combined_signal = [ECG_SR; ECG_ARR; ECG_CHF];    % Add them vertically
signal = combined_signal(2, :);                 % Extract the first time series (first row)
plot_heartrate_modified = true;
[pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(signal, t, plot_heartrate_modified);

%% Task 5.2 - Machine Learning - Heart Rhythm Classification

clear;
clc;

% Load training dataset
load('ECGData_Ex2_labeled.mat');
sampling_filtering = false;
T = t(end);  
T_orig = 128; 
k = 1;
model = feierabend_philipp_train_model(ECG_SR, ECG_ARR, ECG_CHF, t, T, T_orig, k, sampling_filtering);

% Load test dataset
load('ECGData_test.mat');  % Load test dataset
signal_index = 4;  % Choose any index
signal = ECG(signal_index, :);
% Assume the true label for the test signal, 
% if the category is clear 'SR', 'ARR', CHF
dataset_label = 'unknown';

 % Calculate the features for the current test signal
        if sampling_filtering
            % Perform sampling and filtering when sampling_filtering is true
            [y_s, y_t] = feierabend_philipp_sampling(signal, T, T_orig, k, false); 
            y_f = feierabend_philipp_filtering(y_s, y_t, false);
            % Proceed to heart rate calculation using the filtered signal
            [pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(y_f, y_t, false);
        else
            % Skip sampling and filtering, directly use the original signal
            [pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(signal, t, true);
        end

% Feature vector for classification
features = [pulse, avg_RR, max_RR, min_RR, std_RR];

% Predict class probabilities for each tree in the ensemble
[~, score] = predict(model, features);  % Get the score (probabilities) from each tree

% Convert the scores into percentages
score_percentages = score * 100;  % Convert the probabilities to percentages

% Define the classes
classes = {'SR', 'ARR', 'CHF'};

% Display the probabilities in a readable format
disp('Class probabilities in percentages:');
for i = 1:length(classes)
    disp([classes{i}, ': ', num2str(score_percentages(i)), '%']);
end

% Visualize the decision tree used for classification (first tree in the ensemble)
view(model.Trees{1}, 'Mode', 'graph');

% Classify the signal using the trained model
diagnosis = feierabend_philipp_classification(RR_intervals, pulse, avg_RR, max_RR, min_RR, std_RR, dataset_label, model);
