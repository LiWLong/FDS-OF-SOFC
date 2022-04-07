clear;clc

load model_input.mat
load feature_residual.mat
fault_num = model_in(:,2);
residual_standard = zeros(400,5);
for i = 1:5
    residual_standard(:,i) = zscore(feature_residual(:,i));
end
% Training Forest
maxGiniImpurity = 0.1; % ���ᴿ�Ȳ�������̫�ͣ���Ȼ����������ѭ��
numOfTree = 400;
baggingSampleSize = 300; % ����ѵ���������ѡȡ400������������
%numRandFeatures = floor(sqrt(5)); % floor(x) ��������ȡ����ceil(x) ��������ȡ����round(x) ����ȡ��ӽ�������
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