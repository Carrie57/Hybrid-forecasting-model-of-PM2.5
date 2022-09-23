function [varargout] = LSTM_Func(x, tau, m, ratio, n_pr)
% function [varargout]= LSTM_Func(varargin)
% 函数功能：LSTM 单步预测
% 输入（所有的数据都是double类型，且输入行向量或列向量都行）
    % x             ：归一化后数据（向量，以后向量代表行、列向量都可以）    
    % tau           ：时间延迟
    % m             ：嵌入维数
	% ratio         ：设置训练样本数所占比率
    % n_pr          ：预测步数
% 输出（缺省输出的参数，所有的输出数据都是double类型）
    % yPred_train	：训练集一步预测结果
    % output_train  ：训练集预测期望输出
    % yPred_test    ：测试集一步预测结果
    % output_test   ：测试集预测期望输出数据

%% 缺省输入参数默认值设置

if nargin<1
    error("温馨提示：垃圾分类从我做起，另外请把数据输入一下")
end
if nargin<2
    tau = 6;
end
if nargin<3
    m = 2;
end
if nargin<4
    ratio = 0.8;	% ratio是训练样本数所占比率,默认选取数据的80%作为训练样本数
end
if nargin<5
    n_pr = 30;      % 默认预测30个数据点
end
%% -------------------------------------------------------------------------
% 时间序列的相空间重构（phase space reconstruction）
% INPUT
    % data_nor	：归一化后数据（向量，以后向量代表行、列向量都可以）
% OUTPUT
    % n_tr      ：训练数据长度
    % xn_tr     ：训练样本集（每个样本为列向量）
    % dn_tr     ：训练集标记向量，标记向量又称输出向量（行向量）
    % xn_te     ：测试样本集（每个样本为列向量）
    % dn_te     ：测试集标记向量（行向量）

% 1 输入数据转换
    data_nor = x;                                   % （向量）
% 相关参数设置入口，主要设置重构相空间三大参数：时间序列长度（n）、时间延迟(tau)、嵌入维数(m)
    % 确定时间序列长度、时间延迟和嵌入维数
        n = length(data_nor);                       % 时间序列总长度
        % tau = 6;                                  % 时间延迟
        % m = 2;                                    % 嵌入维数
    % 计算训练样本数量
        % ratio = 0.8;                              % 设置训练样本数所占比率,0.8代表选取数据样本数的80%作为训练样本
        MTrain = round(n*ratio-1-(m-1)*tau);        % 计算训练集样本个数为M个（有了训练集样本个数，自然可以算出测试集样本个数）
    % 时间序列长度（注意训练数据和测试数据之间有重叠）
        n_tr = MTrain + (m-1)*tau + 1;              % 训练数据长度
        n_te = n-MTrain;                            % 测试数据长度
% 相空间重构（phase space reconstruction）
    train_dat = data_nor(1:n_tr);                   % 训练数据（向量）
    test_dat = data_nor(end-n_te+1:end);            % 测试数据（向量）
    [xn_tr,dn_tr] = PhaSpaRecon(train_dat,tau,m);	% 重构训练数据
    [xn_te,dn_te] = PhaSpaRecon(test_dat,tau,m);	% 重构测试数据
    
%% -------------------------------------------------------------------------
% 训练集预测仿真

% INPUT
    % XTrain	：训练集的输入部分（每个样本为列向量）
    % YTrain	：训练集的输出部分（行向量）
% OUTPUT
    % net       ：LSTM 网络对象
    % dn_pr_tr  ：训练集预测值（行向量）
    
% 定义 LSTM 网络架构
    % 创建 LSTM 回归网络。指定 LSTM 层有 200 个隐含单元。

        numFeatures = m;
        numResponses = 1;
        numHiddenUnits = 50;
        layers = [ ...
            sequenceInputLayer(numFeatures)     % 输入层
            lstmLayer(numHiddenUnits)           % lstm层(隐藏层)
            fullyConnectedLayer(numResponses)   % 全连接层（输出层）
            regressionLayer];                   % 回归层
    % 指定训练选项。将求解器设置为 'adam' 并进行 250 轮训练。要防止梯度爆炸，请将梯度
    % 阈值设置为 1。指定初始学习率 0.005，在 125 轮训练后通过乘以因子 0.2 来降低学习率。
        options = trainingOptions('adam', ...
            'MaxEpochs',150, ...
            'GradientThreshold',1, ...
            'InitialLearnRate',0.005, ...
            'LearnRateSchedule','piecewise', ...
            'LearnRateDropPeriod',75, ...
            'LearnRateDropFactor',0.2, ...
            'Verbose',0, ...
            'Plots','none');                                % 'Plots','training-progress' 显示网络训练过程； 'Plots','none'不显示网络训练过程 

    % 使用 trainNetwork 以指定的训练选项训练 LSTM 网络。
        XTrain = xn_tr;                                     % 训练集的输入部分
        YTrain = dn_tr;                                     % 训练集的输出部分
        net = trainNetwork(XTrain,YTrain,layers,options);	% 训练 LSTM 网络
    %     figure
    %     plot(net) % 绘制网络的网络图。
    % 训练集预测仿真
        % 首先，初始化网络状态。要对新序列进行预测，请使用 resetState 重置网络状态。重置网
        % 络状态可防止先前的预测影响对新数据的预测。重置网络状态之后，再通过对训练数据进行预测
        % 来初始化网络状态。
        % 使用 resetState 重置网络状态
        %     net = resetState(net);
        % 要初始化网络状态，请先对训练数据 XTrain 进行预测
            [net,dn_pr_tr] = predictAndUpdateState(net,XTrain);
%% -------------------------------------------------------------------------
% 单步预测

% INPUT
    % data_nor	：归一化后数据（列向量）
    % dn_te		：测试集标记向量（行向量）
    % n_tr      ：训练数据长度
% OUTPUT
    % dn_pr_te	：测试集预测值（行向量）

    % 1 输入数据转换
        data_nor = x(:);                % 转化为列向量
    % 预分配空间（提高运行速度）
        % n_pr = length(dn_te);         % 预测步数（一般设置为测试集输出向量的长度，即测试集样本个数，当然设置为其他值也是可以的）
        dn_pr_te = zeros(1,n_pr);       % 为预测值向量预分配空间（行向量）
    % 单步预测的两种方式
        % 对于大型数据集合、长序列或大型网络，在 GPU 上进行预测计算通常比在 CPU 上快。其他
        % 情况下，在 CPU 上进行预测计算通常更快。对于单时间步预测，请使用 CPU。要使用 CPU 
        % 进行预测，请将 predictAndUpdateState 的 'ExecutionEnvironment' 选项设置为 'cpu'。
        % 对每个时间步进行预测。对于每次预测，使用前一时间步的观测值预测下一个时间步。
        % 将 predictAndUpdateState 的 'ExecutionEnvironment' 选项设置为 'cpu'。
        
        % 使用观测值更新网络状态（LSTM 单步预测）
            % 如果您可以访问预测之间的时间步的实际值，则可以使用观测值而不是预测值更新网络状态。
    
        % 第一种，利用了更新输入向量的方法，如果是多步预测，则必须使用以下结构进行预测
%             x_start = data_nor(n_tr-(m-1)*tau:n_tr);      	% 用于构造测试集输入向量（列向量）
%             for i = 1:n_pr
%                 xn_start = PhaSpaRecon(x_start,tau,m);    	% xn_start 是测试集输入向量（列向量）
%                 [net,dn_pr_te(i)] = predictAndUpdateState(net,xn_start,'ExecutionEnvironment','cpu');
%                 x_start = [x_start(2:end);data_nor(n_tr+i)];	% 更新输入向量（使用真实值更新输入向量）
%                 % x_start = [x_start(2:end);dn_pr(i)];        % 多步预测（使用预测值更新输入向量）
%             end
        % 第二种，xn_te为测试样本集，可以发现这种方法代码比较简单，容易理解，如果只考虑单步预测，优先使用这种方法
            for i = 1:n_pr
            	xn_start = xn_te(:,i);                          % xn_start 是测试集输入向量（列向量）
            	[net,dn_pr_te(i)] = predictAndUpdateState(net,xn_start,'ExecutionEnvironment','cpu');
            end
%% 缺省输出参数默认值设置

    yPred_train = dn_pr_tr;             % 训练集一步预测结果 
    output_train = dn_tr;               % 训练集期望输出   
    yPred_test = dn_pr_te;              % 测试集一步预测结果
    output_test = dn_te;                % 测试集期望输出 

    if nargout > 0                      % 如果只输出一个参数：则输出yPred_train
        varargout{1} = yPred_train;     % 训练集一步预测结果        
    end
    if nargout > 1
        varargout{2} = output_train;	% 训练集预测期望输出         
    end
    if nargout > 2
        varargout{3} = yPred_test;      % 测试集一步预测结果
    end
    if nargout > 3
       varargout{4} = output_test;      % 测试集预测期望输出数据        
    end  
end