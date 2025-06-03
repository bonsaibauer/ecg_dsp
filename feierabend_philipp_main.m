%% feierabend_philipp_main.m
% Main script for loading, processing, and plotting the ECG signals
% The code is designed in a way that it can work with different datasets.

%% Task 2
%% Task 2.1 - Loading and Plotting the Noisy ECG Signal
% In this task, we load the noisy ECG signal from the 'noisy_ecg.mat' file
% and plot it for the first 30 seconds. The code is designed to work with
% different ECG datasets as long as the required variables are present.

% Main script for processing and analyzing the noisy ECG signal
clear;
clc;

% Load the noisy ECG data, assuming the file 'noisy_ecg.mat' is in the current directory
% The code can be adapted to load and process other datasets as long as they contain the necessary variables.
load('noisy_ecg.mat');

% Store the noisy ECG signal in the variable 'signal'
signal = noisy_ecg;  

% The total time is determined by the last value in the time vector 't',
% If the time vector 't' is not available, we can specify the total duration of the ECG recording here instead.
T = t(end);    

% Call the function to plot the signal
feierabend_philipp_plot_noisy(signal, T);

%% Task 2.2 
% Original sampling rate (e.g., 128 Hz for original signal)
T_orig = 128;

% Downsampling factor (e.g., 4 for downsampling)
k = 4;

% Call the function to plot the signal
feierabend_philipp_sampling(signal, T, T_orig, k);

%% Task 2.3
% Call the function to plot the signal
feierabend_philipp_filtering(signal, t);

%% Task 2.4
% Call the function to plot the signal
feierabend_philipp_fft(signal, t);

%% Part II
%% Task 4

% You are provided with labeled datasets stored in a file named
% ECGData_Ex2_labeled.mat, which contains 5 variables:
% 
% 1. t: Time vector (in seconds)
% 2. ECG_ARR: Dataset with Arrhythmias (ARR)
% 3. ECG_CHF: Dataset with Congestive Heart Failures (CHF)
% 4. ECG_SR: Dataset with Sinus Rhythms (SR)
% 5. ECG_SR: The unlabeled test dataset

%% Task 5

