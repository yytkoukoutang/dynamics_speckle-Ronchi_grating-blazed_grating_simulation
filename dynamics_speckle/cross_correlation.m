% 
% clear
% 
% img_name = 'E:\CUPT����\drifting speckle¼��\�ٶȲ���\�ٶȲ���2\10.MP4'; %input('Name of file? ', 's'); %include file tree and/or extension
% 
% %store image
% img = VideoReader(img_name);
% 
% %specify total number of frames in video
% a = get(img, 'NumberOfFrames');
% %range of frames to be played
% A = [1 a];
% vidFrames = read(img, A);
%%
function f=cross_correlation(image);
[N1,N2,frame]=size(image);
%�ü���Χ
x=0;
y=0;
xw=N1/6;
yw=N2/6;

%%
%��ȡ��Ƶ


%store frame rate of original image
% % frame_rate = get(img, 'FrameRate');
frame_rate = image;
    for i = 1 : frame;
%     %NEED .CDATA AND .COLORMAP BOTH WHEN CREATING VIDEOS   
%     %specify actual image being analyzed
    img_acc(i).cdata = image(:,:,i); %��ȡ��Ƶ��i֡��ͼ��i�У��Ҷȣ�
    img_acc(i).colormap = gray;%��˵���ǻҶȣ�
%     %     �ü�һ��...
    img_acc2(i).cdata = imcrop(img_acc(i).cdata,[x y xw yw]);
    img_acc2(i).colormap = gray;
    end
% clear img_acc
% clear img 
% clear vidFrames
% max1=max(img_acc(:,:).cdata)
% imshow(img_acc(1).cdata)%����ǵ������ȣ���ʵ������Ҫ�� 
%%
% ������ͼƬ���л���ؼ���
for i= 1:frame-1
cc = xcorr2( img_acc2(i).cdata, img_acc2(i+1).cdata);%��һ�����������2��3

[max_cc, imax] = max(abs(cc(:)));%����������Ҫ���
[ypeak, xpeak] = ind2sub(size(cc),imax(1));

corr_offset(i,1) =xpeak-size(img_acc2(1).cdata,2);%ǰһ֡+corr_offset=��һ֡����������λ���������Ͻ�Ϊ0 
corr_offset(i,2) =ypeak-size(img_acc2(1).cdata,1);
end

f=corr_offset;

%��Ҫ�ü�һ�£���Ȼ�㲻����



