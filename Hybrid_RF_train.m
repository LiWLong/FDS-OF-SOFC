clear;clc
load train_residual_standard.mat
load model_input.mat
fault_num1 = model_in(:,2);
%sets_num = size(train_residual_standard,1)/500;
fault_num = [fault_num1;fault_num1];

% Training Forest
maxGiniImpurity = 0.01; % 基尼纯度不能设置太低，不然会陷入无限循环
numOfTree = 10;
baggingSampleSize = 800; % 在总训练集中随机选取多少个样本构建树
%numRandFeatures = floor(sqrt(5)); % floor(x) 函数向下取整；ceil(x) 函数向上取整；round(x) 函数取最接近的整数
numRandFeatures = 3;
train_data_split = true;

RF_model = trainForest(train_residual_standard, fault_num, maxGiniImpurity, numOfTree, ...
baggingSampleSize, numRandFeatures, train_data_split);
save('./data/RF_model.mat','RF_model')
disp('Forest is trained.')