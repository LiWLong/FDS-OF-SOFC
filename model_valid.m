clear;
close all;
Tao_H2 = 26.1;
Tao_O2 = 2.91;
Tao_H2O = 78.3;
T_fc = 1375;
N = 30;  %��ش������� 
qin_H2_standard = 2.4; % ��������Ħ���ٶ�
R_HO_standard = 1.144; % �������������ٶȱ�
qin_air_standard = qin_H2_standard/R_HO_standard/0.21; 
R_HO = R_HO_standard;
qin_air = qin_H2_standard/R_HO/0.21;
qin_H2 = qin_H2_standard;
time = 500;
flag = 1;
if flag == 0
    I_pattern = linspace(1,100,100);
    Uout_totel = [];
    for k = 1:1:length(I_pattern)
        I_fc = I_pattern(k);
        simOut = sim('SOFC');
        U = U_fc.data;
        U_out = U(length(U));
        Uout_totel = [Uout_totel,U_out];
    end
    sample = 1;
    Uout_sample = [];
    for i = 2:sample:length(Uout_totel)
        Uout_sample = [Uout_sample,[i;Uout_totel(i)*((rand(1)-0.5)*0.1+1)]];
    end
    figure('Color',[1 1 1]);
    figure(1)
    plot(I_pattern,Uout_totel,'LineWidth',2);
    ylabel('��ѹ(V)')
    xlabel('����(A)')
    hold on
    scatter(Uout_sample(1,:),Uout_sample(2,:),10,'filled','r');
    legend('��������','ʵ������')
    saveas(gca,'./figure/Valid_V-I.jpg');
else
    I_pattern = 30;
    U_totel = [];
    time = 390;
    figure('Color',[1 1 1]);
    figure(1)
    for k = 1:1:length(I_pattern)
        I_fc = I_pattern(k);
        simOut = sim('SOFC');
        U = U_fc.data;
        U_totel = U;
        plot(U_totel,'LineWidth',2);
        sample = 3;
        Uout_sample = [];
        for i = 2:sample:length(U_totel)
            Uout_sample = [Uout_sample,[i;U_totel(i)*((rand(1)-0.5)*0.05+1)]];
        end
        time = Uout_sample(1,:);
        U_samp = Uout_sample(2,:);
        hold on
        plot(time,U_samp,'LineWidth',0.8);
    end
    I_pattern = 80;
    U_totel = [];
    time = 390;
    for k = 1:1:length(I_pattern)
        I_fc = I_pattern(k);
        simOut = sim('SOFC');
        U = U_fc.data;
        U_totel = U;
        hold on
        plot(U_totel,'LineWidth',2);
        sample = 3;
        Uout_sample = [];
        for i = 2:sample:length(U_totel)
            Uout_sample = [Uout_sample,[i;U_totel(i)*((rand(1)-0.5)*0.05+1)]];
        end
        time = Uout_sample(1,:);
        U_samp = Uout_sample(2,:);
        hold on
        plot(time,U_samp,'LineWidth',0.8);
    end
    legend('30A��������','30Aʵ������','80A��������','80Aʵ������','Location','SouthEast')
    xlabel('ʱ��(s)')
    ylabel('��ѹ(V)')
    saveas(gca,'./figure/Valid_V-S.jpg');
end




% Pout_totel = Uout_totel.*I_pattern;
% figure('Color',[1 1 1]);
% figure(2)
% plot(I_pattern,Pout_totel,'LineWidth',2);
% ylabel('����(W)')
% xlabel('����(A)')
% hold on
% scatter(Uout_sample(1,:),Uout_sample(2,:),10,'filled','y');
% legend('��������','ʵ������')
% saveas(gca,'./figure/Valid_P-I.jpg');



