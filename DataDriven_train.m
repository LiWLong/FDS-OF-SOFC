clear;clc
load training_data.mat
sets_num = size(training_data,1);
load('./data/feature_model.mat');
traindata = zeros(sets_num*500,5);
for i = 1:sets_num
    traindata(500*i-499:500*i,:) = training_data{i,1};
end
traindata_standard = zeros(sets_num*500,5);
for i = 1:5
    traindata_standard(:,i) = zscore(traindata(:,i));
end
fault_num = zeros(sets_num*500,1);
for i = 1:sets_num
    fault_num(500*i-499:500*i,:) = training_data{i,2}(:,2);
end

% Training Forest
maxGiniImpurity = 0.01; % ���ᴿ�Ȳ�������̫�ͣ���Ȼ����������ѭ��
numOfTree = 10;
baggingSampleSize = 800; % ����ѵ���������ѡȡ���ٸ�����������
%numRandFeatures = floor(sqrt(5)); % floor(x) ��������ȡ����ceil(x) ��������ȡ����round(x) ����ȡ��ӽ�������
numRandFeatures = 4;
train_data_split = true;

DataDriven_RF_model = trainForest(traindata_standard, fault_num, maxGiniImpurity, numOfTree, ...
baggingSampleSize, numRandFeatures, train_data_split);
save('./data/DataDriven_RF_model.mat','DataDriven_RF_model')
disp('Forest is trained.')