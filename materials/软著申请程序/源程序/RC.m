% RC % Round Crack
classdef RC < creatLeakBase
    properties
        thita = 0.5*2*pi/360;%rad
%         k = 0.3;
        leakarea
    end
    methods
        function leakArea  = action(obj,Diameter)
            leakArea = 0.5 * obj.thita * pi * Diameter^2;
            obj.leakarea = leakArea;
        end
    end
end