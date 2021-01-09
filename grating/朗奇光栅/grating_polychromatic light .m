clear
%%
%设定参数值(单位为m)
f=1e-1;%透镜焦距
b=10e-5;%缝宽
d=90e-5;%缝距(光栅常数）(包络线是另外的单缝衍射决定的）
N=10 ;%缝数
angles=0;%入射角
%像面范围
length=2000;%这个是矩阵分割份数)
high=100;%就是看着舒服，高度份数
%白光设置
lamda=[660,610,570,550,460,440,410]*1e-9; %七色光的波长,单位米
RGB=[1,0,0; 1,0.5,0; 1,1,0; 0,1,0; 0,1,1; 0,0,1; 0.67,0,1]; %七色光的RGB 值
Bright=1; %亮度调节系数，影响最后成像面的亮度
%空矩阵预置
Irgb=zeros(high,length,3); %各波长衍射结果叠加矩阵
Iw=zeros(high,length,3); %单波长衍射结果记录矩阵

%%
%上色
for k=1:7
    
x=linspace(-0.1*pi,0.1*pi,length); %%设定像面范围,x是像面上的位置。，分割成1000个计算单元，单位（mm)，前两个数才是范围。（一看就是改的别人的代码，怎么还有pi在这)
x=x.*10^-3;%转化单位为m

%衍射因子计算振幅，根据不同情况选用不同公式。
%入射角与衍射角位于缝法线的异侧
%u=(pi*b/lamda(k))*(((x./sqrt(x.^2+f^2)))-sin(angles));
% 入射角与衍射角位于缝法线的同侧
u=(pi*b/lamda(k))*(((x./sqrt(x.^2+f^2)))+sin(angles));

%光强计算
%I(j)=((sin(u)/u).^2);%% 单缝衍射光强公式
%I(j)=((sin(d*u*N/b)/sin(d*u/b)).^2);%% 多缝干涉光强公式
I=((sin(u)./u).^2).*((sin(d*u.*N/b)./sin(d*u/b)).^2); %%光栅方程光强未修正公式

%相对光强叠加对应的rgb值，得到对应波长的颜色矩阵
for i=1:high
Iw(i,:,1)=I*RGB(k,1); %把红基色代码计入Iw 矩阵红维度
Iw(i,:,2)=I*RGB(k,2); %把绿基色代码计入Iw 矩阵绿维度
Iw(i,:,3)=I*RGB(k,3); %把蓝基色代码计入Iw 矩阵蓝维度
end
%单波长颜色矩阵叠加进入白光衍射矩阵
Irgb=Irgb+Iw; %把各色光衍射的RGB 值矩阵计入仿真结果RGB 值图像矩阵中
Br=1/max(max(max(Iw))); %归一化系数计算
II=Iw*Br*Bright; 
subplot(8,1,k),imshow(II); 
Iw=[];
end
%%
%画图
%显示白光光栅衍射实验仿真结果
Br=1/max(max(max(Irgb))); %归一化系数计算
II=Irgb*Br*2; %归一化后倍增亮度

% subplot(4,1,1),plot(x,II(:,:,1));%%屏幕上光强与位置的关系曲线
% title('红','FontWeight','bold','FontSize', 16)
% xlabel('偏移位置（m）')
% subplot(4,1,2),plot(x,II(:,:,2));
% title('绿','FontWeight','bold','FontSize', 16)
% xlabel('偏移位置（m）')
% subplot(4,1,3),plot(x,II(:,:,3))
% title('蓝','FontWeight','bold','FontSize', 16)
% xlabel('偏移位置（m）')
subplot(8,1,8),imshow(II); %显示结果,像素一一对应，标准大小


%保存结果
filename = 'testAnimated.gif';
fig=figure(1)
frame = getframe(fig);
    im = frame2im(frame);
[A,map] = rgb2ind(im,256);
imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.02);

%%
%旧的画图
% hold on;
% 
% NCLevels=255; 
% 
% Ir=NCLevels*I;
% 
% colormap(gray(NCLevels)); %%用灰度级颜色图
% 
% subplot(2,1,2),image(x,I,Ir) %%画图像
% 
% subplot(2,1,1),plot(x,I(:)/max(I));%%屏幕上光强与位置的关系曲线、
% 
% 
% %这个是简化之后的