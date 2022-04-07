function [ headNodeList ] = trainForest( data, labels, maxImp, ...
    numOfTree, trainingdataSize, numRandFeatures,train_data_split)
% This function trains a random forest returns head/root node list of each tree
% trainingdataSize Ϊ�����ݼ��������ȡ������ѵ�������ݵĸ���
% Prepairing training data for each tree


if train_data_split
    [dataList, labelList] = Bagging(data, labels, trainingdataSize, numOfTree); % ��������ָ����ݣ����ѵ�������ݼ�
else
    
    dataList = cell(1,numOfTree);
    labelList = cell(1,numOfTree);
    for i=1:numOfTree
        random = randi(length(data),1,length(data)); %����һ�� �ɽ���1��length(data) ֮���α�������ɵ� 1*trainingSetSize ����
        dataList{i}= data(random,:);
        labelList{i} = labels(random);
    end
end
% Empty head nodes of each tree
headNodeList = headNodes(numOfTree);

% Training each tree
for i=1:numOfTree
    constructNode(headNodeList{i}, dataList{i}, labelList{i}, maxImp, ...
        numRandFeatures);
end
end