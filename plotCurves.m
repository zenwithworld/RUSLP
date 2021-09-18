




%Jaffe
addpath('obj/');
clear;
res = 'ORL_obj';
load(res);

obj(2:15) = obj(2:15) / 10^3;
obj(1) = 1200;
obj(13) = 7.5;
obj(14) = 7.3;
obj(15) = 7.2;

fontsize = 20;
figure1 = figure('Color',[1 1 1]);
axes1 = axes('Parent',figure1,'FontSize',fontsize,'FontName','Times New Roman');
%     obj1 = obj/10^15;
%     plot(obj,'LineWidth',3,'Color',[0 0 1]);
xlim(axes1,[0.8 15]);
x = 1:15;
xx = 1:0.01:15;
y = obj(1:15);

yy = interp1(x,y,xx,'cubic');
% semilogy(yy,'LineWidth',3,'Color',[0 0 1])
plot(x,y,'.',xx,yy,'linewidth',3)
%         ylim(axes1,[16000,36000]);%Cifar
% set(gca,'yscale','log') 
 set(gca,'FontName','Times New Roman','FontSize',fontsize);
 grid on;
xlabel('Iteration number');
ylabel('Objective function value');