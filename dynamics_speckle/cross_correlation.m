% 
% clear
% 
% img_name = 'E:\CUPT资料\drifting speckle录像\速度测量\速度测量2\10.MP4'; %input('Name of file? ', 's'); %include file tree and/or extension
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
%裁减范围
x=0;
y=0;
xw=N1/6;
yw=N2/6;

%%
%提取视频


%store frame rate of original image
% % frame_rate = get(img, 'FrameRate');
frame_rate = image;
    for i = 1 : frame;
%     %NEED .CDATA AND .COLORMAP BOTH WHEN CREATING VIDEOS   
%     %specify actual image being analyzed
    img_acc(i).cdata = image(:,:,i); %提取视频第i帧到图像i中（灰度）
    img_acc(i).colormap = gray;%（说明是灰度）
%     %     裁减一下...
    img_acc2(i).cdata = imcrop(img_acc(i).cdata,[x y xw yw]);
    img_acc2(i).colormap = gray;
    end
% clear img_acc
% clear img 
% clear vidFrames
% max1=max(img_acc(:,:).cdata)
% imshow(img_acc(1).cdata)%这个是调整亮度，其实并不需要。 
%%
% 对两张图片进行互相关计算
for i= 1:frame-1
cc = xcorr2( img_acc2(i).cdata, img_acc2(i+1).cdata);%第一个会糊掉，用2，3

[max_cc, imax] = max(abs(cc(:)));%不论正负都要输出
[ypeak, xpeak] = ind2sub(size(cc),imax(1));

corr_offset(i,1) =xpeak-size(img_acc2(1).cdata,2);%前一帧+corr_offset=下一帧（就是像素位移量）左上角为0 
corr_offset(i,2) =ypeak-size(img_acc2(1).cdata,1);
end

f=corr_offset;

%需要裁减一下，不然算不出来



