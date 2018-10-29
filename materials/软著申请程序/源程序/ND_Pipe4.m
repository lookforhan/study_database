%%
function [t,pipe_new_add]=ND_Pipe4(damage_node_data,damage_pipe_info,pipe_data)
pipe_new_add=struct('id',[],'N1',[],'N2',[],'Length',[],'Diameter',[],'Roughness',[],'MinorLoss',[]); 
%pipe_new_add�ṹ�壬���ÿ1�������ƻ��ܶ�������Ϣ�����߱��(�ַ���),�����(�ַ���),�յ���(�ַ���),���߳���(m),�ܶ�ֱ��(mm),�س�ˮͷ��ʧĦ��ϵ��,�ֲ�ˮͷ��ʧĦ��ϵ��
M1=damage_pipe_info{1,1};%�ƻ����ߵ�λ�ú�(����)
D2=damage_pipe_info{1,2};
%D2�����ƻ���λ�þ��󣻵�1��Ϊ��1���ƻ��������ĳ���������ܳ��ı�������2��Ϊ��2���ƻ�����1���ƻ���ĳ���������ܳ��ı���...��
n1=numel(M1);%n1�������ƻ����ߵ�������
%% ��ÿ���ƻ������Ͻ����ƻ��ܶ�������Ϣ��
pipe_damage_num=zeros(n1,1); %��ÿ��������Ӧ�÷ָ�ɵĹܶ�������
add_pipe_count=0; %�����ӵĹܶμ�������
for i=1:n1 %���ƻ��Ĺܵ�����¹ܶ�
    damage_pipe_loc=M1(i);%�ƻ�������ڹ����ڹ��������й�����Ϣ�����е���λ�ñ��
    pipe_damage_num(i)=sum(D2(i,:)>0); %��ÿ��������Ӧ�÷ָ�ɵĹܶ�������
    for j=1:pipe_damage_num(i) %��ÿ��������Ӧ�÷ָ�ɵĹܶ���ѭ����
        add_pipe_count=add_pipe_count+1;
        pipe_new_add(add_pipe_count,1).id=['addP-',num2str(damage_pipe_loc),'-',num2str(j)];%�����ɵĹܶα��
        switch j
            case 1 %��1����������ԭ�������
                pipe_new_add(add_pipe_count,1).N1=pipe_data{damage_pipe_loc,2};
                pipe_new_add(add_pipe_count,1).N2=damage_node_data{i,j}.id;
            case pipe_damage_num(i) %����������ԭ�����յ�
                pipe_new_add(add_pipe_count,1).N1=damage_node_data{i,j-1}.id;
                pipe_new_add(add_pipe_count,1).N2=pipe_data{damage_pipe_loc,3};
            otherwise %�������
                pipe_new_add(add_pipe_count,1).N1=damage_node_data{i,j-1}.id;
                pipe_new_add(add_pipe_count,1).N2=damage_node_data{i,j}.id;
        end
        pipe_new_add(add_pipe_count,1).Length=pipe_data{damage_pipe_loc,4}*D2(i,j);%���ߵĳ��ȣ�m��
        pipe_new_add(add_pipe_count,1).Diameter=pipe_data{damage_pipe_loc,5};%���ߵ�ֱ����mm��
        pipe_new_add(add_pipe_count,1).Roughness=pipe_data{damage_pipe_loc,6};%���ߵĴֲ�ϵ��
        pipe_new_add(add_pipe_count,1).MinorLoss=pipe_data{damage_pipe_loc,7};%���ߵľֲ���ʧϵ��
    end
end
t=0;
end