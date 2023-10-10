clear all
close all
%nntraintool('close');
nnet.guis.closeAllViews();

% Neural networks have weights randomly initialized before training.
% Therefore the results from training are different each time. To avoid
% this behavior, explicitly set the random number generator seed.
rng('default')

% Load the training data into memory
load('digittrain_dataset.mat');

% __________________________________________________________________
% Layer 1 
hiddenSize1 = 100;

% Train in feedforward mode, only inputs are used
autoenc1 = trainAutoencoder(xTrainImages,hiddenSize1, ...
    'MaxEpochs',400, ...
    'L2WeightRegularization',0.004, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.15, ...
    'ScaleData', false);

figure;
plotWeights(autoenc1);
feat1 = encode(autoenc1,xTrainImages);
pause;

% __________________________________________________________________
% Layer 2 
hiddenSize2 = 50;

% Train in feedforward mode, only inputs from Layer 1 are used
autoenc2 = trainAutoencoder(feat1,hiddenSize2, ...
    'MaxEpochs',100, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.1, ...
    'ScaleData', false);

feat2 = encode(autoenc2,feat1);
pause;

% __________________________________________________________________
% Layer 3
softnet = trainSoftmaxLayer(feat2,tTrain,'MaxEpochs',400);

% __________________________________________________________________
% Deep Net
deepnet = stack(autoenc1,autoenc2,softnet);


% __________________________________________________________________
% Test deep net
imageWidth = 28;
imageHeight = 28;
inputSize = imageWidth*imageHeight;
load('digittest_dataset.mat');
xTest = zeros(inputSize,numel(xTestImages));
for i = 1:numel(xTestImages)
    xTest(:,i) = xTestImages{i}(:);
end
y = deepnet(xTest);
figure;
plotconfusion(tTest,y);
classAcc_DN = 100*(1-confusion(tTest,y))

% __________________________________________________________________
% Test fine-tuned deep net
xTrain = zeros(inputSize,numel(xTrainImages));
for i = 1:numel(xTrainImages)
    xTrain(:,i) = xTrainImages{i}(:);
end

deepnet = train(deepnet,xTrain,tTrain);   % Since the tTrain targets are
                                          % used, backpropagation occurs 
y_DN = deepnet(xTest);
figure;
plotconfusion(tTest,y_DN);
classAcc_FT = 100*(1-confusion(tTest,y_DN))
view(deepnet)

% __________________________________________________________________
%Compare with normal neural network (1 hidden layers)
net_N1 = patternnet(100);    % Takes a row vector of N hidden layer sizes 
                             % and a backpropagation training function and
                       % returns an N+1 layer pattern recognition network.
[net_N1,TR_N1] = train(net_N1,xTrain,tTrain);  % tTrain: targets of training set
                               % backpropagation takes place here
y_N1 = net_N1(xTest);          % predict targets of test set inputs
plotconfusion(tTest,y_N1);
classAcc_N1 = 100*(1-confusion(tTest,y_N1))
view(net_N1)

% __________________________________________________________________
%Compare with normal neural network (2 hidden layers)
net_N2 = patternnet([100 50]);
[net_N2,TR_N2] =train(net_N2,xTrain,tTrain);
y_N2 = net_N2(xTest);
plotconfusion(tTest,y_N2);
classAcc_N2 = 100*(1-confusion(tTest,y_N2))
view(net_N2)