

% new kinect data

%s1 = sprintf('H:\\2016 - Research\\Collected Data\\Collected data- 0519\\data_20160519_%d',data_num);
%s1 = sprintf('H:\\2016 - Research\\Collected Data\\Collected data- 0629\\Data_20160629_%d',data_num) ;
% s1 = sprintf('H:\\2016 - Research\\Collected Data\\Collected data- 0711 Cylinder\\Data_20160711_%d',data_num) ;
% 
% load(s1)
% Id_o = double(Id_o);



% s1 = sprintf('H:\\2017 Research\\Manus Data 20171019\\data20171019_%d',imgnum) ; 
% load(s1)

%imgnum = 25; 
s1 = sprintf('H:\\2015 - Research\\OSD-dl\\OSD-0.2-depth\\disparity\\test%d.png',imgnum);
s2 = sprintf('H:\\2015 - Research\\OSD-dl\\OSD-0.2-depth\\image_color\\test%d.png',imgnum);
s3 = sprintf('H:\\2015 - Research\\OSD-dl\\OSD-0.2-depth\\annotation\\test%d.png',imgnum);

% old kinect data
fileToRead1 = s1 ;
Id_o = importdata(fileToRead1);
Id_o = double(Id_o) ; 

fileToRead2 = s2 ;
Ic = importdata(fileToRead2);

I_ref = importdata(s3);
I_ref = double(I_ref);


clear fileToRead1 fileToRead2 