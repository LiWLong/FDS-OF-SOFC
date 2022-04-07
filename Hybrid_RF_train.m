clear;clc
load train_residual_standard.mat
load model_input.mat
fault_num1 = model_in(:,2);
%sets_num = size(train_residual_standard,1)/500;
fault_num = [fault_num1;fault_num1];

% Training Forest
maxGiniImpurity = 0.01; % ���ᴿ�Ȳ�������̫�ͣ���Ȼ����������ѭ��
numOfTree = 10;
baggingSampleSize = 800; % ����ѵ���������ѡȡ���ٸ�����������
%numRandFeatures = floor(sqrt(5)); % floor(x) ��������ȡ����ceil(x) ��������ȡ����round(x) ����ȡ��ӽ�������
numRandFeatures = 3;
train_data_split = true;

RF_model = trainForest(train_residual_standard, fault_num, maxGiniImpurity, numOfTree, ...
baggingSampleSize, numRandFeatures, train_data_split);
save('./data/RF_model.mat','RF_model')
disp('Forest is trained.')