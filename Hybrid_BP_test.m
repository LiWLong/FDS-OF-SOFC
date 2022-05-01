clear;clc
load feature_residual.mat
load model_input.mat
load Hybrid_BP_net.mat

fault_num = model_in(:,2);
test_residual_standard = zeros(500,5);
for i = 1:5
    test_residual_standard(:,i) = zscore(feature_residual(:,i));
end

Y = sim(net,test_residual_standard');
[s1,s2]=size(Y);
outputlist=[];
hitNum=0;
for i=1:s2
    [m,Index]=max(Y(:,i));
    outputlist(i)=Index;
    if(Index == (fault_num(i)+1))
        hitNum=hitNum+1;
    end
end
OA = hitNum/500
PA = zeros(5,1);
right_num = zeros(500,1);
outputlist = outputlist - 1;
for i =1:500
    if model_in(i,2) == outputlist(i)
        right_num(i,1) = 1;
    end
end
for i = 1:5
    PA(i,1) = sum(right_num(100*i-99:100*i,1))/100;
end
disp('PA is fellowed:')
disp(PA);

dec_label(1:100,:) = 0;
dec_label(101:200,:) = 1;
dec_label(201:300,:) = 2;
dec_label(301:400,:) = 3;
dec_label(401:500,:) = 4;
figure('Color',[1 1 1]);
for i = 1:500
    if outputlist(i) == dec_label(i,1)
        scatter(i,outputlist(i),10,'filled','g')
        hold on
    else
        scatter(i,outputlist(i),10,'filled','r')
        hold on        
    end
end
xticks([50 150 250 350 450]);
xticklabels({'健康状态','重整器退化','空气泄漏','电堆退化','燃料泄漏'});
yticks([0 1 2 3 4]);
yticklabels({'0','1','2','3','4'});
ylabel('故障种类')
saveas(gca,'./figure/Hybrid_BP_Net_FDI.jpg');