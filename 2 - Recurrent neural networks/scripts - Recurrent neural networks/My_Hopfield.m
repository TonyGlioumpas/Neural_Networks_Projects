clc; clear; close all;

% Stable states / Attractors
T = [1 1; -1 -1; 1 -1]';

% The network "understands" how many neuron it needs from the Attractors
net = newhop(T);

% Example inputs
Ai = [0.3 0.6; -0.1 0.8; -1 0.5]';

% % Single step iteration
% Y = net([],[],Ai);

% Multiple Step iteration
num_step = 3
Y = net({num_step},{},Ai);


