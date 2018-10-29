classdef Model < handle
    properties
        pdd
        epaFormat
        outputFolder
        Inpfile
        RRfile
        MCnum
        RRdata
        netData
        damageInfo
        
    end
    events
        runOver
    end
    methods
        function obj =Model()
            
            
            load epa_format.mat
            loadlibrary('epanet2.dll',@mylibrarymfile);
            %             validateattributes(errorCode,{'numeric'},{'==',0},'Model','Model_ENopen');
            obj.pdd=PDD_Parameter();
            obj.epaFormat = epa_format;
        end
        function run(obj,input)
            obj.outputFolder = input.outputFolder;
            obj.Inpfile = input.Inpfile;
            obj.RRfile = input.RRfile;
            obj.MCnum = input.MCnum;
            %---------------------
            loadlibrary('epanet2.dll',@mylibrarymfile);
            code=calllib('epanet2','ENopen',obj.Inpfile,'.\temporary\Before_Earthq_rpt','.\temporary\Before_Earthq_out');% 打开管网数据文件
            code=calllib('epanet2','ENsolveH');% 运行水力计算
            count=libpointer('int32Ptr',0);%指针参数--计数，中间变量
            [~,count_node]=calllib('epanet2','ENgetcount',0,count);%全部节点个数
            [~,count_tank]=calllib('epanet2','ENgetcount',1,count);%水池和水厂个数
            original_junction_num=count_node-count_tank;%用户节点个数
            node_original_data=cell(original_junction_num,3);%节点id和初始需水量
            node_original_dem=zeros(original_junction_num,1);
            node_original_pre=zeros(original_junction_num,1);
            node_id_k=libpointer('cstring','node_id_k');
            value_dem=libpointer('singlePtr',0);
            value_pre=libpointer('singlePtr',0);
            
            for k=1:original_junction_num
                [~,node_id_k]=calllib('epanet2','ENgetnodeid',k,node_id_k);
                node_original_data{k,1}=node_id_k;
                [~,value_dem]=calllib('epanet2','ENgetnodevalue',k,1,value_dem);
                node_original_data{k,2}=value_dem;
                node_original_dem(k)=value_dem;
                [~,value_pre]=calllib('epanet2','ENgetnodevalue',k,11,value_pre);
                node_original_data{k,3}=value_pre;
                node_original_pre(k)=value_pre;
            end
            calllib('epanet2','ENclose'); %关闭计算
            unloadlibrary epanet2
            %-------------------------
            mkdir(obj.outputFolder);
            obj.readNet()
            obj.readRR()
            MC_pre_cell = cell(1,obj.MCnum);
            MC_dem_cell = cell(1,obj.MCnum);
            for MC_i = 1:obj.MCnum
                obj.creatDamageInfo();
                damage_inp_File  = [obj.outputFolder,'\damageNet_',num2str(MC_i),'.inp'];
                obj.creatDamageModel(damage_inp_File);
                [PDD_pressure,PDD_demand]=obj.pddRun(damage_inp_File);
                MC_pre_cell{MC_i} = PDD_pressure;
                MC_dem_cell{MC_i} = PDD_demand;
                system_serviceability_giraffe(MC_i)=sum(PDD_demand)/sum(node_original_dem);
                system_serviceability_mean_giraffe(MC_i)=mean(system_serviceability_giraffe(1:MC_i));
                system_serviceability_cov_giraffe(MC_i)=std(system_serviceability_giraffe(1:MC_i))/system_serviceability_mean_giraffe(MC_i);
                if MC_i~=1
                    system_serviceability_mean_difference(MC_i)=(system_serviceability_mean_giraffe(MC_i)-system_serviceability_mean_giraffe(MC_i-1));
                    system_serviceability_cov_difference(MC_i)=(system_serviceability_cov_giraffe(MC_i)-system_serviceability_cov_giraffe(MC_i-1));
                    %                 system_serviceability_mean_difference(i)=(system_serviceability_mean_giraffe(i)-system_serviceability_mean_giraffe(i-1))/system_serviceability_mean_giraffe(i);
                    %         system_serviceability_cov_difference(i)=(system_serviceability_cov_giraffe(i)-system_serviceability_cov_giraffe(i-1))/system_serviceability_cov_giraffe(i);
                else
                    system_serviceability_mean_difference(MC_i)=0;
                    system_serviceability_cov_difference(MC_i)=0;
                end
            end
            MC_pre = cell2mat(MC_pre_cell);
            MC_dem = cell2mat(MC_dem_cell);
            dlmwrite([obj.outputFolder,'\Pressure.txt'],MC_pre,'delimiter','\t','newline','pc','precision','%2.3f');
            dlmwrite([obj.outputFolder,'\demand.txt'],MC_pre,'delimiter','\t','newline','pc','precision','%2.3f');
            %-----------------------------------------------------------------------------------------------------------
            node_coodinate=obj.netData{23,2};
            pipe_line=obj.netData{5,2};
            MC_num=obj.MCnum;
            node_id = node_original_data(:,1);
            
            node_serviceability=sum(MC_dem,2)./(obj.MCnum*node_original_dem);
            summary_picturename = [obj.outputFolder,'\'];
            summary_filename = [obj.outputFolder,'\summary.txt'];
            
            
            each_pre =[node_original_pre,MC_pre];
            each_dem = [node_original_dem ,MC_dem];
            % system_serviceability_giraffe
            % system_serviceability_mean_giraffe
            % system_serviceability_mean_difference
            % system_serviceability_cov_giraffe
            % system_serviceability_cov_difference
            export_file(node_coodinate,node_serviceability,node_id,pipe_line,MC_num,summary_picturename,summary_filename,original_junction_num,each_pre,each_dem,...
                system_serviceability_giraffe,system_serviceability_mean_giraffe,system_serviceability_mean_difference,system_serviceability_cov_giraffe...
                ,system_serviceability_cov_difference)
            obj.notify('runOver');
        end
        function readNet(obj)
            Net = readNETdata(obj.Inpfile);
            Net.pre_readData();
            Net.readData();
            obj.netData = Net.netData;
            Net.delete();
        end
        function readRR(obj)
            RR = readRRdata(obj.RRfile);
            RR.RRdata = readtable(RR.file);
            obj.RRdata = RR.RRdata;
            RR.delete();
        end
        function creatDamageInfo(obj)
            Damage = creatDamageInfo(obj.RRdata);
            Damage.run();
            obj.damageInfo = Damage.damageInfo;
            Damage.delete();
        end
        function creatDamageModel(obj,damage_inp_file)
            epa_format = obj.epaFormat;
            net_data = obj.netData;
            damage_pipe_info =[{obj.damageInfo.damagePipe_num},...
                {obj.damageInfo.damageNode_length},...
                {obj.damageInfo.damageNode_type},...
                {obj.damageInfo.damageNode_leakC}];
            [t,damage_node_data]=ND_Junction5(net_data,damage_pipe_info);
            [t_p,pipe_new_add]=ND_Pipe4(damage_node_data,damage_pipe_info,net_data{5,2});
            [t,all_add_node_data,pipe_new_add]=ND_P_Leak3(damage_node_data,damage_pipe_info,pipe_new_add);
            pipe_data=net_data{5,2};
            pipe_data(damage_pipe_info{1,1},:)=[];
            mid_data=(struct2cell(pipe_new_add))';
            all_pipe_data=[pipe_data;mid_data];
            
            dataP=all_pipe_data(:,1:3);
            dataR=net_data{3,2}(:,1);
            dataC=[net_data{23,2}(:,1);all_add_node_data(:,1)];
            if ~isempty(net_data{4,2})
                dataT=net_data{4,2}(:,1);
            else
                dataT=[];
            end
            [isolated_node_num,Nid,Nloc,Pid,Ploc]=NC_bfs3(dataP,dataR,dataC,dataT);
            %             all_node_coordinate=[net_data{23,2};all_add_node_data(:,1:3)];
            all_node_coordinate=[net_data{23,2};all_add_node_data(:,1:3)]; %所有节点坐标（包括水源、水池、用户节点）；!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            if isolated_node_num==0
                disp('破损管网连通性检查完成,不存在孤立节点！')
                [~,outdata]=ND_Out_no_delete(all_pipe_data,all_add_node_data,all_node_coordinate,net_data);
            else
                disp(['破损管网连通性检查完成，存在', num2str(isolated_node_num),'个孤立节点，孤立节点及其邻接管段已删除！'])
                [~,outdata]=ND_Out_delete4(Nid,Nloc,Ploc,all_pipe_data,all_add_node_data,all_node_coordinate,net_data);
            end
            t_W=Write_Inpfile4(net_data,epa_format,outdata,damage_inp_file);
        end
        function [PDD_pressure,PDD_demand]=pddRun(obj,inpfile)
            node_original_data = obj.netData{2,2};
            out_rpt = '.\temporary\out.rpt';
            [PDD_pressure,PDD_demand]=PDD_run1(inpfile,out_rpt,obj.pdd.Hmin,obj.pdd.Hdes,obj.pdd.circulation_num,node_original_data);
        end
    end
end