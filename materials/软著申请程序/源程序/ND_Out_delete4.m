
function [t,out]=ND_Out_delete4(NID,Nloc,Ploc,pipes,junction,coordinates,net_data)
out=cell(1,8);%输出变量
%% 删除孤立节点的邻接管线
pipes(Ploc,:)=[];
out{1}=pipes;
%% 管网节点数量统计
isolated_node_num=numel(NID);
original_node_num1=numel(net_data{2,2}(:,1));%用户节点数量
original_node_num2=numel(net_data{3,2}(:,1));%水源节点数量
if isempty(net_data{4,2})
    original_node_num3=0;%水池节点数量
else
    original_node_num3=numel(net_data{4,2}(:,1));%水池节点数量    
end

original_node_num=original_node_num1+original_node_num2+original_node_num3;
add_node_num=numel(junction(:,1));
node_num=numel(coordinates(:,1));
if original_node_num+add_node_num~=node_num %调试检查用
    disp('节点数量计算不正确！');
    keyboard;
end
%% 初始用户节点中删除孤立节点
old_j=net_data{2,2};
mid_loc=ismember(old_j(:,1),NID);
old_j(mid_loc,:)=[];
out{2}=old_j;
%% 新增破坏节点中删除孤立节点
if ~isempty(junction)%新节点
    mid_loc=ismember(junction(:,1),NID);
    junction(mid_loc,:)=[];
    out{3}=junction;
else
    out{3}=[];
end
%% 初始水源节点中删除孤立节点
old_r=net_data{3,2};
if ~isempty(net_data{3,2})
    mid_loc=ismember(old_r(:,1),NID);    
    old_r(mid_loc,:)=[];    
    out{4}=old_r;
else
    out{4}=[];
end
%% 初始水池节点中删除孤立节点
old_t=net_data{4,2};
if ~isempty(net_data{4,2})%旧水池
    mid_loc=ismember(old_t(:,1),NID);
    old_t(mid_loc,:)=[];
    out{5}=old_t;
else
    out{5}=[];
end
%% 初始用户节点需水量中删除孤立节点
if ~isempty(net_data{15,2})%旧需求
    old_d=net_data{15,2};
    mid_loc=ismember(old_d(:,1),NID);
    old_d(mid_loc,:)=[];   
    out{6}=old_d;
else
    out{6}=[];
end
%% 初始管网扩散器中删除孤立节点
old_e=net_data{8,2};
if ~isempty(old_e)%旧扩散
    mid_loc=ismember(old_e(:,1),NID);
    old_e(mid_loc,:)=[];
    out{7}=old_e;
else
    out{7}=[];
end
%% 所有节点（初始（用户，水源，水池）节点+破坏节点）的坐标信息中删除孤立节点
coordinates(Nloc,:)=[];
out{8}=coordinates;
t=0;
end



