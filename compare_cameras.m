clc
% clear all
% load('datasets/primesenseview_all.mat')
% load('datasets/kinectMultiViews.mat')



cc=1 ;

kn = 22;
pn = 12; 


Ick = K2_view2{kn};
Ick = fliplr(Ick);
Idk = K2D_view2{kn};
Idk = fliplr(Idk) ; 

Icp = img{pn} ;
Idp = dep1{pn,1}; 


figure(1);imshow(Ick) ; title('kinect') ;
figure(11);imshow(Icp) ; title('primesense');

device_data= 'kinect' ;
manus_initial_parameters ; 

Id_o = Idk; 
part1_test
figure(2);imshow(L22);hold on ;title('kinect'); hold off
draw_2LogicalOnImage(BW20,BW30,L11,'kinect.',3)


device_data= 'prime' ;
manus_initial_parameters ; 

Id_o= Idp ; 
part1_test
figure(12);imshow(L22);hold on;title('prime');hold off ;
draw_2LogicalOnImage(BW20,BW30,L11,'prime',13)