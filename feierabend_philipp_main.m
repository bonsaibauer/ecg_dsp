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

T_orig = 128;    % Original sampling rate (e.g., 128 Hz for original signal)
k = 4;           % Downsampling factor (e.g., 4 for downsampling)
[y_s, y_t] = feierabend_philipp_sampling(signal, T, T_orig, k);   

%% Task 2.3 - Filter the Noisy sampled Signal

y_f = feierabend_philipp_filtering(y_s, y_t); % Signal Processing Toolbox is required

%% Task 2.4 - FFT for sampled and filtered Signal

y_f_fft = feierabend_philipp_fft(y_f, y_t);

%% Task 5.1 - Heart Rate Calculation

clear;                                          % Clears all variables from the workspace and closes all open figures.
clc;                                            % Clears the command window and resets the display.
load('ECGData_Ex2_labeled.mat'); 
combined_signal = [ECG_SR; ECG_ARR; ECG_CHF];   % Add them vertically
signal = combined_signal(1, :);                 % Extract the first time series (first row)
pulse = feierabend_philipp_heartrate(signal, t);

%% Task 5.1 - Heart Rate Calculation modified for 5.2

clear;                                          % Clears all variables from the workspace and closes all open figures.
clc;                                            % Clears the command window and resets the display.
load('ECGData_Ex2_labeled.mat'); 
combined_signal = [ECG_SR; ECG_ARR; ECG_CHF];   % Add them vertically
signal = combined_signal(1, :);                 % Extract the first time series (first row)
pulse = feierabend_philipp_heartrate_modified(signal, t);

%% Task 5.2

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
load('ECGData_Ex2_labeled.mat'); 
combined_signal = [ECG_SR; ECG_ARR; ECG_CHF];   % Add them vertically
signal = combined_signal(4, :);                 % Extract the first time series (first row)

T = t(end);  
T_orig = 128; 
k = 2; 

[y_s, y_t] = feierabend_philipp_sampling(signal, T, T_orig, k); 
y_f = feierabend_philipp_filtering(y_s, y_t);
y_f_fft = feierabend_philipp_fft(y_f, y_t);






