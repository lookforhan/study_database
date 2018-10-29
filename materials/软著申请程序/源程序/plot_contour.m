%% 为了做供水管网节点SI分布等值线图
% node_coodinate 节点坐标
% pipe_line 节点关系，连线
% node_serviceablility 节点SI
% node_id 节点SI对应的id
function plot_contour(node_coodinate,node_serviceability,node_id)
sum_num=numel(node_coodinate(:,1));
node_x=cell2mat(node_coodinate(:,2));
node_y=cell2mat(node_coodinate(:,3));
node_z=ones(sum_num,1);
for i=1:sum_num 
    
    mid_z=node_serviceability(ismember(node_id,node_coodinate{i,1}));
    if ~isempty(mid_z)
        node_z(i)=mid_z;
    end
end
x1=min(node_x);
x2=max(node_x);
y1=min(node_y);
y2=max(node_y);
[X,Y,Z] = griddata(node_x',node_y',node_z',linspace(x1,x2,100)',linspace(y1,y2,100),'v4');
contourf(X,Y,Z,5)%等值线图
% pcolor(X,Y,Z); %云图



end