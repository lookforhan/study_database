function [out_pre,out_demand]=PDD_run1(inputdata,outputrpt,Hmin,Hdes,circulation_num,node_original_data)
% inputdata=output_net_filename;%输入文件名称
t = libisloaded('epanet2');
if t ==0
    loadlibrary('epanet2.dll',@mylibrarymfile)
end
calllib('epanet2','ENopen',inputdata,'.\temporary\PDD_run1_demage_net.rpt','.\temporary\PDD_run1_EXAMPLE.out');
calllib('epanet2','ENsolveH');% 运行水力计算
calllib('epanet2','ENsaveH');%保存
calllib('epanet2','ENsetreport','NODES ALL'); % 设置输出报告的格式
calllib('epanet2','ENreport'); %输出计算报告
count=libpointer('int32Ptr',0);%指针参数--计数，中间变量
[~,count_node]=calllib('epanet2','ENgetcount',0,count);%全部节点个数
[~,count_tank]=calllib('epanet2','ENgetcount',1,count);%水池和水厂个数
junction_num=count_node-count_tank;%用户节点个数
[~,pressure]=Get(junction_num,11);%节点压力,
calllib('epanet2','ENclose'); %关闭计算
negative_node=find(pressure<0);%负压节点
if ~isempty(negative_node)
    disp('存在负压');
else
    t=1;
    disp('无负压')
    return
end

calllib('epanet2','ENopen',inputdata,outputrpt,'.\temporary\PDD_run1_EXAMPLE.out');%打开inputdata文件
C_mid=ones(junction_num,1);
HMIN=Hmin*C_mid;HDES=Hdes*C_mid;two=2*C_mid;
[~,bdemand]=Get(junction_num,1);%需水量
for n=1:circulation_num%确定循环次数
    calllib('epanet2','ENsolveH');% 运行水力计算
    calllib('epanet2','ENsaveH');%保存
    %---------------检索计算结果
    [~,pre]=Get(junction_num,11);%压力
    [~,bdemand1]=Get(junction_num,1);%需水量
    bdemand2=bdemand1;%bdemand2作为中间变量
    %----------%根据水压处理需水量
    doa = 0.1;
    bdemand1(pre<=Hmin)=0;
    [i2]=find(pre(:,1)>=Hmin&pre(:,1)<=Hdes);
    bdemand1(i2,1)=(bdemand1(i2,1)+bdemand(i2,1).*((pre(i2,1)-HMIN(i2,1))./(HDES(i2,1)-HMIN(i2,1))).^(1/2))./two(i2,1);
    error=abs(bdemand1-bdemand2);
    b=max(abs(error));
    if b<0.1
        calllib('epanet2','ENsaveinpfile','.\temporary\PDD_run1_1111.inp');
        break
    end
    %----------%将处理后需水量输入EPA
    for i=1:junction_num
        calllib('epanet2','ENsetnodevalue',i,1,bdemand1(i,1));
    end
end
calllib('epanet2','ENsetreport','NODES ALL'); % 设置输出报告的格式
calllib('epanet2','ENreport'); %输出计算报告
node_id=node_original_data(:,1);
original_junction_num=numel(node_id);
[out_pre,out_demand]=Get_chosen_node_value(original_junction_num,node_id);

end