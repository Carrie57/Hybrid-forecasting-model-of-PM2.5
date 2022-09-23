function T = RESULT_Func(flag, sim_test, T_test, sim_train, T_train, Test_Exp_Set, Test_Pre_Set)
% 函数功能：预测结果评价函数
% 说明：该函数的功能以后还将扩展
% 输入（所有的数据都是double类型，且输入行向量或列向量都行）
    % flag          ：预测结果图显示控制标志（0，不显示；1，显示）
        % flag(1)控制训练集预测图显示；
        % flag(2)控制测试集预测图显示；
        % flag(3)控制合并图显示；
        % flag(4)控制测试集误差图显示。
        % flag(5)控制测试集IMF分量预测对比图显示。
        % 例如，当flag = [1,1,1,1,1]时，所有图都显示）
    % sim_test      ：测试集预测反归一化结果
    % T_test        ：测试集真实值
    % sim_train 	：训练集预测反归一化结果
    % T_train       ：训练集真实值
    % Test_Exp_Set  ：固有模态分量测试集的期望结果集（每个分量为行向量）
    % Test_Pre_Set  ：固有模态分量测试集的预测结果集（每个分量为行向量）

% 输出
    % T             ：定量评价指标（表格类型数据）
%% 缺省输入参数默认值设置
% * 说明：可以输入3个参数、5个参数、7个参数，其他情况会报错

if nargin<1                         % 如果没有输入参数，则报错
    error("请输入结果图显示控制标志")
elseif nargin<2                     % 如果只输入了一个参数，则报错
    error("请输入测试集的预测数据")
elseif nargin<3                     % 如果输入两个参数，则报错
    error("请输入测试集的原始数据")
elseif nargin<4                     % 如果只输入了三个参数
    sim_train = [];
    T_train = [];
    Test_Exp_Set = [];
    Test_Pre_Set = [];
elseif nargin<5                     % 如果输入四个参数，则报错
    error("请输入训练集的原始数据")
elseif nargin<6                     % 如果输入5个参数
    Test_Exp_Set = [];
    Test_Pre_Set = [];
elseif nargin<7                     % 如果输入6个参数，则报错
    error("请输入模态分量测试集的预测结果集")
elseif nargin>7                     % 如果输入参数超过7个，则报错
    error("输入参数过多")    
end

%% 定量评价
% * 衡量模型的测试集预测性能

% INPUT
    % tru_dat     ：测试集原始值（行向量）
    % sim_dat     ：测试集预测值（行向量）    
% OUTPUT
    % T     ：定量评价指标（表格类型数据）

% 输入数据转换
    tru_dat = T_test(:)';    	% 真实值
    sim_dat = sim_test(:)';     % 预测值
    err = tru_dat - sim_dat;
    n = length(tru_dat);        % 测试集序列长度
% 计算定量指标
    % 求均方根误差(RMSE, Root Mean Square Error)    
        RMSE=sqrt(mse(err));
        % RMSE1 = sqrt( sum(err .^ 2) / length(err) );
    % 求平均绝对误差(MAE, Mean Absolute Error)    
        MAE= sum(mean(abs(err))); 
        % MAE1=sum(abs(err))/length(err); 
        % MAE2=mse(abs(err)); % 求平均绝对误差
    % 求平均绝对百分比误差    
        MAPE=100*sum(abs(err./tru_dat))/length(err); 
    % 确定系数(R^2, Deterministic coefficient)，又称决定系数 
        l=regstats(tru_dat,sim_dat,'quadratic','rsquare');
        R2 = l.rsquare; % 等价于R = getfield(l,'rsquare');
        % N = length(f);
        % R21 =(N*sum(n.*f)-sum(n)*sum(f))^2/((N*sum((n).^2)-(sum(n))^2)*(N*sum((f).^2)-(sum(f))^2)); % 2021年3月25日19:56:42测试，R21和R22的值有差别 
        % R22 = (N*sum(n.*f)-sum(n)*sum(f))^2/((N*sum((n).^2)-(sum(n))^2)*(N*sum((f).^2)-(sum(f))^2));
    % 求均方误差(MSE, Mean Square Error)
        MSE = sum(err.^2)/n;
    % 求平均相对误差(MRE, Mean Relative Error)    
        MRE= sum(mean(abs(err./tru_dat))); 
        % MRE1=sum(abs(err./f))/length(err); 
        % MRE2=mse(abs(err./f)); % 求平均相对误差
	% 拟合指数,又称一致指标[1](Index of Agreement, IA)
        IA = (err*err')/((abs(tru_dat-mean(tru_dat))+abs(sim_dat-mean(tru_dat)))*(abs(tru_dat-mean(tru_dat))+abs(sim_dat-mean(tru_dat)))');
        IA = 1-IA;
    % 相关系数
        rho1 = corr(tru_dat',sim_dat','Type','Pearson');    % Pearson 线性相关系数
        rho2 = corr(tru_dat',sim_dat','Type','Kendall');	% Kendall tau 系数
        rho3 = corr(tru_dat',sim_dat','Type','Spearman');	% Spearman 相关系数
    % 方向性指标
        stat = sum((tru_dat(2:end)-tru_dat(1:end-1)).*(sim_dat(2:end)-tru_dat(1:end-1))>=0)/(n-1);
        
% 以表格的形式输出定量指标
    % T = table(RMSE, MAE, MAPE, R, MRE, IA, rho1, rho2, rho3)                            % 使用table创建一个表
    % LastName = {'Sanchez';'Johnson';'Lee';'Diaz';'Brown'};        % 设置多个行名称    

    T = table(RMSE, MAE, MAPE, R2, MSE, MRE, IA, rho1, rho2, rho3, stat,...                           % 表格的成员变量
            'VariableNames',{'RMSE','MAE','MAPE','R2','MSE','MRE','IA','rho1','rho2','rho3','stat'});	% 指定变量名称
        
%     LastName = {'一步预测'};
%     T = table(RMSE, MAE, MAPE, R, MRE, IA, rho1, rho2, rho3,...                           % 表格的成员变量
%             'VariableNames',{'RMSE','MAE','MAPE','R^2','MRE','IA','rho1','rho2','rho3'},...	% 指定变量名称
%             'RowNames',LastName);                                   % 指定行名称

%% 定性评价

% INPUT
    % Train_pre     ：训练集预测值（行向量）
    % Train_ori     ：训练集原始值（行向量）
    % Test_pre      ：测试集预测值（行向量）
    % Test_ori      ：测试集原始值（行向量）
% OUTPUT
    % 定性评价图

% 输入数据转换
        Train_pre = sim_train(:)';	% 训练集预测值
        Train_ori = T_train(:)';    % 训练集原始值
        Test_pre = sim_test(:)';    % 测试集预测值
        Test_ori = T_test(:)';      % 测试集原始值
        flag = flag(:)';            % eg: flag = [0,1,0,1,0]; % 训练集预测图不显示(0)，测试集预测图显示(1)，合并图不显示(0)，测试集误差图显示(1)，IMF分量预测对比图不显示（0）。
% 作图
    % 训练集预测结果作图       
        if(flag(1))
    % 输入数据转换
            figure('NumberTitle','on','Name','对训练集进行一步预测')
            plot(Train_ori,'bo-');
            hold on;
            plot(Train_pre,'r*-');
            xlim([1,length(Train_ori)]);
            legend('训练集真实值','训练集预测结果')
            xlabel('Time/h');
            % ylabel('PM_{2.5} / (\mu g.m^{-3})');
            ylabel('Amplitude');
        end
    % 测试集预测结果作图
        if(flag(2)) 
            figure('NumberTitle','on','Name','对测试集进行一步预测');
            plot(Test_ori,'bo-');
            hold on;
            plot(Test_pre,'r*-'); 
            xlim([1,length(Test_ori)]);
            legend('Expected Outputs','Network Predictions')
            xlabel('Time/h');
            ylabel('Amplitude');
        end
    % 训练集和测试集合并作图
        if(flag(3))
            figure('NumberTitle','on','Name','训练集和测试集合并显示模型的训练结果');
            % 第一种合并作图
                % plot([Train_ori,nan(1,length(Test_pre)); 
                % nan(1,length(Train_ori)),Test_pre; 
                % nan(1,length(Train_ori)),Test_ori]')
            % 第二种合并作图
                plot(Train_ori(1:end))
                hold on
                idx = numel(Train_ori):(numel(Train_ori) + length(Test_pre));
                plot(idx,[Train_ori(end) Test_pre],'r*-')        
                plot(idx,[Train_ori(end) Test_ori],'b.-')
                hold off
            legend('Original Targets','Network Predictions','Expected Outputs')
            xlabel('Time/h');
            ylabel('Amplitude');
        end
    % 测试集预测绝对误差作图          
        if(flag(4))  
            figure('Name', '测试集预测结果和绝对误差波形图', 'NumberTitle', 'on') 
            subplot(211)            
            plot(Test_pre,'r*-');            
            hold on;
            plot(Test_ori,'b.-');
            xlim([1,length(Test_ori)]);
            legend('Network Predictions','Expected Outputs')
            xlabel('n');
            title('预测值和真实值');
            ylabel('xp(n), x(n)')
            subplot(212)
            % errabs=abs(Test_ori-Test_pre); %绝对误差的模
            err_te = Test_ori-Test_pre; % err_te波形看上去更直观
            plot(err_te,'k')
            xlim([1,length(Test_ori)]);
            xlabel('n');
            ylabel('e(n)');
            string = {'预测结果绝对误差';['(MAE = ' num2str(MAE) ' RMSE= ' num2str(RMSE)  ' R^2 = ' num2str(R2) ')']};
            title(string);    
        end 
    % IMF分量作图        
        if(flag(5))
        % 1 输入数据转换
            IMFs_Exp = Test_Exp_Set; % 输入的每个IMF都是行向量
            IMFs_Pre = Test_Pre_Set; % 固有模态分量测试集的预测结果集（每个分量为行向量）
        % 作图
            m = min(size(IMFs_Exp)); % 计算IMF个数
            imf_len = length(IMFs_Exp);
            t = 1:imf_len;
            h2 = figure('NumberTitle','on','Name','VMD分解的IMF分量');
            for i = 1:m
                subplot(m,1,i);
                set(gcf,'color','w') % 设置figure背景颜色
                plot(t,IMFs_Exp(i,:),'b')
                hold on
                plot(t,IMFs_Pre(i,:),'r')
                hold off
                ylabel (['imf ' num2str(i)]);
                xlim([0 imf_len])
                if i < m                                                % 前m-1个分量绘图
                    set(gca,'xtick',[])                                 % set函数 将当前图形（gca）的x轴坐标刻度（xtick）标志为空
                else                                                    % 最后一个分量绘图
                    xlabel('Sample points')
                    set(get(gca,'XLabel'),'FontName','Times New Roman','FontSize', 16);
                end
                set(get(gca,'YLabel'),'FontName','Times New Roman','FontSize', 16);
                set(gca,'FontName','Times New Roman','fontsize', 14);	% 坐标轴刻度字体大小
            end
            set(h2,'position',[265,61,861,590]);
        end

end