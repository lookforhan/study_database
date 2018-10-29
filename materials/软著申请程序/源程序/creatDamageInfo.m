% name:creatDamageInfo.m
classdef creatDamageInfo < handle
    properties
        RRdata
        damageInfo
        damageNum = 100;
        damageInfo_loc
        p_break
        leakType
        leakArea
        leakC
        leakD
        C = 4472
        mu = 0.61
    end
    methods
        function obj = creatDamageInfo(RRdata)

            obj.RRdata = RRdata;
            pipe_num = numel(obj.RRdata.PipeID(:,1));
            obj.leakType = cell(pipe_num,obj.damageNum);
            obj.leakArea = zeros(pipe_num,obj.damageNum);
            obj.leakC = zeros(pipe_num,obj.damageNum);
            obj.leakD = zeros(pipe_num,obj.damageNum);
            obj.p_break = 0.2;
            
        end
        function run(obj)
            
            pipe_num = numel(obj.RRdata.PipeID(:,1));
            RR = obj.RRdata.RR*ones(1,obj.damageNum);
            Length = obj.RRdata.Length_km_*ones(1,obj.damageNum);
            
            D1 = zeros(pipe_num,1);
            %             D2 = zeros(pipe_num,obj.damageNum);
            rand_mu_2 = rand(pipe_num,obj.damageNum);
            D3 = zeros(pipe_num,obj.damageNum);
            D33 = zeros(pipe_num,obj.damageNum);
            D4 = zeros(pipe_num,obj.damageNum);
            
            rand_mu_1 = rand(pipe_num,obj.damageNum);
            damageLength = -(log(ones(pipe_num,obj.damageNum)-rand_mu_1)./RR);
            damageLengthNormal = damageLength./Length;
            damageLengthNormalSum = cumsum(damageLengthNormal,2);
            
            D1(damageLengthNormalSum(:,1)<1) = 1;
            D2 = damageLengthNormalSum;
            D2(damageLengthNormalSum>=1) = 0;
            rand_mu_2(D2 == 0)=0;
            
            D3(D2~=0)=1;
           
            D3(rand_mu_2<obj.p_break*D3) = 2;%break node.
             D33(D3==1)=1;
            rand_mu_3 =rand(pipe_num,obj.damageNum).*(D33);
            for i = 1:pipe_num
                if any(rand_mu_3(i,:))
                    material = pipeMaterial.(obj.RRdata.Material{i});
                    nodeLeakType = identifyLeakType(material);
                    for j = 1:obj.damageNum
                        if rand_mu_3(i,j) ~= 0
                            type = nodeLeakType.action(rand_mu_3(i,j));
                            obj.leakType{i,j} = type;
                            mid = cal_leakArea.(char(type));
                            
                            obj.leakArea(i,j) = mid.action(obj.RRdata.Diameter_mm_(i));
                            obj.leakD(i,j) = (4*obj.leakArea(i,j)/pi)^(0.5);
                            obj.leakC(i,j) = obj.C * obj.mu * obj.leakArea(i,j)/1000000;
                        end
                    end
                else
                    continue
                end
                
            end
            
            %leak c
            
            
            M1 = find(D1>0);
            pipe_damage_num=sum(sum(D2)>0); 
            D4 = obj.leakC;
            obj.damageInfo = damageInformation();
            obj.damageInfo.damagePipe_num = M1;
            obj.damageInfo.damageNode_length = D2(M1,1:pipe_damage_num);
            obj.damageInfo.damageNode_type = D3(M1,1:pipe_damage_num);
            obj.damageInfo.damageNode_leakC = D4(M1,1:pipe_damage_num);
        end
    end
end