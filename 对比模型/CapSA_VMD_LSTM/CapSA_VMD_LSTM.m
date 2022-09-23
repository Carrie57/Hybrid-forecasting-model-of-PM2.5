%% LSTM ����Ԥ��

clc
close all
    itor = 10;          % ����10�Σ�ȡƽ��
    disp ('---------���� LSTM �������PM2.5ʱ�����еĵ���Ԥ��------------------')
for i_num = 1:itor      % ����ʮ�Σ�ȡ��ƽ��
    clearvars -except i_num itor % �������TestSimResult ResultTab i_num֮�����б���

%         filename = ['matlab',num2str(i_num,'%03d'),'.mat'];
%         load(filename)

    disp (['---------------------------��',num2str(i_num),'��------------------'])
    %% -------------------------------------------------------------------------
    % ��������

    % INPUT
        % load('data_ori.mat')	������ԭʼ���ݣ������������������У�
    % OUTPUT
        % data                  ��ԭʼ���ݣ���������

    tic;
        load('IMF.mat')   % ��������
        data = u(6,:);       % ���ص����ݱ����������������Ǿ���
    %% -------------------------------------------------------------------------
    % ԭʼ���ݻ��֣����ڶԱȣ�

    % INPUT
        % data_ori          ��ԭʼ���ݣ���������
    % OUTPUT
        % Train_pre_ori     ��ѵ����Ԥ�������ʵֵ����������
        % Test_pre_ori      �����Լ�Ԥ�������ʵֵ����������

    % 1 ��������ת��
        data_ori = data(:)';                            % ת��Ϊ������
    % ȡ��ѵ�����Ͳ��Լ���Ԥ����ʵֵ���Ա�������Ԥ��ֵ���жԱ�
        % ȷ����ռ�����������ʱ�����г��ȣ�n����ʱ���ӳ�(tau)��Ƕ��ά��(m)
            n = length(data_ori);                       % ʱ�������ܳ���
            tau = 1;                                    % ʱ���ӳ�
            m = 1;                                      % Ƕ��ά��
        % ����ѵ����������
            ratio = 0.8;                                % ����ѵ����������ռ����,0.8����ѡȡ������������80%��Ϊѵ������    
            MTrain = round(n*ratio-1-(m-1)*tau);        % ����ѵ������������Ϊ MTrain ��������ѵ����������������Ȼ����������Լ�����������
        % ʱ�����г��ȣ�ע��ѵ�����ݺͲ�������֮�����ص���
            n_tr = MTrain + (m-1)*tau + 1;              % ѵ�����ݳ���
            n_te = n - MTrain;                          % �������ݳ��� 
            n_pr = n - n_tr;                            % Ԥ�ⲽ��
        % ȡ��Ԥ�������ʵֵ������������ֵ�ƺ��У���Ӧ����ǩ������Ԥ����������ֵ��
            Train_pre_ori = data_ori(2+(m-1)*tau:n_tr);	% ѵ����Ԥ����ʵֵ ����������
            Test_pre_ori = data_ori(n_tr+1:n_tr+n_pr);	% ���Լ�Ԥ����ʵֵ ����������

    %% -------------------------------------------------------------------------
    % ԭʼ���ݹ�һ��

    % INPUT
        % data_x	��ԭʼ���ݣ���������
    % OUTPUT
        % data_n	����һ�����ԭʼ���ݣ���������

    % 1 ��������ת��
        data_x = data(:)';                          % ת��Ϊ����������һ���������������ݱ�������������
    % 2 ���ݴ������ַ�ʽ����׼���͹�һ����
        % ��һ�ַ�ʽ�����ݱ�׼����
            % [data_n,mu,w]=normalize_1(data_x);	% ��׼��Ϊ��ֵΪ0������Ϊ1����������
        % �ڶ��ַ�ʽ�����ݹ�һ����
            [data_n, PS]=mapminmax(data_x, 0, 1);	% data_n �ǹ�һ����������ݣ���������

    %% -------------------------------------------------------------------------
    % ���������Ԥ��

    % INPUT
        % data_div      ����һ�����ԭʼ���ݣ���������
    % OUTPUT
        % Ԥ����
            % train_sim	��ѵ����һ��Ԥ��������������
            % T_train	��ѵ����Ԥ�������������������
            % test_sim	�����Լ�һ��Ԥ��������������
            % T_test	�����Լ�Ԥ�������������������

    % 1 ��������ת��
        data_div = data_n(:)';      % ת��Ϊ������
    % Ԥ�����1
        % ���������������
            x = data_div;
            % tau = 6;              % ʱ���ӳ�
            % m = 2;                % Ƕ��ά��
            % ratio = 0.8;          % ����ѵ����������ռ����
            % n_pr = n - n_tr;      % Ԥ�ⲽ��
        % �������������Ԥ�� 
            [train_sim, T_train, test_sim, T_test] = LSTM_Func(x, tau, m, ratio, n_pr);

    %% -------------------------------------------------------------------------
    % ȥ��׼���򷴹�һ��

    % INPUT
        % Train_Sum_pre	��ѵ����Ԥ���ۼӽ������������
        % Test_Sum_pre	�����Լ�Ԥ���ۼӽ������������
    % OUTPUT
        % TrainPre      ��ѵ����Ԥ�ⷴ��һ���������������
        % TestPre       �����Լ�Ԥ�ⷴ��һ���������������

    % 1 ��������ת��
        Train_Sum_pre = train_sim;
        Test_Sum_pre = test_sim;
    % ���������Ԥ��ֵ����һ��
        TrainPre = mapminmax('reverse', Train_Sum_pre, PS);     % ѵ�������������Ԥ��������������
        TestPre = mapminmax('reverse', Test_Sum_pre, PS);       % ���Լ����������Ԥ��������������
    % Ԥ��ֵȥ��׼��
        % TrainPre = train_sim1/w+mu;
        % TestPre = test_sim1/w+mu;
    toc;    
    %% -------------------------------------------------------------------------
    % ����Ա�

    % ���������Ԥ����
            flag1 = [0,0,0,0,0];
            sim_test1 = TestPre;
            T_test1 = Test_pre_ori;
            sim_train1 = TrainPre;
            T_train1 = Train_pre_ori;
        LSTM_result = RESULT_Func(flag1, sim_test1, T_test1, sim_train1, T_train1)

    %% �������н��
        filename = ['matlab',num2str(i_num,'%03d'),'.mat'];
        save(filename) % ���湤������������
end

%

%% �������н��,��10�����е�ƽ��ֵ

    itor = 10;          % ����10�Σ�ȡƽ��
    clearvars -except itor% �������itor֮�����б�����
    TrainSimResult_n = [];% ѵ������ʮ�����н������һ�������
    TestSimResult_n = []; % ���Լ���ʮ�����н������һ�������
    TrainSimResult = [];% ѵ������ʮ�����н��
    TestSimResult = []; % ���Լ���ʮ�����н��
    ResultTab = [];     % ����10��ָ����
    for j = 1:itor
        clearvars -except TrainSimResult_n TestSimResult_n TrainSimResult TestSimResult ResultTab j itor % �������TestSimResult ResultTab i_num֮�����б���
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

%% �������н��
    filename = ['FinalResult',num2str(1,'%03d'),'.mat'];
    save(filename) % ���湤������������

%}