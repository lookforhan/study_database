%%
function [t,pipe_new_add]=ND_Pipe4(damage_node_data,damage_pipe_info,pipe_data)
pipe_new_add=struct('id',[],'N1',[],'N2',[],'Length',[],'Diameter',[],'Roughness',[],'MinorLoss',[]); 
%pipe_new_add结构体，存放每1段新增破坏管段属性信息：管线编号(字符串),起点编号(字符串),终点编号(字符串),管线长度(m),管段直径(mm),沿程水头损失摩阻系数,局部水头损失摩阻系数
M1=damage_pipe_info{1,1};%破坏管线的位置号(向量)
D2=damage_pipe_info{1,2};
%D2管线破坏点位置矩阵；第1列为第1个破坏点距管起点的长度与管线总长的比例，第2列为第2个破坏点距第1个破坏点的长度与管线总长的比例...；
n1=numel(M1);%n1管网中破坏管线的数量；
%% 在每条破坏管线上建立破坏管段属性信息；
pipe_damage_num=zeros(n1,1); %在每条管线上应该分割成的管段数量；
add_pipe_count=0; %新增加的管段计数器；
for i=1:n1 %对破坏的管道添加新管段
    damage_pipe_loc=M1(i);%破坏点的所在管线在管网中所有管线信息矩阵中的行位置编号
    pipe_damage_num(i)=sum(D2(i,:)>0); %在每条管线上应该分割成的管段数量；
    for j=1:pipe_damage_num(i) %在每条管线上应该分割成的管段数循环；
        add_pipe_count=add_pipe_count+1;
        pipe_new_add(add_pipe_count,1).id=['addP-',num2str(damage_pipe_loc),'-',num2str(j)];%新生成的管段编号
        switch j
            case 1 %第1个管线连接原管线起点
                pipe_new_add(add_pipe_count,1).N1=pipe_data{damage_pipe_loc,2};
                pipe_new_add(add_pipe_count,1).N2=damage_node_data{i,j}.id;
            case pipe_damage_num(i) %最后管线连接原管线终点
                pipe_new_add(add_pipe_count,1).N1=damage_node_data{i,j-1}.id;
                pipe_new_add(add_pipe_count,1).N2=pipe_data{damage_pipe_loc,3};
            otherwise %其他情况
                pipe_new_add(add_pipe_count,1).N1=damage_node_data{i,j-1}.id;
                pipe_new_add(add_pipe_count,1).N2=damage_node_data{i,j}.id;
        end
        pipe_new_add(add_pipe_count,1).Length=pipe_data{damage_pipe_loc,4}*D2(i,j);%管线的长度（m）
        pipe_new_add(add_pipe_count,1).Diameter=pipe_data{damage_pipe_loc,5};%管线的直径（mm）
        pipe_new_add(add_pipe_count,1).Roughness=pipe_data{damage_pipe_loc,6};%管线的粗糙系数
        pipe_new_add(add_pipe_count,1).MinorLoss=pipe_data{damage_pipe_loc,7};%管线的局部损失系数
    end
end
t=0;
end