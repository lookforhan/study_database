%%
function [t,all_add_node_data,pipe_new_add]=ND_P_Leak3(damage_node_data,damage_pipe_info,pipe_new_add)
M1=damage_pipe_info{1,1}; %破坏管线的位置号(向量)
D2=damage_pipe_info{1,2};
%D2管线破坏点位置矩阵；第1列为第1个破坏点距管起点的长度与管线总长的比例，第2列为第2个破坏点距第1个破坏点的长度与管线总长的比例...；
D3=damage_pipe_info{1,3};
%D3管线破坏点破坏类型矩阵；第1列为第1个破坏点的类型：1渗漏/2断开；第2列为第2个破坏点的类型：1渗漏/2断开...；
n1=numel(M1);%n1管网中破坏管线的数量；
%% 将破坏点的属性信息damage_node_data，从二维元胞数据转化为一维元胞数组damage_node_data_solo;
damage_node_num=sum(sum(D2>0));%全部管线中全部破坏点的数量（不含断开点增加的另1节点）；
damage_node_data_solo=cell(damage_node_num,1); %存储破坏点属性信息结构体的元胞数据向量，每个元素为该破坏点的属性信息结构体；
damage_node_count=0; %破坏点计数器；
for i=1:n1
    pipe_damage_num=sum(D2(i,:)>0); %在每条管线上破坏点的数量；
    for j=1:pipe_damage_num
        damage_node_count=damage_node_count+1;
        damage_node_data_solo{damage_node_count,1}=damage_node_data{i,j};
    end
end
%% 判别破坏节点的类型，若为断开需增加新的破坏点，若为渗漏则不必处理；
break_node_num=sum(sum(D3==2)); %全部管线中断开破坏点的数量（需要增加的另1节点的数量）；
break_node_data=cell(break_node_num,1); %存储断开破坏点新增另1节点的属性信息结构体的元胞数据向量，每个元素为该新增节点的属性信息结构体；
n2=0; %为断开点新增的破坏点计数器；
for i=1:length(damage_node_data_solo) %所有破坏点循环；
    if damage_node_data_solo{i}.type==2 %发现断开节点
        n2=n2+1;%增加破坏节点计数；
        break_node_data{n2,1}=damage_node_data_solo{i};
        break_node_data{n2,1}.id=[damage_node_data_solo{i}.id,'-',num2str(2)];
        for j=1:length(pipe_new_add) %对所有增加的管段循环，查找哪个新增管段的起点为此节点；
            if strncmp(pipe_new_add(j).N1,damage_node_data_solo{i}.id,255)
                pipe_new_add(j).N1=break_node_data{n2,1}.id;
            end
        end
    end
end
%% 将破坏点的结构体属性信息转换为元胞数组；将破坏点的属性信息（上部）与断开点增加的另1破坏点属性信息（下部）合并[上部；下部]；
if isempty(damage_node_data_solo)
    keyboard
end
mid_data=(struct2cell(damage_node_data_solo{1}))'; %数据转换的中间变量；
n3=numel(mid_data); %破坏节点属性信息结构体中属性的个数；
all_add_node_data=cell(damage_node_num+break_node_num,n3);
%----------------------------------------------------------
%结构体数据中间转换
for i=1:damage_node_num
    mid_data1(i)=damage_node_data_solo{i};
end
mid_data2=struct2cell(mid_data1);
mid_data3=reshape(mid_data2,[n3,damage_node_num]);
%-----------------------------------------------------------
all_add_node_data(1:damage_node_num,:)=mid_data3';
%----------------------------------------------------------
%结构体数据中间转换
if break_node_num~=0
    for i=1:break_node_num
        mid_data11(i)=break_node_data{i};
    end
    mid_data2=struct2cell(mid_data11);
    mid_data3=reshape(mid_data2,[n3,break_node_num]);
    %-----------------------------------------------------------
    all_add_node_data(damage_node_num+1:end,:)=mid_data3';
end
t=0;
end