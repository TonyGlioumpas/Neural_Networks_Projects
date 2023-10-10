%%%%%%%%%%%
% rep2.m
% A script which generates n random initial points 
% and visualises results of simulation of a 2d Hopfield network 'net'
%%%%%%%%%%
clc;clear;close all;

T = [1 1; -1 -1; 1 -1]';

net = newhop(T);

% Nunmber of points
n=100;

for i=1:n

    % generate an initial point
    if i==1
       a = {[0;0]}; 
    elseif i==2
       a = {[1;0]};
    else
       a = {rands(2,1)};
    end
               
    disp(a)
    [y,Xf,Af] = sim(net,{1 50},{},a);   % simulation of the network for as many timesteps needed (for the point created above)              
    
    % Records the trajectory of the point step by step (red line)
    record=[cell2mat(a) cell2mat(y)];   % formatting results 
    disp(["Length of record: " length(record)]);

    % Initial points
    start=cell2mat(a);                  % formatting results 

    plot(start(1,1),start(2,1),'bx',record(1,:),record(2,:),'r'); % plot evolution
    hold on;
    plot(record(1,length(record)),record(2,length(record)),'gO');  % plot the final point with a green circle
end
legend('initial state','time evolution','attractor','Location', 'northeast');
title('Time evolution in the phase space of 2d Hopfield model');


% Histogram of iterations needed until the network reaches a stable point
% (#iterations - num of points)

