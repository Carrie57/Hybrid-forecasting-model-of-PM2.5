function [xn,dn] = PhaSpaRecon(s,tau,m)
% �������е���ռ��ع� (phase space reconstruction)��Ҳ���������������ݼ�
% [xn, dn] = PhaSpaRecon(s, tau, m)
% ���������     
%               s       ����������(������������������)
%               tau     ���ع�ʱ��
%               m       ���ع�ά��
% ���������
%               xn      ����ռ��еĵ�����(ÿһ��Ϊһ����)
%               dn      ��һ��Ԥ���Ŀ��(������)
%% ������ת��Ϊ�����������ַ�ʽ

% ��һ��
    % [rows,cols] = size(s);
    % if (rows>cols)    % ���Ϊ����������ת��
    %     len = rows;
    %     s = s';       % ת��
    % else              % ��������������򲻱�
    %     len = cols;
    % end
% �ڶ���
    len = length(s);
    s = s(:)';          % ת��Ϊ������
%% �ع���ռ�
if (nargout==2)         % ���������������ʱ
    if (len-1-(m-1)*tau < 1)
        disp('err: delay time or the embedding dimension is too large!')	% �ӳ�ʱ���Ƕ��ά������
        xn = [];
        dn = [];
    else
        xn = zeros(m,len-1-(m-1)*tau);
        for i = 1:m
            xn(i,:) = s(1+(i-1)*tau : len-1-(m-i)*tau);	% ��ռ��ع���ÿһ����һ���� 
        end
        dn = s(2+(m-1)*tau : end);                      % Ԥ���Ŀ��
    end
elseif (nargout==1)                                     % ���������ֻ��һ��
    
    if (len-1-(m-1)*tau < 0)
        disp('err: delay time or the embedding dimension is too large!')
        xn = [];
    else
        xn = zeros(m,len-(m-1)*tau);
        for i = 1:m
            xn(i,:) = s(1+(i-1)*tau : len-(m-i)*tau);	% ��ռ��ع���ÿһ����һ���� 
        end
    end
end



