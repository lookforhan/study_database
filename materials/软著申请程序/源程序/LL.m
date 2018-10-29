% LL % Local Loss of Pipe Wall
classdef LL < creatLeakBase
    properties
        k1 = 0.05;%5%
        k2 = 0.05;%5%
        leakarea
    end
    methods
        function leakArea  = action(obj,Diameter)
            leakArea = obj.k2 * obj.k1 * pi * Diameter^2;
            obj.leakarea = leakArea;
        end
    end
end