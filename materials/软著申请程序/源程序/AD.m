%AD :Annular Disengagement
classdef AD < creatLeakBase
    properties
        t = 10;%mm
        k = 0.3;
        leakarea
    end
    methods
        
        function leakArea  = action(obj,Diameter)
%             t = 10;%mm
%             k = 0.3;
            leakArea = obj.t*obj.k*pi*Diameter^2;
            obj.leakarea = leakArea;
        end
    end
end