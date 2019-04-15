% close all;clear;clc
% N = 1; %   number of picture set,
M = 20; %each set has 9 pics of the same view,
dep1 = cell(N,M); % 
img = cell(1,N);
avgd = cell(1,N);
pos = [];
thlow = 300;
thhigh = 10000;
%%%  load depth and color image
for i = 1:N
avgd{i} = zeros(480,640);
end
iter = 1;

for n = 1:N*M
%     depp =  sprintf('C:\\MANUS\\test\\capture_img10\\depimg%d.png',n);  % load all the depth img
    depp =  sprintf('C:\\MANUS\\CommonSpace\\capture_img\\depimg%d.png',n);  % load all the depth img  new_vision\\
    dep1{iter,n-(iter-1)*M} = double(imread(depp));
    avgd{iter} = dep1{iter,n-(iter-1)*M}+avgd{iter}; % for culculate the average depth of each depth img set.
    %    n
    if n == iter*M
%         imgg = sprintf('C:\\MANUS\\test\\capture_img10\\img%d.jpg',n);% load color img
        imgg = sprintf('C:\\MANUS\\CommonSpace\\capture_img\\img%d.jpg',n);% load color img
        img{iter} = imread(imgg);
%         posf = sprintf('C:\\MANUS\\test\\capture_img10\\pos%d.txt',n);
        posf = sprintf('C:\\MANUS\\CommonSpace\\capture_img\\pos%d.txt',n);
        pos(iter,:) = importdata(posf);
        avgd{iter} = avgd{iter}/M; % get the average depth of each set.
        avgd{iter}(avgd{iter}<thlow)= 0 ;
        avgd{iter}(avgd{iter}>thhigh)= 0 ;
        iter = iter+1;
    end

end
% 
%  t0 = avgd{1}/20;
%  imagesc(t0);

%  I'v tried to take the average of each set of the depth image, the result
%  is not good, since each depth map has some uniqe hole which don't has an
%  y depth information once we add them together and take the average, this
%  process induce some noise. Then I tried the opposite way, I creat a mask
%  t3, which only takes the region in that both image has information. 


avgdepM = cell(N); % creat a cell for processed depth image
% iter = 1;
for iter = 1:N;
for j = 2:M;% for each view set

    t3 = ones(480,640);


    t1 = dep1{iter,j-1};
    t2 = dep1{iter,j};% load i and i+1 depth map
    
    t1(t1<thlow)= 0 ;
    t1(t1>thhigh)= 0 ;
    t2(t2<thlow)= 0 ;
    t2(t2>thhigh)= 0 ;% filter the depth info
    
    t1(t1>1) = 1;% convert the depth map to binary mask, shows the region has depth info
    t2(t2>1) = 1;
    
    t3 = t3&t1&t2;% use the and operator to get the t3 mask;
%     if j == iter*M
% 
%         
% %         iter= iter+1;
%     end
    
    
    
    
end
%         figure
        orgdep = dep1{iter,j};
        orgdep(orgdep<thlow)= 0 ;
        orgdep(orgdep>thhigh)= 0 ;
%         imagesc(orgdep)
%         title('original depth map')


%         figure
        avgdepM{iter} = dep1{iter,j}.*t3; % get the final depth map from first depth map.
        % avgdepM{j} = avgd{j}.*t3; %   I also tried with the averaged depth map,
%                                     % but the result still has some noise.
% % 
%         imagesc(avgdepM{iter})
%         title('and operator')
%         figure;
%         imagesc(avgd{iter})
%         title('average')
end
% avgdepM = avgdep.*t3;

% imagesc(medfilt2(avgd{j},[8 8]));% for the average depth map, I'v tried
                                   % to use the median filter, but result
                                   % is not good.
% end

clearvars -except avgd avgdepM dep1 img pos
save('C:\\Users\\zding\\Documents\\GitHub\\Edge-Grasping-Manus\\datasets\\07191.mat')
