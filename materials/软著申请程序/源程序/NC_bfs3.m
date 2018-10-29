

function [isolated_node_num,Nid,Nloc,Pid,Ploc]=NC_bfs3(P,R,C,T)
C0=C;
P0=P;
if isempty(R)
    disp('无水源')
    n_R_loc=[];
else
    n_R_loc=find(ismember(C0,R)); %水源点位置号
end
if isempty(T)
    disp('无水水池')
    n_T_loc=[];
else
    n_T_loc=find(ismember(C0,T)); %水池点位置号
end
%% 建立邻接矩阵和关联矩阵
node_num=numel(C0(:,1));
pipe_num=numel(P0(:,1));
GLmatrix=zeros(pipe_num,node_num); %管网的关联矩阵
LJmatrix=zeros(node_num); %管网的邻接矩阵   
for i=1:pipe_num
    n_h=find(ismember(C0,P0{i,2}));%当前管段的起点位置号
    n_l=find(ismember(C0,P0{i,3}));%当前管段的终点位置号
    GLmatrix(i,n_l)=1;
    GLmatrix(i,n_h)=-1;
    LJmatrix(n_h,n_l)=1;
    LJmatrix(n_l,n_h)=1;
end 
    
%% 虚拟水源点及虚拟邻接矩阵和虚拟关联矩阵
source_node=1; %处理多源点问题的虚拟源点节点位置号
mid_data1=zeros(1,node_num);
mid_data1(n_R_loc)=1;
mid_data1(n_T_loc)=1;
mid_data2=mid_data1';
mid_data3=[0;mid_data2];
LJ=[mid_data1;LJmatrix];
LJ=[mid_data3,LJ];
%% 孤立节点
[dd,~]=bfs_mex(sparse(LJ),source_node,0); %dd为node_num*1的一维向量,在BFS求解返回值为汇点所在的BFS层号，源点的为0，不连通点的为-1
isolated_node=find(dd<0);
if isempty(isolated_node) %不存在孤立节点
    isolated_node_num=0;
    Nid=[];Nloc=[];
    Pid=[];Ploc=[];
else %存在孤立节点
    isolated_node_num=numel(isolated_node);
    isolated_node=isolated_node-1; %去除虚拟源点后的孤立节点位置号；
    Nid=C(isolated_node); % 孤立节点的编号；
    Nloc=isolated_node; %孤立节点的位置号；
%     delete_node_loc=numel(isolated_node_num); %存储每个孤立节点（与源点孤立，但可能存在邻接管段）在关联矩阵中对应的管段位置号
delete_pipe_loc=0;
    for i=1:isolated_node_num
        delete_pipe_loc1=find(GLmatrix(:,isolated_node(i))); %找出孤立节点（与源点孤立，但可能存在邻接管段）在关联矩阵中对应的管段位置号;
        delete_pipe_loc=[delete_pipe_loc;delete_pipe_loc1];
    end
    delete_pipe_loc(1)=[];
    Ploc=unique(delete_pipe_loc);%孤立管段的位置号
    Pid=P0(Ploc); %孤立管段的编号
end
end
