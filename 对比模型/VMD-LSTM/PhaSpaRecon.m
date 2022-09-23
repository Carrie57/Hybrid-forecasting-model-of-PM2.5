function [xn,dn] = PhaSpaRecon(s,tau,m)
% 混沌序列的相空间重构 (phase space reconstruction)，也可以用来划分数据集
% [xn, dn] = PhaSpaRecon(s, tau, m)
% 输入参数：     
%               s       ：混沌序列(列向量或行向量都行)
%               tau     ：重构时延
%               m       ：重构维数
% 输出参数：
%               xn      ：相空间中的点序列(每一列为一个点)
%               dn      ：一步预测的目标(行向量)
%% 将数据转化为行向量的两种方式

% 第一种
    % [rows,cols] = size(s);
    % if (rows>cols)    % 如果为列向量，则转置
    %     len = rows;
    %     s = s';       % 转置
    % else              % 如果是行向量，则不变
    %     len = cols;
    % end
% 第二种
    len = length(s);
    s = s(:)';          % 转化为行向量
%% 重构相空间
if (nargout==2)         % 当输出有两个参数时
    if (len-1-(m-1)*tau < 1)
        disp('err: delay time or the embedding dimension is too large!')	% 延迟时间或嵌入维数过大
        xn = [];
        dn = [];
    else
        xn = zeros(m,len-1-(m-1)*tau);
        for i = 1:m
            xn(i,:) = s(1+(i-1)*tau : len-1-(m-i)*tau);	% 相空间重构，每一行有一个点 
        end
        dn = s(2+(m-1)*tau : end);                      % 预测的目标
    end
elseif (nargout==1)                                     % 当输出参数只有一个
    
    if (len-1-(m-1)*tau < 0)
        disp('err: delay time or the embedding dimension is too large!')
        xn = [];
    else
        xn = zeros(m,len-(m-1)*tau);
        for i = 1:m
            xn(i,:) = s(1+(i-1)*tau : len-(m-i)*tau);	% 相空间重构，每一行是一个点 
        end
    end
end



