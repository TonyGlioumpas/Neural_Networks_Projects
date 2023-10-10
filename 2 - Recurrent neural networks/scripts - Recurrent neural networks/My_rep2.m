%%%%%%%%%%%
% rep2.m
% A script which generates n random initial points 
% and visualises results of simulation of a 2d Hopfield network 'net'
%%%%%%%%%%
clc;clear;close all;

T = [1 1; -1 -1; 1 -1]';

net = newhop(T);

% Nunmber of points
n=1000;
iterations = [ ];

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
    [y,Pf,Af] = sim(net,{1 50},{},a);   % simulation of the network for 50 timesteps (for the point created above)              
    
    % Records the trajectory of the point step by step (red line)
    record=[cell2mat(a) cell2mat(y)];   % formatting results / append value
    % Initial position
    start=cell2mat(a);                  % formatting results 

    % When the out put of the network stops changing for a given input
    % point, it means that an attractor has been found.
    % Count the number of iterations needed until an attractor is found.
    for i=1:length(y)-1
        if y{i+1}==y{i}
            break;           
        end
    end
    iterations = [iterations i];

    plot(start(1,1),start(2,1),'bx',record(1,:),record(2,:),'r'); % plot evolution
    hold on;
    plot(record(1,50),record(2,50),'gO');  % plot the final point with a green circle
end
legend('initial state','time evolution','attractor','Location', 'northeast');
title('Time evolution in the phase space of 2d Hopfield model');

% Histogram of iterations needed until the network reaches a stable point
% (#iterations - num of points)
figure
histogram(iterations)
title('Iterations needed to reach a stable point');
xlabel("Number of points");
ylabel("Number of iterations");

