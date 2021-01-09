%%
%MOTION_dynamics_speckle_simualtion
%����
%���������ǣ�һ���������������Ľṹ��Ҫ�ú÷���һ������������
%��Ȧ���۴�С������������ظ��ṹ������������������ֵġ�
%��û�п�����̩��ЧӦ��
%�ٶ�ͼ��Աȵĺ�������Ҫ��һ������������ִ����һ�������
% function y=MOTION_dynamics_speckle_simualtion()
 N = 500;%1024; % number of grid points per side
 Nbig=2048;%ʵ���Ͽ��Գ��ֵĴ���Ļ
 L = 8e-2; % total size of the grid [m]
 delta1 = L / N; % grid spacing [m]
 landa=632e-9;%����  ��
 k = 2*pi / landa; %   ��
 Dz = -69e-2; % �������� [m] 
%  Dz = -3e-3; % �������� [m]  
 v=1;%ÿ֡�������ƶ���
n=N;%��Ȧ�ο��뾶�����أ�
r=n/1;%��Ȧ�뾶�����أ�
w0=40e-6;%�����뾶  ��
w=34.7e-4;%��߰뾶  ��
% z=-69e-2;%���������  ��
z=-69e-2;%���������  ��
rou=69e-2;%��ǰ����[m]  ��
[x1 y1] = meshgrid((-N/2 : N/2-1) * delta1);
%%
%������
g=zeros(Nbig,Nbig);
g(:,:)=1;
RandomPhase= 2*pi*rand(Nbig,Nbig); 
scatterfield=g.*exp(1i*RandomPhase);%���������λ���������ɸ����������

gaosi=laser_propagation_dynamics(w0,w,landa,z,rou, delta1,N);%��˹���
%%
%��Ļ�ƶ���ÿһ֡�ƶ�1��������
scatterfield_working=zeros(N);
% ha=tight_subplot(4,8,[.01 0.0001],[.1 .01],[.01 .01])
image=zeros(N,N,3);

im=zeros(N,N,32);
for times=1:32
    k=1+times*v;
scatterfield_working=scatterfield(1:1:N,k:1:N+k-1);
out_field=gaosi.*scatterfield_working;%�������ߵ��ӳ�������
 ap =out_field;
 %%
 %��������������
 [x2 y2 Uout] = one_step_prop(ap,landa, delta1, Dz);
 %%
  %����׾�
  bandpass=zeros(N,N);
for x = 1:n;
    for y = 1:n;
       bandpass(x,y) = circle(x,y,n,r);
    end
end
Uout_1=bandpass.*fftshift(fft2(Uout));%�׾�����
%%
%��ʾ����ɢ��
imagefield=ifft2(Uout_1);
imageintensity= abs(imagefield).^2;
%figure('NumberTitle', 'off', 'Name', 'imageintensity');%��������
imageintensity=imageintensity./max(max(imageintensity(:,:)))*2;%��������Ե���ɢ��ǿ��;
image(:,:,times)=imageintensity;

% axes(ha(times))
imshow(imageintensity)
title(['Dz = ', num2str(Dz),'m'])
drawnow

end
offset=cross_correlation(image);
plot(offset(:,1),'-ko')
title(['Dz = ', num2str(Dz),'m'])
xlabel('֡���');
ylabel('ɢ�߳�����λ����');
