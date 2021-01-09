clear
Max=6
for times= 1:Max
%缺陷是没有考虑倾斜因子
%默认是满足了傍轴近似，透镜足够大，放得足够远，各出射光都是平行的，入射光也足够远，光栅也足够小。
%定义参量，单位（°）
angleMatri=[0,1,2,3,4,5];
angle=angleMatri(times);%    工作角度
ag_i=(angle)/180*pi;   %入射光宇光栅表面夹角。
ag_b=(angle)/180*pi;   %光栅斜面与光栅表面的夹角。
%现在是给定入射角和斜面角，改变k，然后到不同像面观察我们的衍射图案
%单位(m)
lamda=[660,610,570,550,460,440,410]*1e-9; %七色光的波长,单位米
RGB=[1,0,0; 1,0.5,0; 1,1,0; 0,1,0; 0,1,1; 0,0,1; 0.67,0,1]; %七色光的RGB 值

% Ntimes=[1,5,100];
% N=Ntimes(times);
N=100;
d=1e-5;%每毫米刻痕有1000到100条，——光栅槽距——········d决定了光栅方程，槽形如何不影响······只要入射角相同，就完全一样
% L=1e-2;%光栅宽度数厘米
% N=L/d;%刻痕量

a=0.9*d;%衍射长度,在这种闪耀光栅里是差不多的，反射光栅

f=0.2;%透镜焦距（或者是传播距离，无所谓）在这个数量级的光栅常数下，20cm已经可以满足夫琅禾费条件。

I_0=1;%归一化，这个是零级的强度，其实类似一个透射率或者反射率的事情，归一化就好 
I_0f=1;%归一化，这个是零级的强度，其实类似一个透射率或者反射率的事情，归一化就好 

length=10000;%分划精度
high=1000;%复制上去的显示精度
l_screen=2e-2;%屏幕大小

% syms ag_i ag_k ag_b I_0 lad a N d  I_0f
%矩阵预置
%像面坐标设定
    %矩阵有： x ag_k u v
    x=linspace(-l_screen,l_screen,length); %%设定像屏的角范围(m)
    ag_k=atan(x./f);
%颜色矩阵，先做单行的，最后再复制一下提高观赏性。
    Irgb=zeros(1,length,3); %各波长衍射结果叠加矩阵
    Iw=zeros(1,length,3); %单波长衍射结果记录矩阵

%计算像面光强
%这里是直接把对应角度的叠加起来了，也就是无形之中引入了透镜了。%前面的sin值直接用坐标代替了。
for k=1:7
% %透射闪耀光栅
%     u=pi*a/lamda(k)*(sin(ag_i-ag_b)-sin(ag_k-ag_b));
%     v=pi*d/lamda(k)*(sin(ag_i)-sin(ag_k));
%     I=I_0*(sin(u).^2./u.^2).*(sin(N*v).^2./sin(v).^2);
%反射闪耀光栅
    u_f=pi*a/lamda(k)*(sin(ag_i-ag_b)+sin(ag_k-ag_b));
    v_f=pi*d/lamda(k)*(sin(ag_i)+sin(ag_k));
    I=I_0f*(sin(u_f).^2./u_f.^2).*(sin(N*v_f).^2./sin(v_f).^2);
%光强叠加颜色后写入颜色矩阵
    Iw(1,:,1)=I*RGB(k,1); %把红基色代码计入Iw 矩阵红维度
    Iw(1,:,2)=I*RGB(k,2); %把绿基色代码计入Iw 矩阵绿维度
    Iw(1,:,3)=I*RGB(k,3); %把蓝基色代码计入Iw 矩阵蓝维度
    %单波长颜色矩阵叠加进入白光衍射矩阵
    Irgb=Irgb+Iw; %把各色光衍射的RGB 值矩阵计入仿真结果RGB 值图像矩阵中
    Iw=[];
end


%画出像面光强
Bright=1;%强化
Br=1/max(max(max(Irgb)));%归一化
II1=Irgb*Br*Bright;
%扩展矩阵
    II2=zeros(high,length,3);
    for i=1:high
        II2(i,:,:)=II1(1,:,:);
    end
%画图像
% subplot(4,1,1),plot(x,II2(:,:,1));%%屏幕上光强与位置的关系曲线
% title('红','FontWeight','bold','FontSize', 16)
% xlabel('偏移位置（m）')
% subplot(4,1,2),plot(x,II2(:,:,2));
% title('绿','FontWeight','bold','FontSize', 16)
% xlabel('偏移位置（m）')
% subplot(4,1,3),plot(x,II2(:,:,3))
% title('蓝','FontWeight','bold','FontSize', 16)
% xlabel('偏移位置（m）')
subplot(Max,1,times)
imshow(II2);
title(['angle = ', num2str(angle)])

end


