clc,clear,close all
x = [50,100,200,500,1000,2000,5000,10000,20000]
y = [2.64,2.21,1.38,0.564,0.263,0.396,1.07,1.98,3.14]
xx = 50:0.01:20000; % ��ֵ
yy = interp1(x,y,xx,'cubic');
plot(x,y,'o',xx,yy,'linewidth',1)
xlabel('Ƶ��/Hz','fontsize',15)
ylabel('��ѹ/mv','fontsize',15)
title('��Ƶ��������','fontsize',15)
