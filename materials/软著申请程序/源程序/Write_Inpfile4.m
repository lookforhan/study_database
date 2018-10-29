
function t=Write_Inpfile4(net_data,EPA_format,outdata,output_net_filename)
%% �������ݸ�ʽ1
formatSpec_out=EPA_format(:,3);
if isempty(outdata)
    new_net_data{1,1}=net_data{1,1};%��������
    new_net_data{2,1}=net_data{2,2};%��ˮ�ڵ�����
    new_net_data{3,1}=net_data{3,2};%ˮ���ڵ�����
    new_net_data{4,1}=net_data{4,2};%ˮ�ؽڵ�����
    new_net_data{5,1}=net_data{5,2};%��������
    new_net_data{8,1}=net_data{8,2};%��ɢϵ������
    new_net_data{15,1}=net_data{15,2};%��ˮ�ڵ���ˮ������
    new_net_data{20,1}=net_data{20,2};%option����
    new_net_data{23,1}=net_data{23,2};%��������
else
    num=numel(outdata{3}(:,5));
    for i=1:num
        list(i,1)=outdata{3}{i,5};%�½��ڵ�����[JUNCTIONS][RESERVOIRS]
    end
    j_data_index=find(list==1);%�½��ڵ�������Ϊ[JUNCTIONS]�Ľڵ�
    j_data2=[outdata{3}(j_data_index,1),outdata{3}(j_data_index,4)];%�½��ڵ�[JUNCTIONS]�Ľڵ�����
    j_data=[outdata{2};j_data2];%��ˮ�ڵ�����
    e_data2=[outdata{3}(j_data_index,1),outdata{3}(j_data_index,10)];%�½��ڵ�[JUNCTIONS]�Ľڵ���ɢϵ������
    e_data=[outdata{7};e_data2];%��ɢ��
    d_data2=[outdata{3}(j_data_index,1),num2cell(zeros(length(outdata{3}(j_data_index,4)),1))];%��ˮ��
    d_data=[outdata{6};d_data2];% ��ˮ��
    r_data_index=find(list==2);%�½��ڵ�������Ϊ[RESERVOIRS]�Ľڵ�
    r_data2=[outdata{3}(r_data_index,1),outdata{3}(r_data_index,4)];%�½��ڵ�[RESERVOIRS]�Ľڵ�����
    r_data=[outdata{4};r_data2];%ˮ��
    t_data=outdata{5};%ˮ��
    c_data=outdata{8};%����
    p_data=outdata{1};%�ܵ�
    o_data=net_data{20,2};%option����
    
    %% �������ݸ�ʽ2
    new_net_data{1,1}=net_data{1,1};%��������
    new_net_data{2,1}=j_data;%��ˮ�ڵ�����
    new_net_data{3,1}=r_data;%ˮ���ڵ�����
    new_net_data{4,1}=t_data;%ˮ�ؽڵ�����
    new_net_data{5,1}=p_data;%��������
    new_net_data{8,1}=e_data;%��ɢϵ������
    new_net_data{15,1}=d_data;%��ˮ�ڵ���ˮ������
    new_net_data{20,1}=o_data;%option����
    new_net_data{23,1}=c_data;%��������
end
%% ���ļ�,д������
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