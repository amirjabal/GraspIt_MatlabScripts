close;clear;clc
N = 3; %   number of picture set,
M = 9; %each set has 9 pics of the same view,
dep1 = cell(M,N); % 
img = cell(1,N);
avgd = cell(1,N);
pos = [];
thlow = 30;
thhigh = 10000;
%%%  load depth and color image
for n = 1:N
    avgd{n} = zeros(480,640);
    posf = sprintf('H:\\MANUS\\test\\0619\\capture_img3\\pos%d9.txt',n);
    pos(n,:) = importdata(posf);
    for n0 = 0:M
        depp =  sprintf('H:\\MANUS\\test\\0619\\capture_img3\\depimg%d%d.png',n,n0);  % load all the depth img
        dep1{n0+1,n} = double(imread(depp));
        avgd{n} = dep1{n0+1,n}+avgd{n}; % for culculate the average depth of each depth img set.
    end
    imgg = sprintf('H:\\MANUS\\test\\0619\\capture_img3\\img%d%d.jpg',n,n0);% load color img
    img{n} = imread(imgg);
    avgd{n} = avgd{n}/M; % get the average depth of each set.
    avgd{n}(avgd{n}<thlow)= 0 ;
    avgd{n}(avgd{n}>thhigh)= 0 ;
end


%  I'v tried to take the average of each set of the depth image, the result
%  is not good, since each depth map has some uniqe hole which don't has an
%  y depth information once we add them together and take the average, this
%  process induce some noise. Then I tried the opposite way, I creat a mask
%  t3, which only takes the region in that both image has information. 


avgdepM = cell(1,N); % creat a cell for processed depth image
for j = 1:N;% for each view set

t3 = ones(480,640);
for i  = 1:M  % for each image in that set
    t1 = dep1{i,j};
    t2 = dep1{i+1,j};% load i and i+1 depth map
    
    t1(t1<thlow)= 0 ;
    t1(t1>thhigh)= 0 ;
    t2(t2<thlow)= 0 ;
    t2(t2>thhigh)= 0 ;% filter the depth info
    
    t1(t1>1) = 1;% convert the depth map to binary mask, shows the region has depth info
    t2(t2>1) = 1;
    
    t3 = t3&t1&t2;% use the and operator to get the t3 mask;
end
% avgdepM = avgdep.*t3;
figure
orgdep = dep1{2,j};
orgdep(orgdep<thlow)= 0 ;
orgdep(orgdep>thhigh)= 0 ;
imagesc(orgdep)
title('original depth map')


figure
avgdepM{j} = dep1{1,j}.*t3; % get the final depth map from first depth map.
% avgdepM{j} = avgd{j}.*t3; %   I also tried with the averaged depth map,
                            % but the result still has some noise.

imagesc(avgdepM{j})
title('and operator')
figure;
imagesc(avgd{j})
title('average')
% imagesc(medfilt2(avgd{j},[8 8]));% for the average depth map, I'v tried
                                   % to use the median filter, but result
                                   % is not good.
end

clearvars -except avgd avgdepM dep1 img pos
