clear;
close all;
Tao_H2 = 26.1;
Tao_O2 = 2.91;
Tao_H2O = 78.3;
T_fc = 1375;
N = 384;  %电池串联个数 
qin_H2_standard = 2.4; % 氢气进入摩尔速度
R_HO_standard = 1.144; % 氢气氧气进入速度比
qin_air_standard = qin_H2_standard/R_HO_standard/0.21; 
losss = [4,7];
%%
x = 5; %状态数量
train_data = 1;   %0:一组数据 1：sets_num组数据
sets_num = 2;     %训练数据组数
switch train_data
    case 0
        model_in = zeros(100*x,3);
        feature_simulate = zeros(100*x,5);
        for flag = 0:1:(x-1)
        switch flag
            %健康状态
            case 0
                R_HO = R_HO_standard;
                qin_air = qin_H2_standard/R_HO/0.21;
                qin_H2 = qin_H2_standard;
                I_pattern = linspace(150,350,10);
                for i = 1:1:10
                     for k = 1:1:10
                         I_fc = I_pattern(k);
                         simOut = sim('SOFC');
                         model_in(-10+10*i+k,1) = I_fc;
                         model_in(-10+10*i+k,2) = flag;
                         %in(-10+10*i+k,3) = 0;
                         U = U_fc.data;
                         U_out = U(length(U));
                         Panode = P_anode.data;
                         P_Anode = Panode(length(Panode));
                         Pcathode = P_cathode.data;
                         P_Cathode = Pcathode(length(Pcathode));
                         feature_simulate(-10+10*i+k,1) = qin_H2*((rand(1)-0.5)*0.08+1);
                         feature_simulate(-10+10*i+k,2) = qin_air*((rand(1)-0.5)*0.08+1);
                         feature_simulate(-10+10*i+k,3) = U_out*I_fc*((rand(1)-0.5)*0.08+1);
                         feature_simulate(-10+10*i+k,4) = P_Anode*((rand(1)-0.5)*0.08+1);
                         feature_simulate(-10+10*i+k,5) = P_Cathode*((rand(1)-0.5)*0.08+1);
                     end  
               end        

            % fuel leakage 
            case 1
                R_HO = R_HO_standard;
                qin_air = qin_H2_standard/R_HO/0.21;
                flowrate = linspace(0.3,0.95,10);
                I_pattern = linspace(150,350,10);
                for i = 1:1:10
                    lossrate = flowrate(i);
                    qin_H2 = qin_H2_standard*lossrate;
                    for k = 1:1:10
                        I_fc = I_pattern(k);
                        simOut = sim('SOFC');
                        model_in(90+10*i+k,1) = I_fc;
                        model_in(90+10*i+k,2) = flag;
                        model_in(90+10*i+k,3) = lossrate;
                        U = U_fc.data;
                        U_out = U(length(U));
                        Panode = P_anode.data;
                        P_Anode = Panode(length(Panode));
                        Pcathode = P_cathode.data;
                        P_Cathode = Pcathode(length(Pcathode));
                        feature_simulate(90+10*i+k,1) = qin_H2*((rand(1)-0.5)*0.08+1);
                        feature_simulate(90+10*i+k,2) = qin_air*((rand(1)-0.5)*0.08+1);
                        feature_simulate(90+10*i+k,3) = U_out*I_fc*((rand(1)-0.5)*0.08+1);
                        feature_simulate(90+10*i+k,4) = P_Anode*((rand(1)-0.5)*0.08+1);
                        feature_simulate(90+10*i+k,5) = P_Cathode*((rand(1)-0.5)*0.08+1);
                    end  
                end       

             % air leakage 
            case 2
                qin_H2 = qin_H2_standard;
                flowrate = linspace(0.5,0.95,10);
                I_pattern = linspace(150,350,10);
                for i = 1:1:10
                    lossrate = flowrate(i);
                    R_HO = R_HO_standard/lossrate;
                    qin_air = qin_H2_standard/R_HO/0.21;
                    for k = 1:1:10
                        I_fc = I_pattern(k);
                        simOut = sim('SOFC');
                        model_in(190+10*i+k,1) = I_fc;
                        model_in(190+10*i+k,2) = flag;
                        model_in(190+10*i+k,3) = lossrate;
                        U = U_fc.data;
                        U_out = U(length(U));
                        Panode = P_anode.data;
                        P_Anode = Panode(length(Panode));
                        Pcathode = P_cathode.data;
                        P_Cathode = Pcathode(length(Pcathode));
                        feature_simulate(190+10*i+k,1) = qin_H2*((rand(1)-0.5)*0.08+1);
                        feature_simulate(190+10*i+k,2) = qin_air*((rand(1)-0.5)*0.08+1);
                        feature_simulate(190+10*i+k,3) = U_out*I_fc*((rand(1)-0.5)*0.08+1);
                        feature_simulate(190+10*i+k,4) = P_Anode*((rand(1)-0.5)*0.08+1);
                        feature_simulate(190+10*i+k,5) = P_Cathode*((rand(1)-0.5)*0.08+1);
                    end  
                end

                % Stack degradation 
            case 3
                qin_H2 = qin_H2_standard;
                R_HO = R_HO_standard;
                qin_air = qin_H2_standard/R_HO/0.21;
                I_pattern = linspace(150,350,10);
                degradation = linspace(losss(1),losss(2),10);
                for i = 1:1:10
                    degradation_loss = degradation(i) - 1;
                    for k = 1:1:10
                        I_fc = I_pattern(k);
                        simOut = sim('SOFC');
                        model_in(290+10*i+k,1) = I_fc;
                        model_in(290+10*i+k,2) = flag;
                        model_in(290+10*i+k,3) = degradation_loss+1;
                        U = U_fc.data;
                        U_out = U(length(U));
                        Panode = P_anode.data;
                        P_Anode = Panode(length(Panode));
                        Pcathode = P_cathode.data;
                        P_Cathode = Pcathode(length(Pcathode));
                        Uloss = U_loss.data;
                        U_Loss = Uloss(length(Uloss));
                        feature_simulate(290+10*i+k,1) = qin_H2*((rand(1)-0.5)*0.08+1);
                        feature_simulate(290+10*i+k,2) = qin_air*((rand(1)-0.5)*0.08+1);
                        feature_simulate(290+10*i+k,3) = (U_out - U_Loss*degradation_loss)*I_fc*((rand(1)-0.5)*0.08+1);
                        feature_simulate(290+10*i+k,4) = P_Anode*((rand(1)-0.5)*0.08+1);
                        feature_simulate(290+10*i+k,5) = P_Cathode*((rand(1)-0.5)*0.08+1);
                    end  
                end
            % fuel leakage 
            case 4
                R_HO = R_HO_standard;
                qin_air = qin_H2_standard/R_HO/0.21;
                flowrate = linspace(0.3,0.95,10);
                I_pattern = linspace(150,350,10);
                for i = 1:1:10
                    lossrate = flowrate(i);
                    qin_H2 = qin_H2_standard*lossrate;
                    for k = 1:1:10
                        I_fc = I_pattern(k);
                        simOut = sim('SOFC');
                        model_in(390+10*i+k,1) = I_fc;
                        model_in(390+10*i+k,2) = flag;
                        model_in(390+10*i+k,3) = lossrate;
                        U = U_fc.data;
                        U_out = U(length(U));
                        Panode = P_anode.data;
                        P_Anode = Panode(length(Panode));
                        Pcathode = P_cathode.data;
                        P_Cathode = Pcathode(length(Pcathode));
                        feature_simulate(390+10*i+k,1) = qin_H2_standard*((rand(1)-0.5)*0.08+1);
                        feature_simulate(390+10*i+k,2) = qin_air*((rand(1)-0.5)*0.08+1);
                        feature_simulate(390+10*i+k,3) = U_out*I_fc*((rand(1)-0.5)*0.08+1);
                        feature_simulate(390+10*i+k,4) = P_Anode*((rand(1)-0.5)*0.08+1);
                        feature_simulate(390+10*i+k,5) = P_Cathode*((rand(1)-0.5)*0.08+1);
                    end  
                end       
        end
        end
        save('./data/feature_simulate.mat','feature_simulate')
        save('./data/model_input.mat','model_in')
        clc
        disp('模拟测量数据被生成')
%% 
    case 1
        training_data = cell(sets_num,2);
        for train_th = 1:sets_num
            model_in = zeros(100*x,3);
            feature_simulate = zeros(100*x,5);
            for flag = 0:1:(x-1)
                switch flag
                    %健康状态
                    case 0
                        R_HO = R_HO_standard;
                        qin_air = qin_H2_standard/R_HO/0.21;
                        qin_H2 = qin_H2_standard;
                        I_pattern = linspace(150,350,10);
                        for i = 1:1:10
                             for k = 1:1:10
                                 I_fc = I_pattern(k);
                                 simOut = sim('SOFC');
                                 model_in(-10+10*i+k,1) = I_fc;
                                 model_in(-10+10*i+k,2) = flag;
                                 %in(-10+10*i+k,3) = 0;
                                 U = U_fc.data;
                                 U_out = U(length(U));
                                 Panode = P_anode.data;
                                 P_Anode = Panode(length(Panode));
                                 Pcathode = P_cathode.data;
                                 P_Cathode = Pcathode(length(Pcathode));
                                 feature_simulate(-10+10*i+k,1) = qin_H2*((rand(1)-0.5)*0.08+1);
                                 feature_simulate(-10+10*i+k,2) = qin_air*((rand(1)-0.5)*0.08+1);
                                 feature_simulate(-10+10*i+k,3) = U_out*I_fc*((rand(1)-0.5)*0.08+1);
                                 feature_simulate(-10+10*i+k,4) = P_Anode*((rand(1)-0.5)*0.08+1);
                                 feature_simulate(-10+10*i+k,5) = P_Cathode*((rand(1)-0.5)*0.08+1);
                             end  
                       end        

                    % fuel leakage 
                    case 1
                        R_HO = R_HO_standard;
                        qin_air = qin_H2_standard/R_HO/0.21;
                        flowrate = linspace(0.3,0.95,10);
                        I_pattern = linspace(150,350,10);
                        for i = 1:1:10
                            lossrate = flowrate(i);
                            qin_H2 = qin_H2_standard*lossrate;
                            for k = 1:1:10
                                I_fc = I_pattern(k);
                                simOut = sim('SOFC');
                                model_in(90+10*i+k,1) = I_fc;
                                model_in(90+10*i+k,2) = flag;
                                model_in(90+10*i+k,3) = lossrate;
                                U = U_fc.data;
                                U_out = U(length(U));
                                Panode = P_anode.data;
                                P_Anode = Panode(length(Panode));
                                Pcathode = P_cathode.data;
                                P_Cathode = Pcathode(length(Pcathode));
                                feature_simulate(90+10*i+k,1) = qin_H2*((rand(1)-0.5)*0.08+1);
                                feature_simulate(90+10*i+k,2) = qin_air*((rand(1)-0.5)*0.08+1);
                                feature_simulate(90+10*i+k,3) = U_out*I_fc*((rand(1)-0.5)*0.08+1);
                                feature_simulate(90+10*i+k,4) = P_Anode*((rand(1)-0.5)*0.08+1);
                                feature_simulate(90+10*i+k,5) = P_Cathode*((rand(1)-0.5)*0.08+1);
                            end  
                        end       

                     % air leakage 
                    case 2
                        qin_H2 = qin_H2_standard;
                        flowrate = linspace(0.5,0.95,10);
                        I_pattern = linspace(150,350,10);
                        for i = 1:1:10
                            lossrate = flowrate(i);
                            R_HO = R_HO_standard/lossrate;
                            qin_air = qin_H2_standard/R_HO/0.21;
                            for k = 1:1:10
                                I_fc = I_pattern(k);
                                simOut = sim('SOFC');
                                model_in(190+10*i+k,1) = I_fc;
                                model_in(190+10*i+k,2) = flag;
                                model_in(190+10*i+k,3) = lossrate;
                                U = U_fc.data;
                                U_out = U(length(U));
                                Panode = P_anode.data;
                                P_Anode = Panode(length(Panode));
                                Pcathode = P_cathode.data;
                                P_Cathode = Pcathode(length(Pcathode));
                                feature_simulate(190+10*i+k,1) = qin_H2*((rand(1)-0.5)*0.08+1);
                                feature_simulate(190+10*i+k,2) = qin_air*((rand(1)-0.5)*0.08+1);
                                feature_simulate(190+10*i+k,3) = U_out*I_fc*((rand(1)-0.5)*0.08+1);
                                feature_simulate(190+10*i+k,4) = P_Anode*((rand(1)-0.5)*0.08+1);
                                feature_simulate(190+10*i+k,5) = P_Cathode*((rand(1)-0.5)*0.08+1);
                            end  
                        end

                        % Stack degradation 
                    case 3
                        qin_H2 = qin_H2_standard;
                        R_HO = R_HO_standard;
                        qin_air = qin_H2_standard/R_HO/0.21;
                        I_pattern = linspace(150,350,10);
                        degradation = linspace(losss(1),losss(2),10);
                        for i = 1:1:10
                            degradation_loss = degradation(i) - 1;
                            for k = 1:1:10
                                I_fc = I_pattern(k);
                                simOut = sim('SOFC');
                                model_in(290+10*i+k,1) = I_fc;
                                model_in(290+10*i+k,2) = flag;
                                model_in(290+10*i+k,3) = degradation_loss+1;
                                U = U_fc.data;
                                U_out = U(length(U));
                                Panode = P_anode.data;
                                P_Anode = Panode(length(Panode));
                                Pcathode = P_cathode.data;
                                P_Cathode = Pcathode(length(Pcathode));
                                Uloss = U_loss.data;
                                U_Loss = Uloss(length(Uloss));
                                feature_simulate(290+10*i+k,1) = qin_H2*((rand(1)-0.5)*0.08+1);
                                feature_simulate(290+10*i+k,2) = qin_air*((rand(1)-0.5)*0.08+1);
                                feature_simulate(290+10*i+k,3) = (U_out - U_Loss*degradation_loss)*I_fc*((rand(1)-0.5)*0.08+1);
                                feature_simulate(290+10*i+k,4) = P_Anode*((rand(1)-0.5)*0.08+1);
                                feature_simulate(290+10*i+k,5) = P_Cathode*((rand(1)-0.5)*0.08+1);
                            end  
                        end
            case 4
                R_HO = R_HO_standard;
                qin_air = qin_H2_standard/R_HO/0.21;
                flowrate = linspace(0.3,0.95,10);
                I_pattern = linspace(150,350,10);
                for i = 1:1:10
                    lossrate = flowrate(i);
                    qin_H2 = qin_H2_standard*lossrate;
                    for k = 1:1:10
                        I_fc = I_pattern(k);
                        simOut = sim('SOFC');
                        model_in(390+10*i+k,1) = I_fc;
                        model_in(390+10*i+k,2) = flag;
                        model_in(390+10*i+k,3) = lossrate;
                        U = U_fc.data;
                        U_out = U(length(U));
                        Panode = P_anode.data;
                        P_Anode = Panode(length(Panode));
                        Pcathode = P_cathode.data;
                        P_Cathode = Pcathode(length(Pcathode));
                        feature_simulate(390+10*i+k,1) = qin_H2_standard*((rand(1)-0.5)*0.08+1);
                        feature_simulate(390+10*i+k,2) = qin_air*((rand(1)-0.5)*0.08+1);
                        feature_simulate(390+10*i+k,3) = U_out*I_fc*((rand(1)-0.5)*0.08+1);
                        feature_simulate(390+10*i+k,4) = P_Anode*((rand(1)-0.5)*0.08+1);
                        feature_simulate(390+10*i+k,5) = P_Cathode*((rand(1)-0.5)*0.08+1);
                    end  
                end       
                end
            end
            training_data{train_th,1} = feature_simulate;
            training_data{train_th,2} = model_in;
        end
        save('./data/training_data.mat','training_data') 
        clc
        disp([num2str(train_th),'组数据被生成'])
end

