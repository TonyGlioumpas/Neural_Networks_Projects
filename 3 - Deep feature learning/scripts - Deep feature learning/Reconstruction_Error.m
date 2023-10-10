function error = Reconstruction_Error(dataset,q)
    [Z,Et] = compress(dataset,q);
    [X_hat] = reconstruct(Z,Et);
    error = mse(dataset,X_hat);
end