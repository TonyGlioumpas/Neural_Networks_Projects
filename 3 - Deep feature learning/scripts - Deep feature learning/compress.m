function [Z,Et] = compress(dataset,q)
    % q: number of Principal Components here

    X = dataset;    % Initial dataset

    % 1) Compute mean row
    mu_dataset = mean(X);
    
    % 2) Create the mean centered dataset B by subtracting mean of each column
    % of the dataset from each row.
    B = X - mu_dataset*ones(length(mu_dataset)); 
    
    p = 256; % dimensionality of the original dataset
    
    % 3) Calculate C: covariance matrix of rows of B
    C = cov(X);
    
    % 4) Compute eigs of C
    [V,D] = eigs(C,p);
    % The largest eigenvalues in D are in the diagonal in decending order
    
    T = B*V;    % Principal components
    
    % Plot the eigenvalues 
    % figure
    % area(diag(EigenValues))
    
    % Compress the dataset
    E = V(:,1:q); % first q columns of the eigenvectors (V) of the covariance matrix (C) compose E
    Et = E';
    
    Z = Et*X';  % Z: Compressed Dataset 

end