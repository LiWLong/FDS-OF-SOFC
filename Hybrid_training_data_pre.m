clear;clc
load training_data.mat
sets_num = size(training_data,1);
load('./data/feature_model.mat');
traindata_residual = zeros(sets_num*500,5);
for i = 1:sets_num
    residual = (training_data{i,1} - feature_model);
    traindata_residual(500*i-499:500*i,:) = abs(residual);
end
train_residual_standard = zeros(500*sets_num,5);
for i = 1:5
    train_residual_standard(:,i) = zscore(traindata_residual(:,i));
end
save('./data/train_residual_standard.mat','train_residual_standard')