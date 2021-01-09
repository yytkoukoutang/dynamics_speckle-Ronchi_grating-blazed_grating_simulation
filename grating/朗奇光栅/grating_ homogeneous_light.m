clear
%一个普通的光栅
%%
%设定参数值(单位为m)
wavelength=632.8e-9;%波长
f=1e-1;%透镜焦距
% b=0.05e-3;%缝宽
b=1e-5;%缝宽
% d=1e-4;%缝距(光栅常数）(包络线是另外的单缝衍射决定的）
d=0;
N=7 ;%缝数
angles=0;
%白光
% lamda=[660,610,570,550,460,440,410]*1e-9; %七色光的波长,单位米
% RGB=[1,0,0; 1,0.5,0; 1,1,0; 0,1,0; 0,1,1; 0,0,1; 0.67,0,1]; %七色光的RGB 值
Bright=0.5; %亮度调节系数
%%
%全部用点乘搞定了。
x=linspace(-5*pi,5*pi,4000); %%设定图像的x向范围, 并把x方向分成1001点(单位mm，后面会转换)
x=x.*10^-3;
%%对屏上x方向的全部点进行循环计算
%x是像面上的位置。
%u=(pi*b/wavelength)*(((x./sqrt(x.^2+f^2)))-sin(angles));%%入射角与衍射角位于缝法线的异侧
for k=1:8
d=d+1e-5
b=d/10
u=(pi*b/wavelength)*(((x./sqrt(x.^2+f^2)))+sin(angles));%% 入射角与衍射角位于缝法线的同侧,这是那个阿尔法

%I(j)=((sin(u)/u).^2);%% 单缝衍射光强公式

%I(j)=((sin(d*u*N/b)/sin(d*u/b)).^2);%% 多缝干涉光强公式

I=((sin(u)./u).^2).*((sin(d*u.*N/b)./sin(d*u/b)).^2); %%光栅衍射光强未修正公式



%%
hold on;
I=Bright.*I;
NCLevels=255;

Ir=NCLevels*I;

colormap(gray(NCLevels)); %%用灰度级颜色图

subplot(8,1,k),image(x,I,Ir) %%画图像
title(['d/a = ', num2str(d/b)])
t=0:0:0;
set(gca,'xtick',t);
set(gca,'ytick',t); 
set(gca,'xcolor',[1,1,1]);
set(gca,'ycolor',[1,1,1]);
end
