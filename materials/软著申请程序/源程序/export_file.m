function export_file(node_coodinate,node_serviceability,node_id,pipe_line,MC_num,summary_picturename,summary_filename,original_junction_num,each_pre,each_dem,...
    system_serviceability_giraffe,system_serviceability_mean_giraffe,system_serviceability_mean_difference,system_serviceability_cov_giraffe...
    ,system_serviceability_cov_difference)
%% 输出结果到图片
figure
plot_contour(node_coodinate,node_serviceability,node_id)%等值线图
hold on
plot_network(node_coodinate,pipe_line)%管网模型
axis off%取消坐标轴
caxis([0,1])%
axis equal
colorbar%图例
% set(gcf,'PaperPositionMode','auto');
set(gcf,'color','white','paperpositionmode','auto');
% set(gcf,'color','none'); %图形背景设为无色
% set(gca,'color','none'); %坐标轴背景设为无色
% saveas(gcf,'exprimentLightBundles.eps','psc2');
% set(gcf,'alpha',0);
saveas(gcf,[summary_picturename,'1'],'meta');
saveas(gcf,[summary_picturename,'1','.fig'],'fig');
hold off
figure
plot(abs(system_serviceability_cov_difference(1:MC_num)))
hold on
plot([0,MC_num],[0.02,0.02])
% plot([0,MC_num],[-0.02,-0.02])
saveas(gcf,[summary_picturename,'cov'],'meta');
saveas(gcf,[summary_picturename,'cov','.fig'],'fig');
figure
hold off
plot(abs(system_serviceability_mean_difference(1:MC_num)))
hold on
plot([0,MC_num],[0.02,0.02])
% plot([0,MC_num],[-0.02,-0.02])
saveas(gcf,[summary_picturename,'mean'],'meta');
saveas(gcf,[summary_picturename,'mean','.fig'],'fig');
%% 输出结果到文件
fid=fopen(summary_filename,'w');
fprintf(fid,'each_pre:\n\r');
for mid_n=1:original_junction_num
fprintf(fid,'%5.3f \t',each_pre(mid_n,1:MC_num+1));
fprintf(fid,'\n');
end
fprintf(fid,'each_dem:\n\r');
for mid_n=1:original_junction_num
fprintf(fid,'%5.3f\t',each_dem(mid_n,1:MC_num+1));
SI_mean(mid_n)=sum(each_dem(mid_n,2:MC_num+1)/(MC_num*each_dem(mid_n,1)));
fprintf(fid,'%5.3f',SI_mean(mid_n));
fprintf(fid,'\n');
end
fprintf(fid,'system_serviceability_giraffe:\n\r');
fprintf(fid,'%5.3f \t',0);
fprintf(fid,'%5.3f \t',system_serviceability_giraffe(1:MC_num));
fprintf(fid,'\r\n');
fprintf(fid,'system_serviceability_mean_giraffe:\n\r');
fprintf(fid,'%5.3f \t',0);
fprintf(fid,'%5.3f \t',system_serviceability_mean_giraffe(1:MC_num));
fprintf(fid,'\r\n');
fprintf(fid,'system_serviceability_mean_difference:\n\r');
fprintf(fid,'%5.3f \t',0);
fprintf(fid,'%5.3f \t',system_serviceability_mean_difference(1:MC_num));
fprintf(fid,'\r\n');
fprintf(fid,'system_serviceability_cov_giraffe:\n\r');
fprintf(fid,'%5.3f \t',0);
fprintf(fid,'%5.3f \t',system_serviceability_cov_giraffe(1:MC_num));
fprintf(fid,'\r\n');
fprintf(fid,'system_serviceability_cov_difference:\n\r');
fprintf(fid,'%5.3f \t',0);
fprintf(fid,'%5.3f \t',system_serviceability_cov_difference(1:MC_num));
fprintf(fid,'\r\n');
fclose(fid);
end