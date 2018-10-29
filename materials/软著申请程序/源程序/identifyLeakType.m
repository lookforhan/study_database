classdef identifyLeakType < handle
    properties
        leakType
        probability
        material
    end
    methods
        function obj = identifyLeakType(Material)
             validateattributes(Material,{'pipeMaterial'},{'nonempty'},'identifyLeakType','rand',1);
            obj.material = Material.material;
            PLT_table = readtable('MYTABLE.csv');
            [~,index_1] = ismember(obj.material,PLT_table.PipeMaterial);
            table = PLT_table(index_1,:);
            while ismember(0,table{1,2:end})
            [~,index_2] = ismember(0,table{1,2:end});
            table(:,index_2+1) = [];
            end
            
            obj.probability = table;
        end
        function typeobj = action(obj,rand)
            validateattributes(rand,{'numeric'},{'>=',0,'<=',1},'identifyLeakType acion','rand',1);
            [~,num] = size(obj.probability);
            rand_cum = rand;
            for i = 2:num
                rand_cum = rand_cum - obj.probability{1,i};
                switch i
                    case 2
                        if rand_cum <= obj.probability{1,i}
                            Type = obj.probability.Properties.VariableNames{i};
                            break
                        end
                    otherwise
                        if rand_cum <= (obj.probability{1,i})
                            Type = obj.probability.Properties.VariableNames{i};
                            break
                        end
                end
            end      
            typeobj = leakType.(Type);
            obj.leakType = typeobj;
        end       
    end
end