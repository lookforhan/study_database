
function [t,out]=ND_Out_delete4(NID,Nloc,Ploc,pipes,junction,coordinates,net_data)
out=cell(1,8);%�������
%% ɾ�������ڵ���ڽӹ���
pipes(Ploc,:)=[];
out{1}=pipes;
%% �����ڵ�����ͳ��
isolated_node_num=numel(NID);
original_node_num1=numel(net_data{2,2}(:,1));%�û��ڵ�����
original_node_num2=numel(net_data{3,2}(:,1));%ˮԴ�ڵ�����
if isempty(net_data{4,2})
    original_node_num3=0;%ˮ�ؽڵ�����
else
    original_node_num3=numel(net_data{4,2}(:,1));%ˮ�ؽڵ�����    
end

original_node_num=original_node_num1+original_node_num2+original_node_num3;
add_node_num=numel(junction(:,1));
node_num=numel(coordinates(:,1));
if original_node_num+add_node_num~=node_num %���Լ����
    disp('�ڵ��������㲻��ȷ��');
    keyboard;
end
%% ��ʼ�û��ڵ���ɾ�������ڵ�
old_j=net_data{2,2};
mid_loc=ismember(old_j(:,1),NID);
old_j(mid_loc,:)=[];
out{2}=old_j;
%% �����ƻ��ڵ���ɾ�������ڵ�
if ~isempty(junction)%�½ڵ�
    mid_loc=ismember(junction(:,1),NID);
    junction(mid_loc,:)=[];
    out{3}=junction;
else
    out{3}=[];
end
%% ��ʼˮԴ�ڵ���ɾ�������ڵ�
old_r=net_data{3,2};
if ~isempty(net_data{3,2})
    mid_loc=ismember(old_r(:,1),NID);    
    old_r(mid_loc,:)=[];    
    out{4}=old_r;
else
    out{4}=[];
end
%% ��ʼˮ�ؽڵ���ɾ�������ڵ�
old_t=net_data{4,2};
if ~isempty(net_data{4,2})%��ˮ��
    mid_loc=ismember(old_t(:,1),NID);
    old_t(mid_loc,:)=[];
    out{5}=old_t;
else
    out{5}=[];
end
%% ��ʼ�û��ڵ���ˮ����ɾ�������ڵ�
if ~isempty(net_data{15,2})%������
    old_d=net_data{15,2};
    mid_loc=ismember(old_d(:,1),NID);
    old_d(mid_loc,:)=[];   
    out{6}=old_d;
else
    out{6}=[];
end
%% ��ʼ������ɢ����ɾ�������ڵ�
old_e=net_data{8,2};
if ~isempty(old_e)%����ɢ
    mid_loc=ismember(old_e(:,1),NID);
    old_e(mid_loc,:)=[];
    out{7}=old_e;
else
    out{7}=[];
end
%% ���нڵ㣨��ʼ���û���ˮԴ��ˮ�أ��ڵ�+�ƻ��ڵ㣩��������Ϣ��ɾ�������ڵ�
coordinates(Nloc,:)=[];
out{8}=coordinates;
t=0;
end



