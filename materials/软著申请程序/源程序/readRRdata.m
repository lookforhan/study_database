%name:creatDamageInfo.m
classdef readRRdata < handle
    properties
        file
        FID
        RRdata
        damageInfo
    end
    methods
        function obj = readRRdata(file)
            obj.file = file;
            obj.FID = fopen(file,'r');
        end
        function readData(obj)
            obj.RRdata = readtable(obj.file);
%             obj.RRdata = textscan(obj.FID,'%s%f%f%f','delimiter','\t','headerlines',1);
        end
        function delete(obj)
            fclose(obj.FID);
        end
    end
end