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
plot_heartrate_modified = true;
[pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(signal, t, plot_heartrate_modified);

%% Task 5.2 - Manual classification (Test Sampling, Filtering, Heartbeat_modified, classification functions)

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

% Define the index for the signal dynamically (you can change this variable as needed)
signal_index = 31;  % Example: change this index to select different time series

% Combine the datasets vertically
combined_signal = [ECG_SR; ECG_ARR; ECG_CHF];    % Combine the datasets vertically
signal = combined_signal(signal_index, :);       % Extract the time series based on the dynamic index

% Determine which dataset the signal belongs to based on the row index
if signal_index >= 1 && signal_index <= 18  % If the signal is from Sinus Rhythm (SR)
    dataset_label = 'SR';
elseif signal_index >= 19 && signal_index <= 36  % If the signal is from Arrhythmia (ARR)
    dataset_label = 'ARR';
elseif signal_index >= 37 && signal_index <= 54  % If the signal is from Congestive Heart Failure (CHF)
    dataset_label = 'CHF';
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

clear;
clc;

% Load training dataset
load('ECGData_Ex2_labeled.mat');
model = feierabend_philipp_train_model(ECG_SR, ECG_ARR, ECG_CHF, t);

% Load test dataset
load('ECGData_test.mat');  % Load test dataset

% Select a time series from the test data
signal_index = 2;  % Choose any index
signal = ECG(signal_index, :);

% Calculate features for the selected test signal
[pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(signal, t, false);

% Assume the true label for the test signal, 
% if the category is clear 'SR', 'ARR', CHF
dataset_label = 'SR';

% Classify the signal using the trained model
diagnosis = feierabend_philipp_classification(RR_intervals, pulse, avg_RR, max_RR, min_RR, std_RR, dataset_label, model);

% Visualize the decision tree used for classification
tree = model.Trees{1};  % First tree in the random forest
figure;
view(tree, 'Mode', 'graph');  % Display the tree as a graph

disp('Decision tree visualization is complete.');