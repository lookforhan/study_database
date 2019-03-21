% ����Origin��ͼ������Ϊemf��ʽ��ͼƬ
% ���� : ������
% ���� : 2016-01-27

% mdata : ��Ҫ��䵽Origin Worksheet�е�����
% template : Originģ�庯������������׺����Ҫ�����ڵ�ǰ����Ŀ¼�£���'CreatePlotInOrigin'
% fdir : ���ͼƬĿ���ļ��У���'D:\image'
% fname : ���ͼƬ�ļ�����������׺����'abc'

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