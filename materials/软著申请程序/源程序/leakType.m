%name: leakType
classdef leakType < handle
    enumeration
        AD ('Annular Disengagement')% Annular Disengagement
        RC ('Round Crack')% Round Crack
        LC ('Longitudinal Crack')% Longitudinal Crack
        LL ('Local Loss of Pipe Wall')% Local Loss of Pipe Wall
        LT ('Local Tear of Pipe Wall')% Local Tear of Pipe Wall
    end
    properties
        type
    end
    methods
        function obj = leakType(type)
            obj.type = type;
        end
    end
end