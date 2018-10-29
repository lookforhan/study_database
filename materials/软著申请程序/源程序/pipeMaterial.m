% name:pipeMaterial
classdef pipeMaterial < handle
    enumeration
        CI ('Cast Iron') % Cast Iron
        DI ('Ductile Iron') % Ductile Iron
        RS ('Riveted Steel') % Riveted Steel
        STL ('Welded Steel') % Welded Steel
        CON ('Jointer Concrete') % Jointer Concrete
    end
    properties
        material
    end
    methods
        function  obj = pipeMaterial(material)
            obj.material = material;
        end
    end
    
    
end