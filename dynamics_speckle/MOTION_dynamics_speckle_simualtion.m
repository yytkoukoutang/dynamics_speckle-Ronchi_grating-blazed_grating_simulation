%%
%MOTION_dynamics_speckle_simualtion
%参数
%现在问题是，一定会出现那种网格的结构，要好好分析一下问题出在哪里。
%光圈无论大小都会出现这种重复结构。考虑是衍射问题出现的。
%有没有可能是泰伯效应？
%①多图像对比的函数。我要用一个函数来决定执行哪一种情况。
% function y=MOTION_dynamics_speckle_simualtion()
 N = 500;%1024; % number of grid points per side
 Nbig=2048;%实际上可以出现的大屏幕
 L = 8e-2; % total size of the grid [m]
 delta1 = L / N; % grid spacing [m]
 landa=632e-9;%波长  √
 k = 2*pi / landa; %   √
 Dz = -69e-2; % 传播距离 [m] 
%  Dz = -3e-3; % 传播距离 [m]  
 v=1;%每帧的像素移动量
n=N;%光圈参考半径（像素）
r=n/1;%光圈半径（像素）
w0=40e-6;%束腰半径  √
w=34.7e-4;%光斑半径  √
% z=-69e-2;%束腰到光斑  √
z=-69e-2;%束腰到光斑  √
rou=69e-2;%波前曲率[m]  √
[x1 y1] = meshgrid((-N/2 : N/2-1) * delta1);
%%
%出射面
g=zeros(Nbig,Nbig);
g(:,:)=1;
RandomPhase= 2*pi*rand(Nbig,Nbig); 
scatterfield=g.*exp(1i*RandomPhase);%随机出射相位（把振幅变成复振幅这样）

gaosi=laser_propagation_dynamics(w0,w,landa,z,rou, delta1,N);%高斯光斑
%%
%屏幕移动，每一帧移动1像素试试
scatterfield_working=zeros(N);
% ha=tight_subplot(4,8,[.01 0.0001],[.1 .01],[.01 .01])
image=zeros(N,N,3);

im=zeros(N,N,32);
for times=1:32
    k=1+times*v;
scatterfield_working=scatterfield(1:1:N,k:1:N+k-1);
out_field=gaosi.*scatterfield_working;%给激光光斑叠加出射的情况
 ap =out_field;
 %%
 %菲涅尔单次衍射
 [x2 y2 Uout] = one_step_prop(ap,landa, delta1, Dz);
 %%
  %创造孔径
  bandpass=zeros(N,N);
for x = 1:n;
    for y = 1:n;
       bandpass(x,y) = circle(x,y,n,r);
    end
end
Uout_1=bandpass.*fftshift(fft2(Uout));%孔径作用
%%
%显示像面散斑
imagefield=ifft2(Uout_1);
imageintensity= abs(imagefield).^2;
%figure('NumberTitle', 'off', 'Name', 'imageintensity');%设置名字
imageintensity=imageintensity./max(max(imageintensity(:,:)))*2;%在这里可以调节散斑强度;
image(:,:,times)=imageintensity;

% axes(ha(times))
imshow(imageintensity)
title(['Dz = ', num2str(Dz),'m'])
drawnow

end
offset=cross_correlation(image);
plot(offset(:,1),'-ko')
title(['Dz = ', num2str(Dz),'m'])
xlabel('帧序号');
ylabel('散斑场横向位移量');
