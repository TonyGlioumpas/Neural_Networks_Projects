% Perform PCA on handwritten images of the digit 3 taken from the US Postal Service database.
% To access these images, load the Matlab data called threes.mat by typing load threes -ascii. 
% This loads a 2 megabyte 500 × 256 matrix called threes. 
% Each line of this matrix is a single 16 by 16 image of a handwritten 3 that has been expanded out into a 256 long vector. 
% You can look at the i-th image by typing the command imagesc(reshape(threes(i,:),16,16),[0,1]). 
% To have a black-white picture use the command colormap(’gray’) first.  
clc; clear; close all;

load threes -ascii;
colormap('gray');
imagesc(reshape(threes(1,:),16,16),[0,1])
title("first image of the dataset")
axis off


%Compute the mean 3 and display it. Take a look at the command mean for this  
figure
colormap('gray');
imagesc(reshape(mean(threes),16,16),[0,1])
title("mean 3 image of the dataset")
axis off


% Compute the covariance matrix of the whole dataset of 3s (note that the Matlab function cov subtracts the mean automatically, subtracting it beforehand is not incorrect however). 
% Compute the eigenvalues and eigenvectors of this covariance matrix. 
% Plot the eigenvalues (plot(diag(D) where D is the diagonal matrix of eigenvalues)

X = threes;    % Initial dataset

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
figure
area(diag(D))
xline(50,'--r')
grid on
xlabel("EigenValues indexes")
ylabel("EigenValues values")

% Compress the dataset
q = 4; % Define number of Principal Components here
E = V(:,1:q); % first q columns of the eigenvectors (V) of the covariance matrix (C) compose E
Et = E';

Z = Et*X';  % Z: Compressed Dataset 

% ----------------------------------------------------------------
% Reconstruct(Uncompress) the compressed dataset
F = E; 
X_hat_t = F*Z;    % X_hat: Reconstructed(uncompressed) dataset

X_hat = X_hat_t';

figure
colormap('gray');
imagesc(reshape(X_hat(1,:),16,16),[0,1])

% Measure reconstruction error
error = mse(X,X_hat);

eigenvalues = diag(D);

eigs_rev = eigenvalues(end:-1:1);

%cum_sum = cumsum(eigs_rev(1:50));
cum_sum = cumsum(eigenvalues(1:50));


figure
plot(cum_sum)
xline(50,'--r')
grid on
ylabel("Cumulative sum")
xlabel("EigenValues indexes")
