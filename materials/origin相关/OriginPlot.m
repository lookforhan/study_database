% 调用Origin作图并保存为emf格式的图片
% 作者 : 高明飞
% 日期 : 2016-01-27

% mdata : 需要填充到Origin Worksheet中的数据
% template : Origin模板函数名，不含后缀，需要保存在当前工作目录下，如'CreatePlotInOrigin'
% fdir : 输出图片目标文件夹，如'D:\image'
% fname : 输出图片文件名，不含后缀，如'abc'

function OriginPlot(mdata, template, fdir, fname)
% Obtain Origin COM Server object
% This will connect to an existing instance of Origin, or create a new one if none exist
originObj=actxserver('Origin.ApplicationSI');

% Clear "dirty" flag in Origin to suppress prompt for saving current project
invoke(originObj, 'IsModified', 'false');

% Load the custom template project
dir = pwd;
dir = strcat(dir, '\', template, '.opj');
invoke(originObj, 'Load', dir);

% Send this data over to the Data1 worksheet
invoke(originObj, 'PutWorksheet', 'Data1', mdata);

% Save graph
cmd = 'expGraph type:=emf overwrite := rename tr1.unit := 2 tr1.width := 10000 path:= "';
cmd = strcat(cmd, fdir, '" filename:= "', fname, '.emf";');
invoke(originObj, 'Execute', cmd);

% Release
release(originObj);
end