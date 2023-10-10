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

% Format training data 
p = 100 % model lag
[TrainData, TrainTarget] = getTimeSeriesTrainData(norm_train_data, p);

epochs = 30;
alg1 = "trainlm";
hidden = 40;

net1=feedforwardnet(hidden,alg1);% Define the feedfoward net (hidden layers)
net1=configure(net1,TrainData,TrainTarget);% Set the input and output sizes of the net
net1=init(net1);% Initialize the weights (randomly)

%training and simulation
net1.trainParam.epochs=epochs;  % set the number of epochs for the training 
%net1.trainParam.max_fail = 10;
net1.divideParam.trainRatio = 0.80;
net1.divideParam.valRatio = 0.10;
net1.divideParam.testRatio = 0.10;

[net1,TR] = train(net1,TrainData,TrainTarget);   % train the networks

% First prediction
[tr_rows, tr_cols] = size(TrainData);
pred1 = sim(net1,[TrainData(tr_rows,(end-p+1):end)]');

predictions = pred1;

for i=1:1:(p-1)  % 100 predictions, therefore 100 iterations
    input = [TrainData(i,(end-p+1+i):end) predictions];  % the input of the network must contain 
    pred = sim(net1,input');  % simulate the networks with the input vector
    predictions = [predictions pred];
end


figure
plot(predictions)
hold on
plot(norm_test_data)
title("Predictions")
