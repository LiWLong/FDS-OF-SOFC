clear;
clc;
flag = 0; %0：不需要生产FC PLANT数据  1：需要
FSM_YUZHI = 0.03;TEST_YUZHI = 0.045;
time = 500;
%% PLANT MODEL
if flag == 1
    load('model_input.mat')
    Tao_H2 = 26.1;
    Tao_O2 = 2.91;
    Tao_H2O = 78.3;
    T_fc = 1375;
    N = 384;
    qin_H2_standard = 2.4;
    R_HO_standard = 1.144;
    qin_air_standard = qin_H2_standard/R_HO_standard/0.21;
    feature_model = zeros(500,5);
    R_HO = R_HO_standard;
    qin_air = qin_H2_standard/R_HO/0.21;
    qin_H2 = qin_H2_standard;
    I_pattern = model_in(:,1);
    for k = 1:1:length(I_pattern)
        I_fc = I_pattern(k);
        simOut = sim('SOFC');
        U = U_fc.data;
        U_out = U(length(U));
        Panode = P_anode.data;
        P_Anode = Panode(length(Panode));
        Pcathode = P_cathode.data;
        P_Cathode = Pcathode(length(Pcathode));
        feature_model(k,1) = qin_H2;
        feature_model(k,2) = qin_air;
        feature_model(k,3) = U_out*I_fc;
        feature_model(k,4) = P_Anode;
        feature_model(k,5) = P_Cathode;
    end 
    save('./data/feature_model.mat','feature_model')
    clc
    disp('feature_model has been created')
else
    load('./data/feature_model.mat')
end
load('./data/feature_simulate.mat')
feature_residual = abs(feature_simulate - feature_model);
save('./data/feature_residual.mat','feature_residual')


%% FSM构建
feature_residual_rate = abs(feature_residual./feature_simulate);
save('./data/feature_residual_rate.mat','feature_residual_rate')
residual_binary = zeros(500,5);
for i = 1:1:500
    for j = 1:1:5
        if feature_residual_rate(i,j) >= FSM_YUZHI
            residual_binary(i,j) = 1;
        end
    end
end
dec = zeros(500,1);
for i = 1:500
    dec(i,1) = residual_binary(i,1)*2^4 + residual_binary(i,2)*2^3 + residual_binary(i,3)*2^2 + residual_binary(i,4)*2^1 +residual_binary(i,5)*2^0;
end
fault_num = 1:500;
fault_num = fault_num';
figure('Color',[1 1 1]);
figure(1)
scatter(fault_num(1:100,:),dec(1:100,:),10,'filled','r');
hold on
scatter(fault_num(101:200,:),dec(101:200,:),10,'filled','b');
hold on
scatter(fault_num(201:300,:),dec(201:300,:),10,'filled','g');
hold on
scatter(fault_num(301:400,:),dec(301:400,:),10,'filled','y');
hold on
scatter(fault_num(401:500,:),dec(401:500,:),10,'filled','c');
xticks([50 150 250 350 450]);
xticklabels({'健康状态','重整器退化','空气泄漏','电堆退化','燃料泄漏'});
yticks([0 3 4 7 9 19 23]);
yticklabels({'[00000]','[00011]','[00100]','[00111]','[01001]','[10011]','[10111]'});
axis([0 500 0 25]);
ylabel('二进制特征向量')
saveas(gca,'./figure/FSM_fig.jpg');
fault = [0 23 9 4 7];

%% OA计算
residual_binary_OA = zeros(500,5);
for i = 1:1:500
    for j = 1:1:5
        if feature_residual_rate(i,j) >= TEST_YUZHI
            residual_binary_OA(i,j) = 1;
        end
    end
end
dec_OA = zeros(500,1);
for i = 1:500
    dec_OA(i,1) = residual_binary_OA(i,1)*2^4 + residual_binary_OA(i,2)*2^3 + residual_binary_OA(i,3)*2^2 + residual_binary_OA(i,4)*2^1 +residual_binary_OA(i,5)*2^0;
end
figure('Color',[1 1 1]);
figure(2)
dec_label = zeros(500,1);
dec_label(1:100,:) = fault(1);
dec_label(101:200,:) = fault(2);
dec_label(201:300,:) = fault(3);
dec_label(301:400,:) = fault(4);
dec_label(401:500,:) = fault(5);
rigth_num = zeros(500,1);
for i = 1:500
    if dec_OA(i,1) == dec_label(i,1)
        scatter(fault_num(i),dec_OA(i),10,'filled','g')
        rigth_num(i,1) = 1;
        hold on
    else
        scatter(fault_num(i),dec_OA(i),10,'filled','r')
        hold on        
    end
end
xticks([50 150 250 350 450]);
xticklabels({'健康状态','重整器退化','空气泄漏','电堆退化','燃料泄漏'});
yticks([0 4 7 9 23]);
yticklabels({'[00000]','[00100]','[00111]','[01001]','[10011]'});
axis([0 500 0 25]);
ylabel('二进制特征向量')
saveas(gca,'./figure/model_base_FDI.jpg');
OA = sum(rigth_num)/500;
PA = zeros(5,2);
PA(:,2) = OA;
for i = 1:5
    PA(i,1) = sum(rigth_num(100*i-99:100*i,1))/100;
end
disp(['OA = ',num2str(OA)])
disp(PA);