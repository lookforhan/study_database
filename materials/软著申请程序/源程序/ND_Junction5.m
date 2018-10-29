
function [t,damage_node_data]=ND_Junction5(net_data,damage_pipe_info) 
%% ����׼��
M1=damage_pipe_info{1,1};%�ƻ����߱�ŵ��±�
D2=damage_pipe_info{1,2};
%D2�����ƻ���λ�þ��󣻵�1��Ϊ��1���ƻ��������ĳ���������ܳ��ı�������2��Ϊ��2���ƻ�����1���ƻ���ĳ���������ܳ��ı���...��
M2=cumsum(D2,2);%D2���ۼ�,�ƻ���λ�õ���߳��ȵı���
D3=damage_pipe_info{1,3};
%D3�����ƻ����ƻ����;��󣻵�1��Ϊ��1���ƻ�������ͣ�1��©/0�Ͽ�����2��Ϊ��2���ƻ�������ͣ�1��©/0�Ͽ�...��
D4=damage_pipe_info{1,4};
%D4����й©�����ɢ��ϵ�����󣺵�1��Ϊ��1���ƻ����й©��ɢ��ϵ�������˵�Ϊ�Ͽ��㣬�����ֵΪ0����ɢ��ϵ������©ˮ��LPS��λ���㣻
 if isempty(net_data{4,2})
     Elve_data=[[net_data{2,2}(:,1);net_data{3,2}(:,1)],...
    [net_data{2,2}(:,2);net_data{3,2}(:,2)]]; %���������нڵ㣨�û��ڵ㣬ˮ���ڵ㣬ˮ�ؽڵ㣩�ģ�1��ţ�2�̣߳�ˮ���ڵ�߳��õ���ˮͷ��������
 else
     Elve_data=[[net_data{2,2}(:,1);net_data{3,2}(:,1);net_data{4,2}(:,1)],...
    [net_data{2,2}(:,2);net_data{3,2}(:,2);net_data{4,2}(:,2)]]; %���������нڵ㣨�û��ڵ㣬ˮ���ڵ㣬ˮ�ؽڵ㣩�ģ�1��ţ�2�̣߳�ˮ���ڵ�߳��õ���ˮͷ��������
 end

pipe_data=net_data{5,2};%���߱��,�����,�յ���,����(m),ֱ��(mm),Ħ��ϵ��,�ֲ���ʧϵ��
coordinate_data=net_data{23,2};%�ڵ��ţ�x���꣬y����
%% ����Ԥ����
damage_node_character=struct('id',[],'x',[],'y',[],'Elve',[],'type',[],'pipe',{},'pipe_index',[],'order',[],'length',[],'Coefficient',[]);%����½ڵ���Ϣ�Ľṹ��
[n1,n2]=size(D2);%n1�������ƻ����ߵ�������n2���ߵ�ʵ���ƻ�����������ֵ��
pipe_damage_num=zeros(n1,1); %��ÿ�������ϲ����ƻ����������
damage_node_data=cell(n1,n2-1); %�洢������ÿ���ƻ����������Ϣ,ÿ��Ԫ�ش洢ÿ���ƻ����������Ϣ�ṹ��damage_node_character��
%% �����к��ƻ���Ĺ��ߣ������ƻ��㣻
for i=1:n1 %�ƻ����ߵ�����
    damage_pipe_loc=M1(i); %�ƻ������ڹ��������й������ݾ������λ�úţ����ƻ����ߵı�ţ��ַ��ͣ���
    pipe_damage_num(i)=sum(D2(i,:)>0);
    %% ��ʼ����������Ϣ׼��
    %������ֹ����
    N1=pipe_data{damage_pipe_loc,2};%���������
    N2=pipe_data{damage_pipe_loc,3};%�����յ���
    %������ֹ��߳�
    N1_elve=Elve_data{ismember(Elve_data(:,1),N1),2};%N1�߳�
    N2_elve=Elve_data{ismember(Elve_data(:,1),N2),2};%N2�߳�
    %������ֹ�������
    num_id1=ismember(coordinate_data(:,1),N1);%N1�ڽڵ��������ݾ����е��к�λ��
    num_id2=ismember(coordinate_data(:,1),N2);%N2�ڽڵ��������ݾ����е��к�λ��
    N1_x=coordinate_data{num_id1,2};%�ƻ����ߵ�����x����
    N1_y=coordinate_data{num_id1,3};%�ƻ����ߵ�����y����
    N2_x=coordinate_data{num_id2,2};%�ƻ����ߵ��յ��x����
    N2_y=coordinate_data{num_id2,3};%�ƻ����ߵ��յ��y����
    for j=1:pipe_damage_num(i) %�ڵ�i���ƻ������ϴ�����j���ƻ���     
        %% �����е��ƻ������Ը�ֵ
        %�����ƻ���߳�
        L_ratio=M2(i,j);%�ƻ���������㳤������߳��ȵı���
        damage_node_character(1).Elve=((1-L_ratio)*N1_elve+L_ratio*N2_elve);%�ƻ���߳�
        %�����ƻ��������
        damage_node_character(1).x=(1-L_ratio)*N1_x+L_ratio*N2_x;%�ƻ����x����
        damage_node_character(1).y=(1-L_ratio)*N1_y+L_ratio*N2_y;%�ƻ����y����
        damage_node_character(1).order=j;%�ƻ�����ȣ��ڼ�����
        damage_node_character(1).length=D2(i,j);%�ƻ���ĳ��ȱ���
        damage_node_character(1).Coefficient=D4(i,j);%�ƻ������ɢϵ��        
        damage_node_character(1).pipe=pipe_data{damage_pipe_loc,1};%�ƻ�������ڹ��߱��
        damage_node_character(1).pipe_index=damage_pipe_loc;%�ƻ�������ڹ��ߵ�λ�ñ��
        damage_node_character(1).id=['add_node-',num2str(damage_pipe_loc),'-',num2str(j)];%�ƻ����������
        if D3(i,j)==1
            damage_node_character(1).type=1;%�ƻ�������Ϊ��©
        else
            damage_node_character(1).type=2;%�ƻ�������Ϊ�Ͽ�
        end
        %% �����ƻ������Դ洢
        damage_node_data{i,j}=damage_node_character(1);%���ƻ����������Ϣ����Ԫ�������У�
    end
end
t=0;
end
