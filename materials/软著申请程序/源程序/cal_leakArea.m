classdef cal_leakArea < handle
    enumeration
        AD (AD())% Annular Disengagement
        RC (RC())% Round Crack
        LC (LC())% Longitudinal Crack
        LL (LL())% Local Loss of Pipe Wall
        LT (LT)% Local Tear of Pipe Wall
    end
    properties
        strategyObj
    end
    methods
        function obj = cal_leakArea(leakType)
            obj.strategyObj = leakType;
        end
        function leakArea = action(obj,D)
            leakArea=obj.strategyObj.action(D);
        end
    end
end