clear;clc
load training_data.mat
sets_num = size(training_data,1);
load('./data/feature_model.mat');
traindata = zeros(sets_num*500,5);
for i = 1:sets_num
    traindata(500*i-499:500*i,:) = training_data{i,1};
end

% ���ݹ�һ��
traindata_standard = zeros(sets_num*500,5);
for i = 1:5
    traindata_standard(:,i) = zscore(traindata(:,i));
end
fault_num = zeros(sets_num*500,1);
for i = 1:sets_num
    fault_num(500*i-499:500*i,:) = training_data{i,2}(:,2);
end

% �������
s=length(fault_num);
output=zeros(s,5); 
for i=1:s
    output(i,(fault_num(i)+1))=1;
end

net=newff(traindata_standard',output',[11,4],{'tansig' 'tansig'},'traingdx');

net.trainparam.show = 50 ;    % ÿ���500����ʾһ��ѵ�����
net.trainparam.epochs = 1000000 ;  %�������ѵ������
net.trainparam.goal = 0.001 ;   %ѵ��Ŀ����С���0.01
net.trainParam.lr = 0.01 ;   %ѧϰ����0.05

net = train(net,traindata_standard',output');
save('./data/BP_net.mat','net')
disp('BP net is trained.')