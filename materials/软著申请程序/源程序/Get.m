

function [t,value1]=Get(junction_num,n)
value=libpointer('singlePtr',0);%ָ�����--ֵ
value1=zeros(junction_num,1);
    for i=1:junction_num
        [~,value]=calllib('epanet2','ENgetnodevalue',i,n,value);%11����ˮѹ
        value1(i,1)=value;        
    end
    t=0;
end