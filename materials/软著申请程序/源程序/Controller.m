classdef Controller < handle
    properties
        viewObj;
        modelObj;
    end
    methods
        function obj = Controller(viewObj,modelObj)
            obj.viewObj = viewObj;
            obj.modelObj = modelObj;
        end
        function callback_ButtonRun(obj,src,event)
            obj.modelObj.run(obj.viewObj.input);
        end
    end
end