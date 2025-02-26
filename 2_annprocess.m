function result_ann = ann_process(train_data, train_class, test_data)
    % Create a feedforward neural network
    network_form = newcf(train_data', train_class', [20 20], {'logsig', 'purelin'});
    
    % Set training parameters
    network_form.trainparam.epochs = 1000;  % Number of training epochs
    network_form.trainparam.goal = 0.00001; % Training goal
    
    % Train the neural network
    network_form = train(network_form, train_data', train_class');
    
    % Make predictions on test data
    res_out = sim(network_form, test_data');
    
    % Round the output and scale to percentage
    result_ann = round(res_out * 100);
    
    % Handle out-of-range values
    loc = find(result_ann < 1 | result_ann > 3);
    result_ann(loc) = 1;
end