function [varargout] = LSTM_Func(x, tau, m, ratio, n_pr)
% function [varargout]= LSTM_Func(varargin)
% �������ܣ�LSTM ����Ԥ��
% ���루���е����ݶ���double���ͣ������������������������У�
    % x             ����һ�������ݣ��������Ժ����������С������������ԣ�    
    % tau           ��ʱ���ӳ�
    % m             ��Ƕ��ά��
	% ratio         ������ѵ����������ռ����
    % n_pr          ��Ԥ�ⲽ��
% �����ȱʡ����Ĳ��������е�������ݶ���double���ͣ�
    % yPred_train	��ѵ����һ��Ԥ����
    % output_train  ��ѵ����Ԥ���������
    % yPred_test    �����Լ�һ��Ԥ����
    % output_test   �����Լ�Ԥ�������������

%% ȱʡ�������Ĭ��ֵ����

if nargin<1
    error("��ܰ��ʾ��������������������������������һ��")
end
if nargin<2
    tau = 6;
end
if nargin<3
    m = 2;
end
if nargin<4
    ratio = 0.8;	% ratio��ѵ����������ռ����,Ĭ��ѡȡ���ݵ�80%��Ϊѵ��������
end
if nargin<5
    n_pr = 30;      % Ĭ��Ԥ��30�����ݵ�
end
%% -------------------------------------------------------------------------
% ʱ�����е���ռ��ع���phase space reconstruction��
% INPUT
    % data_nor	����һ�������ݣ��������Ժ����������С������������ԣ�
% OUTPUT
    % n_tr      ��ѵ�����ݳ���
    % xn_tr     ��ѵ����������ÿ������Ϊ��������
    % dn_tr     ��ѵ���������������������ֳ������������������
    % xn_te     ��������������ÿ������Ϊ��������
    % dn_te     �����Լ������������������

% 1 ��������ת��
    data_nor = x;                                   % ��������
% ��ز���������ڣ���Ҫ�����ع���ռ����������ʱ�����г��ȣ�n����ʱ���ӳ�(tau)��Ƕ��ά��(m)
    % ȷ��ʱ�����г��ȡ�ʱ���ӳٺ�Ƕ��ά��
        n = length(data_nor);                       % ʱ�������ܳ���
        % tau = 6;                                  % ʱ���ӳ�
        % m = 2;                                    % Ƕ��ά��
    % ����ѵ����������
        % ratio = 0.8;                              % ����ѵ����������ռ����,0.8����ѡȡ������������80%��Ϊѵ������
        MTrain = round(n*ratio-1-(m-1)*tau);        % ����ѵ������������ΪM��������ѵ����������������Ȼ����������Լ�����������
    % ʱ�����г��ȣ�ע��ѵ�����ݺͲ�������֮�����ص���
        n_tr = MTrain + (m-1)*tau + 1;              % ѵ�����ݳ���
        n_te = n-MTrain;                            % �������ݳ���
% ��ռ��ع���phase space reconstruction��
    train_dat = data_nor(1:n_tr);                   % ѵ�����ݣ�������
    test_dat = data_nor(end-n_te+1:end);            % �������ݣ�������
    [xn_tr,dn_tr] = PhaSpaRecon(train_dat,tau,m);	% �ع�ѵ������
    [xn_te,dn_te] = PhaSpaRecon(test_dat,tau,m);	% �ع���������
    
%% -------------------------------------------------------------------------
% ѵ����Ԥ�����

% INPUT
    % XTrain	��ѵ���������벿�֣�ÿ������Ϊ��������
    % YTrain	��ѵ������������֣���������
% OUTPUT
    % net       ��LSTM �������
    % dn_pr_tr  ��ѵ����Ԥ��ֵ����������
    
% ���� LSTM ����ܹ�
    % ���� LSTM �ع����硣ָ�� LSTM ���� 200 ��������Ԫ��

        numFeatures = m;
        numResponses = 1;
        numHiddenUnits = 50;
        layers = [ ...
            sequenceInputLayer(numFeatures)     % �����
            lstmLayer(numHiddenUnits)           % lstm��(���ز�)
            fullyConnectedLayer(numResponses)   % ȫ���Ӳ㣨����㣩
            regressionLayer];                   % �ع��
    % ָ��ѵ��ѡ������������Ϊ 'adam' ������ 250 ��ѵ����Ҫ��ֹ�ݶȱ�ը���뽫�ݶ�
    % ��ֵ����Ϊ 1��ָ����ʼѧϰ�� 0.005���� 125 ��ѵ����ͨ���������� 0.2 ������ѧϰ�ʡ�
        options = trainingOptions('adam', ...
            'MaxEpochs',150, ...
            'GradientThreshold',1, ...
            'InitialLearnRate',0.005, ...
            'LearnRateSchedule','piecewise', ...
            'LearnRateDropPeriod',75, ...
            'LearnRateDropFactor',0.2, ...
            'Verbose',0, ...
            'Plots','none');                                % 'Plots','training-progress' ��ʾ����ѵ�����̣� 'Plots','none'����ʾ����ѵ������ 

    % ʹ�� trainNetwork ��ָ����ѵ��ѡ��ѵ�� LSTM ���硣
        XTrain = xn_tr;                                     % ѵ���������벿��
        YTrain = dn_tr;                                     % ѵ�������������
        net = trainNetwork(XTrain,YTrain,layers,options);	% ѵ�� LSTM ����
    %     figure
    %     plot(net) % �������������ͼ��
    % ѵ����Ԥ�����
        % ���ȣ���ʼ������״̬��Ҫ�������н���Ԥ�⣬��ʹ�� resetState ��������״̬��������
        % ��״̬�ɷ�ֹ��ǰ��Ԥ��Ӱ��������ݵ�Ԥ�⡣��������״̬֮����ͨ����ѵ�����ݽ���Ԥ��
        % ����ʼ������״̬��
        % ʹ�� resetState ��������״̬
        %     net = resetState(net);
        % Ҫ��ʼ������״̬�����ȶ�ѵ������ XTrain ����Ԥ��
            [net,dn_pr_tr] = predictAndUpdateState(net,XTrain);
%% -------------------------------------------------------------------------
% ����Ԥ��

% INPUT
    % data_nor	����һ�������ݣ���������
    % dn_te		�����Լ������������������
    % n_tr      ��ѵ�����ݳ���
% OUTPUT
    % dn_pr_te	�����Լ�Ԥ��ֵ����������

    % 1 ��������ת��
        data_nor = x(:);                % ת��Ϊ������
    % Ԥ����ռ䣨��������ٶȣ�
        % n_pr = length(dn_te);         % Ԥ�ⲽ����һ������Ϊ���Լ���������ĳ��ȣ������Լ�������������Ȼ����Ϊ����ֵҲ�ǿ��Եģ�
        dn_pr_te = zeros(1,n_pr);       % ΪԤ��ֵ����Ԥ����ռ䣨��������
    % ����Ԥ������ַ�ʽ
        % ���ڴ������ݼ��ϡ������л�������磬�� GPU �Ͻ���Ԥ�����ͨ������ CPU �Ͽ졣����
        % ����£��� CPU �Ͻ���Ԥ�����ͨ�����졣���ڵ�ʱ�䲽Ԥ�⣬��ʹ�� CPU��Ҫʹ�� CPU 
        % ����Ԥ�⣬�뽫 predictAndUpdateState �� 'ExecutionEnvironment' ѡ������Ϊ 'cpu'��
        % ��ÿ��ʱ�䲽����Ԥ�⡣����ÿ��Ԥ�⣬ʹ��ǰһʱ�䲽�Ĺ۲�ֵԤ����һ��ʱ�䲽��
        % �� predictAndUpdateState �� 'ExecutionEnvironment' ѡ������Ϊ 'cpu'��
        
        % ʹ�ù۲�ֵ��������״̬��LSTM ����Ԥ�⣩
            % ��������Է���Ԥ��֮���ʱ�䲽��ʵ��ֵ�������ʹ�ù۲�ֵ������Ԥ��ֵ��������״̬��
    
        % ��һ�֣������˸������������ķ���������ǶಽԤ�⣬�����ʹ�����½ṹ����Ԥ��
%             x_start = data_nor(n_tr-(m-1)*tau:n_tr);      	% ���ڹ�����Լ�������������������
%             for i = 1:n_pr
%                 xn_start = PhaSpaRecon(x_start,tau,m);    	% xn_start �ǲ��Լ�������������������
%                 [net,dn_pr_te(i)] = predictAndUpdateState(net,xn_start,'ExecutionEnvironment','cpu');
%                 x_start = [x_start(2:end);data_nor(n_tr+i)];	% ��������������ʹ����ʵֵ��������������
%                 % x_start = [x_start(2:end);dn_pr(i)];        % �ಽԤ�⣨ʹ��Ԥ��ֵ��������������
%             end
        % �ڶ��֣�xn_teΪ���������������Է������ַ�������Ƚϼ򵥣�������⣬���ֻ���ǵ���Ԥ�⣬����ʹ�����ַ���
            for i = 1:n_pr
            	xn_start = xn_te(:,i);                          % xn_start �ǲ��Լ�������������������
            	[net,dn_pr_te(i)] = predictAndUpdateState(net,xn_start,'ExecutionEnvironment','cpu');
            end
%% ȱʡ�������Ĭ��ֵ����

    yPred_train = dn_pr_tr;             % ѵ����һ��Ԥ���� 
    output_train = dn_tr;               % ѵ�����������   
    yPred_test = dn_pr_te;              % ���Լ�һ��Ԥ����
    output_test = dn_te;                % ���Լ�������� 

    if nargout > 0                      % ���ֻ���һ�������������yPred_train
        varargout{1} = yPred_train;     % ѵ����һ��Ԥ����        
    end
    if nargout > 1
        varargout{2} = output_train;	% ѵ����Ԥ���������         
    end
    if nargout > 2
        varargout{3} = yPred_test;      % ���Լ�һ��Ԥ����
    end
    if nargout > 3
       varargout{4} = output_test;      % ���Լ�Ԥ�������������        
    end  
end