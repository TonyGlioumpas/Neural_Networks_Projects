%%%%%%%%%%%
% rep3.m
% A script which generates n random initial points for
% and visualise results of simulation of a 3d Hopfield network net
%%%%%%%%%%
T = [1 1 1; -1 -1 1; 1 -1 -1]';
net = newhop(T);

n=20;
iterations = [ ];

for i=1:n
    a={rands(3,1)};                         % generate an initial point                   
    [y,Pf,Af] = sim(net,{1 50},{},a);       % simulation of the network  for 50 timesteps
    record=[cell2mat(a) cell2mat(y)];       % formatting results
    start=cell2mat(a);                      % formatting results 

    % When the out put of the network stops changing for a given input
    % point, it means that an attractor has been found.
    % Count the number of iterations needed until an attractor is found.
    for i=1:length(y)-1
        if y{i+1}==y{i}
            break;           
        end
    end
    iterations = [iterations i];


    plot3(start(1,1),start(2,1),start(3,1),'bx',record(1,:),record(2,:),record(3,:),'r');  % plot evolution
    hold on;
    plot3(record(1,50),record(2,50),record(3,50),'gO');  % plot the final point with a green circle
end
grid on;
legend('initial state','time evolution','attractor','Location', 'northeast');
title('Time evolution in the phase space of 3d Hopfield model');

% Histogram of iterations needed until the network reaches a stable point
% (#iterations - num of points)
figure
histogram(iterations)
title('Iterations needed to reach a stable point');
xlabel("Number of points");
ylabel("Number of iterations");