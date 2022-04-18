clear;clc
load train_residual_standard.mat
load model_input.mat
fault_num1 = model_in(:,2);
fault_num = [fault_num1;fault_num1];

% 输出矩阵
s=length(fault_num);
output=zeros(s,5); 
for i=1:s
    output(i,(fault_num(i)+1))=1;
end

net=newff(train_residual_standard',output',[11,4],{'tansig' 'tansig'},'traingdx');

net.trainparam.show = 50 ;    % 每间隔500步显示一次训练结果
net.trainparam.epochs = 1000000 ;  %允许最大训练步数
net.trainparam.goal = 0.001 ;   %训练目标最小误差0.01
net.trainParam.lr = 0.01 ;   %学习速率0.05

net = train(net,train_residual_standard',output');
save('./data/Hybrid_BP_net.mat','net')
disp('BP net is trained.')