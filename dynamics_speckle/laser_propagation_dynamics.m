function bandpass = laser_propagation_dynamics(w0,w,landa,z,rou, d1,N) 
k=2*pi/landa;
 [x y] = meshgrid((-N/2 : 1 : N/2 - 1) * d1);
       bandpass = w0*(exp(-(x.^2+y.^2)/w^2+i*(k*z+pi*(x.^2+y.^2)/(landa*rou))))/w;
       %�õ��Ǹ�˹�����������Ǹ���λ��ɢ�������Ƿ��������䡣
end