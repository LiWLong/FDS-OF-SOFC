clear;clc
load RF_model.mat
load feature_residual.mat
load model_input.mat

test_residual_standard = zeros(500,5);
for i = 1:5
    test_residual_standard(:,i) = zscore(feature_residual(:,i));
end

outputlist = zeros(500,1);
for key = 1:500    
    T = testData(RF_model,test_residual_standard(key,:));
    outputlist(key,1) = leafLabelDistri(T);
end

right_num = zeros(500,1);
for i =1:500
    if model_in(i,2) == outputlist(i)
        right_num(i,1) = 1;
    end
end
OA = sum(right_num)/500
PA = zeros(5,2);
PA(:,2) = OA;
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
    if outputlist(i,1) == dec_label(i,1)
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
saveas(gca,'./figure/model_RF_FDI.jpg');
