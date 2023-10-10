clc; clear; close all;

% Open training data file
fid = fopen('lasertrain.dat','rt');
train_data = textscan(fid, '%f');
train_data = train_data{1};
fclose(fid);

% Open training data file
fid2 = fopen('laserpred.dat','rt');
test_data = textscan(fid2, '%f');
test_data = test_data{1};
fclose(fid2);

% % Plot original dataset
% figure
% plot(train_data);
% title("original train data")
% 
% % Plot test set
% figure
% plot(test_data);
% title("original test data")

%Normalizing datasets (data standardization)
norm_train_data = normalize(train_data,'range');
norm_test_data = normalize(test_data,'range');

% % Plot normalized training set
% figure
% plot(norm_train_data);
% title("norm train data")
% 
% % Plot normalized test set
% figure
% plot(norm_test_data);
% title("norm test data")

% Add this plot to the report to show where the test set starts.
complete_dataset = [norm_train_data' norm_test_data'];
figure
plot(complete_dataset);
xline(1000,'LineStyle','-.','Color','red','LabelVerticalAlignment','middle','LineWidth',2)
title("Complete Dataset (Train & Test)")


% Getting target and training data with lag
max_lag = 35;
errors = zeros(1,35);

for i=1:max_lag
    
    [training, target_train] = getTimeSeriesTrainData(norm_train_data, i);
    
    % Formatting training data for train function
    train_set = cell(i,1);
    
    for j=1:i
        train_set{j,1} = training(j,:);
    end
    
    % Configuring and training the network
    layers = [60];
    net = feedforwardnet(layers, 'trainbr');
    net.numInputs = i;
    net.trainParam.epochs = 100;
    net.divideFcn = 'dividerand';
    %net.divideParam.trainRatio = 0.7;
    %net.divideParam.valRatio = 0.15;
    %net.divideParam.testRatio = 0.15;
    %net.trainParam.max_fail = 100;
    for j=1:i
        net.inputs{j}.size = 1;
        net.inputConnect(1,j) = 1;
    end
    
    [net,tr] = train(net, train_set, target_train);
    
    % Getting target and test data with lag
    [test, target_predict] = getTimeSeriesTrainData(norm_test_data, i);
    
    prediction = zeros(1,100-i);
    x = test(:,1);
    
    for j=1:100-i
        y = net(x);
        prediction(1, j) = y;
        x = vertcat(x(2:end),y);
    end
    
    error = mean((prediction - target_predict).^2);
    errors(i) = error;
end

plot(errors)
xlabel('Lag') 
ylabel('MSE') 

figure 
plot(prediction);
hold on;
plot(target_predict);
legend('prediction','target');
hold off;