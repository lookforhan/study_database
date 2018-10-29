
function t=Write_Inpfile4(net_data,EPA_format,outdata,output_net_filename)
%% 处理数据格式1
formatSpec_out=EPA_format(:,3);
if isempty(outdata)
    new_net_data{1,1}=net_data{1,1};%数据类型
    new_net_data{2,1}=net_data{2,2};%需水节点数据
    new_net_data{3,1}=net_data{3,2};%水厂节点数据
    new_net_data{4,1}=net_data{4,2};%水池节点数据
    new_net_data{5,1}=net_data{5,2};%管线数据
    new_net_data{8,1}=net_data{8,2};%扩散系数数据
    new_net_data{15,1}=net_data{15,2};%需水节点需水量数据
    new_net_data{20,1}=net_data{20,2};%option数据
    new_net_data{23,1}=net_data{23,2};%坐标数据
else
    num=numel(outdata{3}(:,5));
    for i=1:num
        list(i,1)=outdata{3}{i,5};%新建节点类型[JUNCTIONS][RESERVOIRS]
    end
    j_data_index=find(list==1);%新建节点中类型为[JUNCTIONS]的节点
    j_data2=[outdata{3}(j_data_index,1),outdata{3}(j_data_index,4)];%新建节点[JUNCTIONS]的节点数据
    j_data=[outdata{2};j_data2];%需水节点数据
    e_data2=[outdata{3}(j_data_index,1),outdata{3}(j_data_index,10)];%新建节点[JUNCTIONS]的节点扩散系数数据
    e_data=[outdata{7};e_data2];%扩散器
    d_data2=[outdata{3}(j_data_index,1),num2cell(zeros(length(outdata{3}(j_data_index,4)),1))];%需水量
    d_data=[outdata{6};d_data2];% 需水量
    r_data_index=find(list==2);%新建节点中类型为[RESERVOIRS]的节点
    r_data2=[outdata{3}(r_data_index,1),outdata{3}(r_data_index,4)];%新建节点[RESERVOIRS]的节点数据
    r_data=[outdata{4};r_data2];%水厂
    t_data=outdata{5};%水池
    c_data=outdata{8};%坐标
    p_data=outdata{1};%管道
    o_data=net_data{20,2};%option数据
    
    %% 处理数据格式2
    new_net_data{1,1}=net_data{1,1};%数据类型
    new_net_data{2,1}=j_data;%需水节点数据
    new_net_data{3,1}=r_data;%水厂节点数据
    new_net_data{4,1}=t_data;%水池节点数据
    new_net_data{5,1}=p_data;%管线数据
    new_net_data{8,1}=e_data;%扩散系数数据
    new_net_data{15,1}=d_data;%需水节点需水量数据
    new_net_data{20,1}=o_data;%option数据
    new_net_data{23,1}=c_data;%坐标数据
end
%% 打开文件,写入数据
fid=fopen(output_net_filename,'w');
fprintf(fid,'%s',net_data{1,1});
fprintf(fid,'\r\n');
fprintf(fid,'\r\n');
for i=2:length(new_net_data)
    if isempty(new_net_data{i,1})
        continue;
    else
        fprintf(fid,'%s',net_data{i,1});
        fprintf(fid,'\r\n');
        [rows,~]=size(new_net_data{i,1});
        for row=1:rows
            if isempty(new_net_data{i,1}{row,1})
                continue
            end
            fprintf(fid,formatSpec_out{i},new_net_data{i,1}{row,:});
            fprintf(fid,'\r\n');
        end
        fprintf(fid,'\r\n');
    end
end
fprintf(fid,'%s','[END]');
fclose(fid);
t=0;
end