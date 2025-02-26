function result_ann = fuzzy_classifier(train_data, train_class, test_data)
    % Suppress display options for genfis2 and anfis
    displayopt(1) = 0;
    displayopt(2) = 0;
    displayopt(3) = 0;
    displayopt(4) = 0;

    % Number of iterations for anfis training
    no_of_iter = 20;

    % Generate initial fuzzy inference system (FIS) using fuzzy subtractive clustering
    fuzzy_struct_crt = genfis2(train_data, train_class, 0.5);

    % Train the FIS using ANFIS
    fuzzy_final = anfis([train_data, train_class], fuzzy_struct_crt, no_of_iter, displayopt);

    % Make predictions on test data
    res_out = evalfis(test_data, fuzzy_final);

    % Round the output and scale to percentage
    result_ann = round(res_out * 100);

    % Handle out-of-range values
    loc = find(result_ann < 1 | result_ann > 3);
    result_ann(loc) = 1;
    

end
