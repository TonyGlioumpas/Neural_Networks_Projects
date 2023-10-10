function [X_hat] = reconstruct(Z,Et)
    E = Et';
    F = E; 
    X_hat_t = F*Z;    % X_hat: Reconstructed(uncompressed) dataset
    
    X_hat = X_hat_t';
end