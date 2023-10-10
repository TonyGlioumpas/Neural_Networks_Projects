clc; clear; close all;

load threes -ascii;

image_index = 2

imgs = [ ];
for q=[1 2 3 50]
    [Z,Et] = compress(threes,q);
    [X_hat] = reconstruct(Z,Et);
%     figure
%     colormap('gray');
%     imagesc(reshape(X_hat(1,:),16,16),[0,1])

    imgs = [imgs; X_hat(image_index,:)];
end

for i=1:1:4
    %figure
    colormap('gray');
    subplot(1,5,i)
    imagesc(reshape(imgs(i,:),16,16),[0,1])
    hold on
    axis off
end

% Add the original image for comparison
colormap('gray');
subplot(1,5,5)
imagesc(reshape(threes(image_index,:),16,16),[0,1])
hold on
axis off

