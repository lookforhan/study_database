

function [isolated_node_num,Nid,Nloc,Pid,Ploc]=NC_bfs3(P,R,C,T)
C0=C;
P0=P;
if isempty(R)
    disp('��ˮԴ')
    n_R_loc=[];
else
    n_R_loc=find(ismember(C0,R)); %ˮԴ��λ�ú�
end
if isempty(T)
    disp('��ˮˮ��')
    n_T_loc=[];
else
    n_T_loc=find(ismember(C0,T)); %ˮ�ص�λ�ú�
end
%% �����ڽӾ���͹�������
node_num=numel(C0(:,1));
pipe_num=numel(P0(:,1));
GLmatrix=zeros(pipe_num,node_num); %�����Ĺ�������
LJmatrix=zeros(node_num); %�������ڽӾ���   
for i=1:pipe_num
    n_h=find(ismember(C0,P0{i,2}));%��ǰ�ܶε����λ�ú�
    n_l=find(ismember(C0,P0{i,3}));%��ǰ�ܶε��յ�λ�ú�
    GLmatrix(i,n_l)=1;
    GLmatrix(i,n_h)=-1;
    LJmatrix(n_h,n_l)=1;
    LJmatrix(n_l,n_h)=1;
end 
    
%% ����ˮԴ�㼰�����ڽӾ���������������
source_node=1; %�����Դ�����������Դ��ڵ�λ�ú�
mid_data1=zeros(1,node_num);
mid_data1(n_R_loc)=1;
mid_data1(n_T_loc)=1;
mid_data2=mid_data1';
mid_data3=[0;mid_data2];
LJ=[mid_data1;LJmatrix];
LJ=[mid_data3,LJ];
%% �����ڵ�
[dd,~]=bfs_mex(sparse(LJ),source_node,0); %ddΪnode_num*1��һά����,��BFS��ⷵ��ֵΪ������ڵ�BFS��ţ�Դ���Ϊ0������ͨ���Ϊ-1
isolated_node=find(dd<0);
if isempty(isolated_node) %�����ڹ����ڵ�
    isolated_node_num=0;
    Nid=[];Nloc=[];
    Pid=[];Ploc=[];
else %���ڹ����ڵ�
    isolated_node_num=numel(isolated_node);
    isolated_node=isolated_node-1; %ȥ������Դ���Ĺ����ڵ�λ�úţ�
    Nid=C(isolated_node); % �����ڵ�ı�ţ�
    Nloc=isolated_node; %�����ڵ��λ�úţ�
%     delete_node_loc=numel(isolated_node_num); %�洢ÿ�������ڵ㣨��Դ������������ܴ����ڽӹܶΣ��ڹ��������ж�Ӧ�Ĺܶ�λ�ú�
delete_pipe_loc=0;
    for i=1:isolated_node_num
        delete_pipe_loc1=find(GLmatrix(:,isolated_node(i))); %�ҳ������ڵ㣨��Դ������������ܴ����ڽӹܶΣ��ڹ��������ж�Ӧ�Ĺܶ�λ�ú�;
        delete_pipe_loc=[delete_pipe_loc;delete_pipe_loc1];
    end
    delete_pipe_loc(1)=[];
    Ploc=unique(delete_pipe_loc);%�����ܶε�λ�ú�
    Pid=P0(Ploc); %�����ܶεı��
end
end
