function diagnosis = feierabend_philipp_classification(RR_intervals, pulse, avg_RR, max_RR, min_RR, std_RR, dataset_label, model)
    % Default diagnosis
    diagnosis = 'Unknown';  
    probability = zeros(1, 3);  % Array to hold probabilities for SR, CHF, ARR

    % Error checks for the input values
    if isempty(RR_intervals) || length(RR_intervals) < 2
        disp('Error: Not enough RR_intervals detected.');
        diagnosis = 'Error: Not enough RR_intervals';
        return;
    elseif isempty(pulse)
        disp('Error: pulse is empty.');
        diagnosis = 'Error: pulse is empty';
        return;
    elseif isempty(avg_RR)
        disp('Error: avg_RR is empty.');
        diagnosis = 'Error: avg_RR is empty';
        return;
    elseif isempty(max_RR)
        disp('Error: max_RR is empty.');
        diagnosis = 'Error: max_RR is empty';
        return;
    elseif isempty(min_RR)
        disp('Error: min_RR is empty.');
        diagnosis = 'Error: min_RR is empty';
        return;
    elseif isempty(std_RR)
        disp('Error: std_RR is empty.');
        diagnosis = 'Error: std_RR is empty';
        return;
    end

    % Check for NaN values in the input parameters
    if any(isnan([pulse, avg_RR, max_RR, min_RR, std_RR]))
        disp('Error: One or more input values are NaN.');
        diagnosis = 'Error: One or more input values are NaN';
        return;  % No classification if NaN values are present
    end

    % Output the features for debugging (optional)
    disp('Health Bot: Input features for classification:');
    disp(['Pulse: ', num2str(pulse)]);
    disp(['Avg RR: ', num2str(avg_RR)]);
    disp(['Max RR: ', num2str(max_RR)]);
    disp(['Min RR: ', num2str(min_RR)]);
    disp(['Std RR: ', num2str(std_RR)]);

    % Feature array for classification
    features = [pulse, avg_RR, max_RR, min_RR, std_RR];

    % Use the trained model for prediction
    try
        predicted_label = predict(model, features);  % Predicted label (numerical)
    catch
        disp('Error: Model prediction failed.');
        diagnosis = 'Error: Model prediction failed';
        return;
    end

    % Convert numeric predicted label to text label
    predicted_label_num = str2double(predicted_label{1});  % Convert string to number

    % Map the numeric predictions back to their corresponding labels
    label_map = {'SR', 'ARR', 'CHF'};
    predicted_label_str = label_map{predicted_label_num};

    % Always display the predicted label
    disp(['Health Bot: The predicted classification is: ', predicted_label_str]);

    % If the dataset label is 'unknown', output a specific message
    if strcmp(dataset_label, 'unknown')
        disp('Traindata: The classification is unknown, caused in testdata.');
    else
        % Compare classification with actual dataset label
        if strcmp(predicted_label_str, dataset_label)
            disp(['Traindata: The classification is correct! The dataset is: ', dataset_label]);
        else
            disp(['Traindata: The classification is incorrect. The correct dataset is: ', dataset_label]);
        end
    end

    % Return the predicted diagnosis
    diagnosis = predicted_label_str;
end
