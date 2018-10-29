% name: PDD_Parameter.m
classdef PDD_Parameter < handle
    properties
        file
        FID
        n_argin
        Hmin
        Hdes
        doa %degree of accuracy
        circulation_num
    end
    methods
        function obj = PDD_Parameter(file)
            obj.n_argin=nargin;
            if nargin == 0
                obj.Hmin = 0;
                obj.Hdes = 10;
                obj.doa = 0.01;
                obj.circulation_num = 1000;
            else
            obj.file = file;
            obj.FID = fopen(file,'r');
            validateattributes(obj.FID,{'numeric'},{'positive'},'PDD_Parameter.m','file',1);
            PDD_data = textscan(obj.FID,'%s%f','delimiter','\t','headerlines',1);
            obj.Hmin = PDD_data{1,2}(1);
            obj.Hdes=PDD_data{1,2}(2);%
            obj.doa=PDD_data{1,2}(3);%
            obj.circulation_num=PDD_data{1,2}(4);%
            end
        end
        function delete(obj)
            if obj.n_argin == 0
            else
            fclose(obj.FID);
            end
        end
    end
end