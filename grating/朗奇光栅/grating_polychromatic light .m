clear
%%
%�趨����ֵ(��λΪm)
f=1e-1;%͸������
b=10e-5;%���
d=90e-5;%���(��դ������(������������ĵ�����������ģ�
N=10 ;%����
angles=0;%�����
%���淶Χ
length=2000;%����Ǿ���ָ����)
high=100;%���ǿ���������߶ȷ���
%�׹�����
lamda=[660,610,570,550,460,440,410]*1e-9; %��ɫ��Ĳ���,��λ��
RGB=[1,0,0; 1,0.5,0; 1,1,0; 0,1,0; 0,1,1; 0,0,1; 0.67,0,1]; %��ɫ���RGB ֵ
Bright=1; %���ȵ���ϵ����Ӱ���������������
%�վ���Ԥ��
Irgb=zeros(high,length,3); %���������������Ӿ���
Iw=zeros(high,length,3); %��������������¼����

%%
%��ɫ
for k=1:7
    
x=linspace(-0.1*pi,0.1*pi,length); %%�趨���淶Χ,x�������ϵ�λ�á����ָ��1000�����㵥Ԫ����λ��mm)��ǰ���������Ƿ�Χ����һ�����Ǹĵı��˵Ĵ��룬��ô����pi����)
x=x.*10^-3;%ת����λΪm

%�������Ӽ�����������ݲ�ͬ���ѡ�ò�ͬ��ʽ��
%������������λ�ڷ취�ߵ����
%u=(pi*b/lamda(k))*(((x./sqrt(x.^2+f^2)))-sin(angles));
% ������������λ�ڷ취�ߵ�ͬ��
u=(pi*b/lamda(k))*(((x./sqrt(x.^2+f^2)))+sin(angles));

%��ǿ����
%I(j)=((sin(u)/u).^2);%% ���������ǿ��ʽ
%I(j)=((sin(d*u*N/b)/sin(d*u/b)).^2);%% �������ǿ��ʽ
I=((sin(u)./u).^2).*((sin(d*u.*N/b)./sin(d*u/b)).^2); %%��դ���̹�ǿδ������ʽ

%��Թ�ǿ���Ӷ�Ӧ��rgbֵ���õ���Ӧ��������ɫ����
for i=1:high
Iw(i,:,1)=I*RGB(k,1); %�Ѻ��ɫ�������Iw �����ά��
Iw(i,:,2)=I*RGB(k,2); %���̻�ɫ�������Iw ������ά��
Iw(i,:,3)=I*RGB(k,3); %������ɫ�������Iw ������ά��
end
%��������ɫ������ӽ���׹��������
Irgb=Irgb+Iw; %�Ѹ�ɫ�������RGB ֵ������������RGB ֵͼ�������
Br=1/max(max(max(Iw))); %��һ��ϵ������
II=Iw*Br*Bright; 
subplot(8,1,k),imshow(II); 
Iw=[];
end
%%
%��ͼ
%��ʾ�׹��դ����ʵ�������
Br=1/max(max(max(Irgb))); %��һ��ϵ������
II=Irgb*Br*2; %��һ����������

% subplot(4,1,1),plot(x,II(:,:,1));%%��Ļ�Ϲ�ǿ��λ�õĹ�ϵ����
% title('��','FontWeight','bold','FontSize', 16)
% xlabel('ƫ��λ�ã�m��')
% subplot(4,1,2),plot(x,II(:,:,2));
% title('��','FontWeight','bold','FontSize', 16)
% xlabel('ƫ��λ�ã�m��')
% subplot(4,1,3),plot(x,II(:,:,3))
% title('��','FontWeight','bold','FontSize', 16)
% xlabel('ƫ��λ�ã�m��')
subplot(8,1,8),imshow(II); %��ʾ���,����һһ��Ӧ����׼��С


%������
filename = 'testAnimated.gif';
fig=figure(1)
frame = getframe(fig);
    im = frame2im(frame);
[A,map] = rgb2ind(im,256);
imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',0.02);

%%
%�ɵĻ�ͼ
% hold on;
% 
% NCLevels=255; 
% 
% Ir=NCLevels*I;
% 
% colormap(gray(NCLevels)); %%�ûҶȼ���ɫͼ
% 
% subplot(2,1,2),image(x,I,Ir) %%��ͼ��
% 
% subplot(2,1,1),plot(x,I(:)/max(I));%%��Ļ�Ϲ�ǿ��λ�õĹ�ϵ���ߡ�
% 
% 
% %����Ǽ�֮���