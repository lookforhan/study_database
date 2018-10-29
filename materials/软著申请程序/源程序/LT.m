% LT % Local Tear of Pipe Wall
classdef LT < creatLeakBase
    properties
        k = 30;% 30%
        W = 12;%mm
        leakarea
    end
    methods
        function leakArea  = action(obj,Diameter)
            leakArea = obj.k * obj.W * pi * Diameter;
            obj.leakarea = leakArea;
        end
    end
end