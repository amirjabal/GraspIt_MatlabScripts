%
clc ;clear 
% load('datasets/Primesense_0713_10pics.mat')

%N = 33;
% prepare_data2;


%load('datasets/07183.mat') % collected from MANUS in realtime
%load('H:/2017 Research/Manus Datasets codes/datasets/07191.mat')
%load('H:/2017 Research/Manus Datasets codes/datasets/0726_combined.mat')
imgnum = 15 ; 
device_data= 'kinect' ;
%load('datasets/kinectMultiViews.mat')
%cc =1;
%load('dep07072.mat')
%device_data= 'prime' ;
manus_initial_parameters
P.mode = 'manual' ;

%%  Run algorithm

algorithm_part1
% draw_2LogicalOnImage(BW20,BW30,Ic,'depth/curve disc.',13)
% Ig =rgb2gray(L00) ;
% draw_LogicalOnImage(DE3,Ig,'DE3 cc8 new',19)
% draw_disc_curv(Line_new,Ig,'Labeled line',33)


manus_pcl_process
if strcmp(P.mode,'manual')
    draw_pairs_v2(ListPair,Line_new,Ic,1) % paired lines
    pair_no  = user_selection(ListPair,Line_new,ListPoint_new, Id,P) ;
    algorithm_part2
    algorithm_part3h1
    if f_success
        algorithm_part3h2
        % Drawing the point clouds
        if P.fig_pcl
            DrawSelectedPoints(TargetPoints, TargetPoints_noshift,10,Ic,'Selected Points')
            drawPclMarkedPts(Cloud_B2, set_points, original_points, 20, 'PCL - Before and After Shifting',P)
            draw_pcl_Xaxis(Cloud_B2, LL1, LL2, 21, 'Fit Lines') % draw fit lines on the PCL
            draw_pcl(Cloud_B2, P_centerRAN, p_best, n_best, ro_best, Dir_vecRAN, 22, 'RANSAC-Point Cloud',P)
        end
    end
    clean_vars
elseif strcmp(P.mode,'auto')
    for x0=1:size(ListPair,1)
        try
            pair_no = x0 ;
            algorithm_part2
            algorithm_part3h1
            if f_success
                algorithm_part3h2
            end
        catch
            display(sprintf ('There was an error in computations of pair %d',pair_no))
            feat_vec(x0,:) = [100 1 1 1 1 1 1 1 1] ; 
            feat_vecN(x0,:)= [100 1 1 1 1 1 1 1 1] ;
        end
        clean_vars
    end
    auto_pair_selection
    draw_pairs_v2(ListPair,Line_new,Ic,1)
    draw_pairs_v2(ListPair(sorted_pairs(1),:),Line_new,Ic,41) % filtered paired lines
end





% s1 = sprintf('runData0720_%d_Gradient.jpg',cc) ;
% s2 = sprintf('runData0720_%d_Marked.jpg',cc) ;
% s3 = sprintf('runData0720_%d_Depth.jpg',cc) ;
% cc
% figure(1) ; imshow(L22)
% saveas(gcf,s1)
% saveas(gcf,s2)
% figure(3) ; imshow(L00);
% saveas(gcf,s3)
% pause(0.5)
% close all
% clearvars('-except','cc','img','avgdepM','pos')


%%


%s1 = sprintf('img%d-1.jpg',cc) ;
%s2 = sprintf('img%d-2.jpg',cc) ;
%s3 = sprintf('img%d-3.jpg',cc) ;


% figure;imshow(Ic)
%saveas(gcf,s1)
%figure;imshow(L22)
%saveas(gcf,s2)
%draw_LogicalOnImage(BW30,Ic,'curve disc - BW30',3)
%saveas(gcf,s3)


%pair_no = point2pair(ListPair,Line_new,xypos,P);

%% Description
% algorithm_part1       % edge detection and transform pcl
% algorithm_part2h1     % do the shifting and check pair connections (shift all)
% algorithm_part2h2     % do the shifting and check pair connections (shift selected)
% algorithm_part3h1     % ransac fit plane , pca and corresponded pcls
% algorithm_part3h2     % assign the pose and orientation for the grasp draw pcl
% algorithm_part4       % send the point for ROS
