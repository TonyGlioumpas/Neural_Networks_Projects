% Open training data file
fid = fopen('lasertrain.dat','rt');
data = textscan(fid, '%f');
data = data{1};
fclose(fid);

figure
plot(data)
xlabel("Observations")
ylabel("Values")
title("Santa Fe data set")

% Open test data file
fid2 = fopen('laserpred.dat','rt');
test_data = textscan(fid2, '%f');
test_data = test_data{1};
fclose(fid2);


% Partition the training and test data. Train on the first 90% of the sequence and test on the last 10%.
numTimeStepsTrain = floor(0.9*numel(data));

dataTrain = data(1:numTimeStepsTrain+1);
dataTest = data(numTimeStepsTrain+1:end);

% Standardize Train Data
mu = mean(dataTrain);
sig = std(dataTrain);

dataTrainStandardized = (dataTrain - mu) / sig;


% Prepare Predictors and Responses

XTrain = dataTrainStandardized(1:end-1);  % values of each time step of the input sequence
YTrain = dataTrainStandardized(2:end);  % next steps - targets

% Define LSTM regression Network Architecture
numFeatures = 1;
numResponses = 1;
numHiddenUnits = 200;

layers = [  sequenceInputLayer(numFeatures)
            lstmLayer(numHiddenUnits)
            fullyConnectedLayer(numResponses)
            regressionLayer];

options = trainingOptions('adam', ...
    'MaxEpochs',250, ...
    'GradientThreshold',1, ...
    'InitialLearnRate',0.005, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropPeriod',125, ...
    'LearnRateDropFactor',0.2, ...
    'Verbose',0, ...
    'Plots','training-progress');

% Train LSTM Network
net = trainNetwork(XTrain',YTrain',layers,options);

% Forecast Future Time Steps
dataTestStandardized = (dataTest - mu) / sig;
XTest = dataTestStandardized(1:end-1);


% Network training
[net, Y] = predictAndUpdateState(net, X); 

% computes predictions of the network net on the data X, and updates the state of the network net.
net = predictAndUpdateState(net,XTrain');
[net,YPred] = predictAndUpdateState(net,YTrain(end));

% Predict Values (YPred will hold the predicted values)
% numTimeStepsTest = numel(XTest);
% for i = 2:numTimeStepsTest
%     [net,YPred(:,i)] = predictAndUpdateState(net,YPred(:,i-1),'ExecutionEnvironment','cpu');
% end


%Unstandardize the predictions using the parameters calculated earlier.
% YPred = sig*YPred + mu;

%The training progress plot reports the root-mean-square error (RMSE) calculated from the standardized data. 
% Calculate the RMSE from the unstandardized predictions.
% YTest = dataTest(2:end);
% rmse = sqrt(mean((YPred-YTest).^2));

% % Plot the training time series with the forecasted values.
% figure
% plot(dataTrain(1:end-1))
% hold on
% idx = numTimeStepsTrain:(numTimeStepsTrain+numTimeStepsTest);
% plot(idx,[data(numTimeStepsTrain) YPred],'.-')
% hold off
% xlabel("Observations")
% ylabel("Laser Measurement Values")
% title("Forecast of last training set data (split as test data)")
% legend(["Observed" "Forecast"])

% 
% % Compare the forecasted values with the test data.
% figure
% subplot(2,1,1)
% plot(YTest)
% hold on
% plot(YPred,'.-')
% hold off
% legend(["Observed" "Forecast"])
% ylabel("Laser Measurement Values")
% title("Forecast")
% 
% subplot(2,1,2)
% stem(YPred - YTest)
% xlabel("Observations")
% ylabel("Error")
% title("RMSE = " + rmse)




% Update Network State with Observed Values
net = resetState(net);
net = predictAndUpdateState(net,XTrain);

% Predict on each time step.
YPred = [];
numTimeStepsTest = numel(XTest);
for i = 1:numTimeStepsTest
    [net,YPred(:,i)] = predictAndUpdateState(net,XTest(:,i),'ExecutionEnvironment','cpu');
end

% Unstandardize the predictions using the parameters calculated earlier.
YPred = sig*YPred + mu;

% Calculate the root-mean-square error (RMSE).
rmse = sqrt(mean((YPred-YTest).^2));


figure
subplot(2,1,1)
plot(YTest)
hold on
plot(YPred,'.-')
hold off
legend(["Observed" "Predicted"])
ylabel("Laser Measurement Values")
title("Forecast with Updates")

subplot(2,1,2)
stem(YPred - YTest)
xlabel("Observations")
ylabel("Error")
title("RMSE = " + rmse)









