function model = feierabend_philipp_train_model(ECG_SR, ECG_ARR, ECG_CHF, t, T, T_orig, k, sampling_filtering)
    % Prepare features and labels
    features = [];
    labels = {};

    % Initialize counters for each dataset
    sr_count = 0;
    arr_count = 0;
    chf_count = 0;

    % Extract features for ECG_SR dataset
    for i = 1:size(ECG_SR, 1)  % Use size(ECG_SR, 1) to iterate over rows
        signal = ECG_SR(i, :);
        [pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(signal, t, false);
        if ~isnan(pulse) && ~isnan(avg_RR) && ~isnan(max_RR) && ~isnan(min_RR) && ~isnan(std_RR)
            features = [features; pulse, avg_RR, max_RR, min_RR, std_RR];
            labels = [labels; {'SR'}];
            sr_count = sr_count + 1;  % Increment SR count
        end
    end

    % Extract features for ECG_ARR dataset
    for i = 1:size(ECG_ARR, 1)  % Use size(ECG_ARR, 1) to iterate over rows
        signal = ECG_ARR(i, :);
        [pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(signal, t, false);
        if ~isnan(pulse) && ~isnan(avg_RR) && ~isnan(max_RR) && ~isnan(min_RR) && ~isnan(std_RR)
            features = [features; pulse, avg_RR, max_RR, min_RR, std_RR];
            labels = [labels; {'ARR'}];
            arr_count = arr_count + 1;  % Increment ARR count
        end
    end

    % Extract features for ECG_CHF dataset
    for i = 1:size(ECG_CHF, 1)  % Use size(ECG_CHF, 1) to iterate over rows
        signal = ECG_CHF(i, :);
        [pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(signal, t, false);
        if ~isnan(pulse) && ~isnan(avg_RR) && ~isnan(max_RR) && ~isnan(min_RR) && ~isnan(std_RR)
            features = [features; pulse, avg_RR, max_RR, min_RR, std_RR];
            labels = [labels; {'CHF'}];
            chf_count = chf_count + 1;  % Increment CHF count
        end
    end

    % Convert labels to numeric
    label_map = containers.Map({'SR', 'ARR', 'CHF'}, {1, 2, 3});
    numeric_labels = cellfun(@(x) label_map(x), labels);

    % Train Random Forest model with the features and labels
    model = TreeBagger(50, features, numeric_labels, 'Method', 'classification');

    % Display the number of signals used for training
    disp(['Number of SR signals used for training: ', num2str(sr_count)]);
    disp(['Number of ARR signals used for training: ', num2str(arr_count)]);
    disp(['Number of CHF signals used for training: ', num2str(chf_count)]);
    disp(['Total number of signals used for training: ', num2str(sr_count + arr_count + chf_count)]);

    % -----------------------------------------------------------------------
    % Now we will calculate the model's performance using test data
    
    % Initialize counters for correct and incorrect predictions
    correct_predictions = 0;
    total_predictions = 0;

    % Combine the training datasets into one signal dataset for testing
    combined_signal = [ECG_SR; ECG_ARR; ECG_CHF];  % Combining datasets for testing
    
    % Iterating through each signal in the combined signal dataset
    for signal_index = 1:size(combined_signal, 1)
        signal = combined_signal(signal_index, :);
        
        % Calculate the features for the current test signal
        if sampling_filtering
            % Perform sampling and filtering when sampling_filtering is true
            [y_s, y_t] = feierabend_philipp_sampling(signal, T, T_orig, k, false); 
            y_f = feierabend_philipp_filtering(y_s, y_t, false);
            % Proceed to heart rate calculation using the filtered signal
            [pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(y_f, y_t, false);
        else
            % Skip sampling and filtering, directly use the original signal
            [pulse, RR_intervals, avg_RR, max_RR, min_RR, std_RR] = feierabend_philipp_heartrate_modified(signal, t, false);
        end


        % Determine the true label for the test signal
        if signal_index <= size(ECG_SR, 1)
            dataset_label = 'SR';
        elseif signal_index <= size(ECG_SR, 1) + size(ECG_ARR, 1)
            dataset_label = 'ARR';
        else
            dataset_label = 'CHF';
        end
        
        % Display the current signal being processed
        disp(['Processing signal number: ', num2str(signal_index), ' with label: ', dataset_label]);

        % Classify the signal with the trained model
        diagnosis = feierabend_philipp_classification(RR_intervals, pulse, avg_RR, max_RR, min_RR, std_RR, dataset_label, model);

        % Compare the prediction with the actual label
        if strcmp(diagnosis, dataset_label)
            correct_predictions = correct_predictions + 1;
        end

        total_predictions = total_predictions + 1;
    end

    % Calculate accuracy
    accuracy = (correct_predictions / total_predictions) * 100;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%% Model Accuracy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp(['Model Accuracy: ', num2str(accuracy), '%']);
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%% Training Complete %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
    disp('The model is now ready.');
    disp('Test data can now be used for classification.');
    disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');

end

