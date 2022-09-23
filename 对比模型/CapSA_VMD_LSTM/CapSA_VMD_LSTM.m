%% LSTM 单步预测

clc
close all
    itor = 10;          % 迭代10次，取平均
    disp ('---------基于 LSTM 神经网络的PM2.5时间序列的单步预测------------------')
for i_num = 1:itor      % 运行十次，取其平均
    clearvars -except i_num itor % 清除除了TestSimResult ResultTab i_num之外所有变量

%         filename = ['matlab',num2str(i_num,'%03d'),'.mat'];
%         load(filename)

    disp (['---------------------------第',num2str(i_num),'轮------------------'])
    %% -------------------------------------------------------------------------
    % 加载数据

    % INPUT
        % load('data_ori.mat')	：加载原始数据（行向量和列向量都行）
    % OUTPUT
        % data                  ：原始数据（行向量）

    tic;
        load('IMF.mat')   % 加载数据
        data = u(6,:);       % 加载的数据必须是向量，不能是矩阵
    %% -------------------------------------------------------------------------
    % 原始数据划分（用于对比）

    % INPUT
        % data_ori          ：原始数据（行向量）
    % OUTPUT
        % Train_pre_ori     ：训练集预测输出真实值（行向量）
        % Test_pre_ori      ：测试集预测输出真实值（行向量）

    % 1 输入数据转换
        data_ori = data(:)';                            % 转化为行向量
    % 取出训练集和测试集的预测真实值，以便与最终预测值进行对比
        % 确定相空间的三大参数：时间序列长度（n）、时间延迟(tau)和嵌入维数(m)
            n = length(data_ori);                       % 时间序列总长度
            tau = 1;                                    % 时间延迟
            m = 1;                                      % 嵌入维数
        % 计算训练样本数量
            ratio = 0.8;                                % 设置训练样本数所占比率,0.8代表选取数据样本数的80%作为训练样本    
            MTrain = round(n*ratio-1-(m-1)*tau);        % 计算训练集样本个数为 MTrain 个（有了训练集样本个数，自然可以算出测试集样本个数）
        % 时间序列长度（注意训练数据和测试数据之间有重叠）
            n_tr = MTrain + (m-1)*tau + 1;              % 训练数据长度
            n_te = n - MTrain;                          % 测试数据长度 
            n_pr = n - n_tr;                            % 预测步数
        % 取出预测输出真实值（神经网络的输出值称呼有：响应、标签向量、预测结果、期望值）
            Train_pre_ori = data_ori(2+(m-1)*tau:n_tr);	% 训练集预测真实值 （行向量）
            Test_pre_ori = data_ori(n_tr+1:n_tr+n_pr);	% 测试集预测真实值 （行向量）

    %% -------------------------------------------------------------------------
    % 原始数据归一化

    % INPUT
        % data_x	：原始数据（行向量）
    % OUTPUT
        % data_n	：归一化后的原始数据（行向量）

    % 1 输入数据转换
        data_x = data(:)';                          % 转化为行向量（归一化函数的输入数据必须是行向量）
    % 2 数据处理（两种方式：标准化和归一化）
        % 第一种方式（数据标准化）
            % [data_n,mu,w]=normalize_1(data_x);	% 标准化为均值为0、方差为1（行向量）
        % 第二种方式（数据归一化）
            [data_n, PS]=mapminmax(data_x, 0, 1);	% data_n 是归一化的输出数据（行向量）

    %% -------------------------------------------------------------------------
    % 无误差修正预测

    % INPUT
        % data_div      ：归一化后的原始数据（行向量）
    % OUTPUT
        % 预测结果
            % train_sim	：训练集一步预测结果（行向量）
            % T_train	：训练集预测期望输出（行向量）
            % test_sim	：测试集一步预测结果（行向量）
            % T_test	：测试集预测期望输出（行向量）

    % 1 输入数据转换
        data_div = data_n(:)';      % 转换为行向量
    % 预测仿真1
        % 网络输入参数设置
            x = data_div;
            % tau = 6;              % 时间延迟
            % m = 2;                % 嵌入维数
            % ratio = 0.8;          % 设置训练样本数所占比率
            % n_pr = n - n_tr;      % 预测步数
        % 调用神经网络进行预测 
            [train_sim, T_train, test_sim, T_test] = LSTM_Func(x, tau, m, ratio, n_pr);

    %% -------------------------------------------------------------------------
    % 去标准化或反归一化

    % INPUT
        % Train_Sum_pre	：训练集预测累加结果（行向量）
        % Test_Sum_pre	：测试集预测累加结果（行向量）
    % OUTPUT
        % TrainPre      ：训练集预测反归一化结果（行向量）
        % TestPre       ：测试集预测反归一化结果（行向量）

    % 1 输入数据转换
        Train_Sum_pre = train_sim;
        Test_Sum_pre = test_sim;
    % 无误差修正预测值反归一化
        TrainPre = mapminmax('reverse', Train_Sum_pre, PS);     % 训练集无误差修正预测结果（行向量）
        TestPre = mapminmax('reverse', Test_Sum_pre, PS);       % 测试集无误差修正预测结果（行向量）
    % 预测值去标准化
        % TrainPre = train_sim1/w+mu;
        % TestPre = test_sim1/w+mu;
    toc;    
    %% -------------------------------------------------------------------------
    % 结果对比

    % 无误差修正预测结果
            flag1 = [0,0,0,0,0];
            sim_test1 = TestPre;
            T_test1 = Test_pre_ori;
            sim_train1 = TrainPre;
            T_train1 = Train_pre_ori;
        LSTM_result = RESULT_Func(flag1, sim_test1, T_test1, sim_train1, T_train1)

    %% 保存运行结果
        filename = ['matlab',num2str(i_num,'%03d'),'.mat'];
        save(filename) % 保存工作区所有数据
end

%

%% 处理运行结果,求10次运行的平均值

    itor = 10;          % 迭代10次，取平均
    clearvars -except itor% 清除除了itor之外所有变量，
    TrainSimResult_n = [];% 训练集的十次运行结果（归一化结果）
    TestSimResult_n = []; % 测试集的十次运行结果（归一化结果）
    TrainSimResult = [];% 训练集的十次运行结果
    TestSimResult = []; % 测试集的十次运行结果
    ResultTab = [];     % 运行10次指标结果
    for j = 1:itor
        clearvars -except TrainSimResult_n TestSimResult_n TrainSimResult TestSimResult ResultTab j itor % 清除除了TestSimResult ResultTab i_num之外所有变量
        filename = ['matlab',num2str(j,'%03d'),'.mat'];
        load(filename)
        TrainSimResult_n = [TrainSimResult_n; Train_Sum_pre];   
        TestSimResult_n = [TestSimResult_n; Test_Sum_pre];   
        TrainSimResult = [TrainSimResult; TrainPre];   
        TestSimResult = [TestSimResult; TestPre];        
        ResultTab = [ResultTab; LSTM_result];
    end
    TRAIN_SIM_N = mean(TrainSimResult_n);
    TEST_SIM_N = mean(TestSimResult_n);
    TRAIN_SIM = mean(TrainSimResult);
    TEST_SIM = mean(TestSimResult);
    RESULT = mean([ResultTab.RMSE, ResultTab.MAE, ResultTab.MAPE, ResultTab.R2, ResultTab.MSE,...
            ResultTab.MRE, ResultTab.IA, ResultTab.rho1, ResultTab.rho2, ResultTab.rho3, ResultTab.stat])

%% 保存运行结果
    filename = ['FinalResult',num2str(1,'%03d'),'.mat'];
    save(filename) % 保存工作区所有数据

%}