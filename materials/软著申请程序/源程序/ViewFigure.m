classdef ViewFigure < handle
    properties
        modelObj
        controlObj
        viewSize    ;% 用于控制试图大小的数组
        hfig        ;% 视图类对象拥有figure的handle
        ButtonRun
        text_outputFolder
        text_Inpfile
        text_RRfile
        text_MCnum 
    end
    properties(Dependent)
        input
    end
    methods
        function obj = ViewFigure(modelObj)
            obj.modelObj = modelObj;
            obj.viewSize = [500,500,450,200];
            obj.modelObj.addlistener('runOver',@obj.over);
            obj.buildUI();
            obj.controlObj = obj.makController();
            obj.attachToController(obj.controlObj)
        end
        function input = get.input(obj)
            outputFolder = get(obj.text_outputFolder,'string');
            Inpfile = get(obj.text_Inpfile,'string');
            RRfile = get(obj.text_RRfile,'string');
            MCnum  = get(obj.text_MCnum,'string');
            input.outputFolder = outputFolder;
            input.Inpfile = Inpfile;
            input.RRfile = RRfile;
            input.MCnum = str2double(MCnum);
        end
        function buildUI(obj)
            obj.hfig = figure('pos',obj.viewSize,'menubar','none','toolbar','none','name','供水管网震后水力分析软件V2.0','numbertitle','off');
            mainLayout =  uix.VBox('parent',obj.hfig,'Padding',5,'spacing',10);
            upperLayout = uix.VBox('pare',mainLayout,'Spacing',5);
            lowerLayout = uix.HBox('pare',mainLayout,'Spacing',5);
            obj.text_outputFolder = uicontrol('pare',upperLayout,'style','edit','string','输出文件位置');
            obj.text_Inpfile = uicontrol('pare',upperLayout,'style','edit','string','管网文件');
            obj.text_RRfile = uicontrol('pare',upperLayout,'style','edit','string','RR文件');
            obj.text_MCnum = uicontrol('pare',lowerLayout,'style','edit','string','MC 次数');
            obj.ButtonRun = uicontrol('pare',lowerLayout,'style','pushbutton','string','Run');
        end
        function over(obj,scr,data)
            f = figure('pos',[500,500,50,50],'menubar','none','toolbar','none','numbertitle','off');
            m = uicontrol('pare',f,'style','text','string','OVER!!!');
            unloadlibrary epanet2
        end
        function controlObj = makController(obj)
            controlObj = Controller(obj,obj.modelObj);
        end
        function attachToController(obj,controller)
            funcH1 = @controller.callback_ButtonRun;
            set(obj.ButtonRun,'callback',funcH1);
        end
    end
    
end