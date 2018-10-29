
%%
function [t,outdata]=ND_Out_no_delete(data_pipe,data_new_node,dataC1,net_data)
outdata{1}=data_pipe;
if ~isempty(net_data{2,2})%
    outdata{2}=net_data{2,2};
else
    outdata{2}=[];
end
if ~isempty(data_new_node)%
    outdata{3}=data_new_node;
else
    outdata{3}=[];
end
if ~isempty(net_data{3,2})%
    outdata{4}=net_data{3,2};
else
    outdata{4}=[];
end
if ~isempty(net_data{4,2})%
    outdata{5}=net_data{4,2};
else
    outdata{5}=[];
end
if ~isempty(net_data{15,2})%demand
    outdata{6}=net_data{15,2};
else
    outdata{6}=[];
end
if ~isempty(net_data{8,2})%emitters
    outdata{7}=net_data{8,2};
else
    outdata{7}=[];
end
outdata{8}=dataC1;
t=0;
end