%name:readNETdata.m
classdef readNETdata < handle
    properties
        file
        FID
        errorCode
        keyword
        format_data
        data_size
        netData
        temp
    end
    methods
        function obj = readNETdata(file)
            obj.file = file;
            temp_file = '.\temporary\readNETdata_net.inp';
            t = libisloaded('epanet2');
            if t ==0
            loadlibrary('epanet2.dll',@mylibrarymfile)
            end
            obj.errorCode=calllib('epanet2','ENopen',file,'.\temporary\readNETdata_net.rpt','.\temporary\readNETdata_net.out');
            errorCode2=calllib('epanet2','ENsaveinpfile',temp_file);
            validateattributes(errorCode2,{'numeric'},{'>=',0},'ENsaveinpfile');
            obj.FID=fopen(temp_file);
            load epa_format.mat
            obj.keyword = epa_format(:,1);
            obj.format_data = epa_format(:,2);
            
        end
        function delete(obj)
            fclose(obj.FID);
        end
        function pre_readData(obj)
            keyword_num = numel(obj.keyword);
            kw_data_lines_num=zeros(keyword_num,1);%
            kw_data_lines_end=zeros(keyword_num,1);
            lines_count = 0;
            frewind(obj.FID)
            while ~feof(obj.FID)
                str1 = fgetl(obj.FID);
                lines_count=lines_count+1;
                if isempty(str1) %
                    continue; %
                elseif str1(1)==';'
                    continue;
                elseif str1(1)=='['
                    str2=deblank(str1);
                    [~,newsect] = ismember(str2,obj.keyword);
                    
                    sect = -1;
                    if newsect > 0
                        sect = newsect;
                        continue
                    end
                end
                
                if sect > 0
                    kw_data_lines_num(sect)=kw_data_lines_num(sect)+1;
                    kw_data_lines_end(sect)=lines_count;
                end
            end
            obj.data_size=[kw_data_lines_num,kw_data_lines_end,kw_data_lines_end-kw_data_lines_num];
        end
        function readData(obj)
            keyword_num = numel(obj.keyword);
            data_origin = cell (keyword_num,1);
            for i = 1:keyword_num
                frewind(obj.FID)
                if obj.data_size(i,1) == 0
                    continue
                end
                mid_data=textscan(obj.FID,obj.format_data{i,1},obj.data_size(i,1),...
                    'headerlines',obj.data_size(i,3));
                data_character_num=numel(mid_data);
                mid_data2=[];
                for j=1:data_character_num
                    if isnumeric(mid_data{j})
                        mid_data1=num2cell(mid_data{j});
                    else
                        mid_data1=deblank(mid_data{j});
                    end
                    mid_data2=[mid_data2,mid_data1];
                end
                data_origin{i,1}=mid_data2;
            end
                        obj.netData=[obj.keyword(:,1),data_origin(:,1)];
%                         obj.netData=[obj.keyword(:,1),mid_data];
%             obj.netData=data_origin;
        end
    end
end