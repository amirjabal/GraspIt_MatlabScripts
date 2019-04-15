clear all
clc

%cd 'C:\Users\ajabalam\Documents\GitKraken Rep\manus\Results 0721'
for cc=1:33

s1 = sprintf('runData0720_%d_Gradient.jpg',cc) ;
s2 = sprintf('runData0720_%d_Marked.jpg',cc) ;
s3 = sprintf('runData0720_%d_Depth.jpg',cc) ;
s4 = sprintf('runData0720_%d_combined.jpg',cc) ;

I1 = imread(s1) ;
I2 = imread(s2) ;
I3 = imread(s3) ;

I = [I1 I2 I3] ;
imwrite(I,s4) ;

clearvars ('except','cc')

end



