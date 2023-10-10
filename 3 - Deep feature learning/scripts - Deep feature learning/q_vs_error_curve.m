clc; clear; close all;

load threes -ascii;

errors = [ ];
num_of_PCs = [ ];
for q=1:1:50
    err = Reconstruction_Error(threes,q);
    errors = [errors err];
    num_of_PCs = [num_of_PCs q];
end

plot(num_of_PCs,errors)
xlabel("number of principal components")
ylabel("Mean squared error")
title("MSE as a function of q")
grid on

disp(["For q= 256 the reconstruction error MSE is: ",...
    Reconstruction_Error(threes,256)])