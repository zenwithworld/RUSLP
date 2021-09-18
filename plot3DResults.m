% [x,y]=meshgrid(linspace(-3,3,31));%生成格网坐标
% z=(x-y).*exp(-(x.^2+y.^2)/2);
% subplot();
% % surf(x,y,z);%绘制曲面图
% xlabel('(a)','Fontsize',14,'Fontname','Times New Roman');
% subplot(122),surf(x,y,z,'EdgeColor','flat');
% xlabel('(b)','Fontsize',14,'Fontname','Times New Roman');

addpath('TOX_171/');

alpha = [10^-6, 10^-4,10^-2,1,10^2,10^4,10^6];
beta = [10^-6, 10^-4,10^-2,1,10^2,10^4,10^6];
results=[];
for al=alpha
    for be=beta
        result_path = strcat('al=', num2str(al),',', 'be=', num2str(be), ',', 'gam=', num2str(100), ',', 'lam=', num2str(10^-6),'_result.mat');
        load(result_path);
        results = [results,mtrResult(2,1)];
    end
    
end

results = reshape(results, 7,7);

xtick = {'10^-6', '10^-4','10^-2','1','10^2','10^4','10^6'};
ytick = {'10^-6', '10^-4','10^-2','1','10^2','10^4','10^6'};


bar3(results, 0.7)
xlabel('\lambda');ylabel('\alpha');zlabel('Normalized Mutual Information')
% title('The results of three students')

set(gca, 'xticklabel',xtick,'yticklabel',ytick);
% set(gca,'Xscale','log','Yscale','log');
% set(gca,'xticklabel',xtick);
% colormap(jet);
% colorbar;



% bar3(magic(5));
% colormap(jet);
% colorbar;

% Y = [1:1:10];
% ytick = ['1s';'2s';'3s';'4s';'5s'];
% % 绘图
% title('Detached Style')
% ax = gca;
% ax.YTick = 1:2:10;
% ax.YTickLabel = ytick;
% ax.XTick = 1:1:3;
% ax.XTickLabel = ['r';'g';'b'];
% figure()
% bar3(Y)


% x=0:0.5:4;
% y=-2:0.5:2;
% z=[zeros(1,9);
%  0,0,0,1,2,1,0,0,0;
% 0,0,0,2,5,1,1,0,0;
% 0,1,2,4,7,6,3,1,0;
% 0,1,2,5,8,6,4,1,0;
% 0,1,2,3,6,6,4,1,0;
% 0,0,0,2,4,2,1,0,0;
% 0,0,0,1,2,1,0,0,0;
% zeros(1,9);];
% bar3(z);
% set(gca,'xticklabel',ytick,'yticklabel',ytick)

