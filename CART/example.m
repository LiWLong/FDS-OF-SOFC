clear;clc

load model_input.mat
load feature_residual.mat
fault_num = model_in(:,2);
residual_standard = zeros(400,5);
for i = 1:5
    residual_standard(:,i) = zscore(feature_residual(:,i));
end
% Training Forest
maxGiniImpurity = 0.1; % 基尼纯度不能设置太低，不然会陷入无限循环
numOfTree = 400;
baggingSampleSize = 300; % 在总训练集中随机选取400个样本构建树
%numRandFeatures = floor(sqrt(5)); % floor(x) 函数向下取整；ceil(x) 函数向上取整；round(x) 函数取最接近的整数
numRandFeatures = 2;
train_data_split = true;
    
RF_model = trainForest(residual_standard, fault_num, maxGiniImpurity, numOfTree, ...
baggingSampleSize, numRandFeatures, train_data_split);
disp('Forest is trained.')

outputlist = zeros(400,1);
for key = 1:400    
    T = testData(RF_model,residual_standard(key,:));
    outputlist(key,1) = leafLabelDistri(T);
end

sum = 0;
for i =1:400
    if model_in(i,2) == outputlist(i)
        sum = sum+1;
    end
end
OA = sum/400