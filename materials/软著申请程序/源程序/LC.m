% LC % Longitudinal Crack
classdef LC < creatLeakBase
    properties
        thita = 0.1*2*pi/360;%rad
        L = 30*1000;%mm
        leakarea
    end
    methods
        function leakArea  = action(obj,Diameter)
            leakArea = obj.thita * obj.L * Diameter;
            obj.leakarea = leakArea;
        end
    end
end