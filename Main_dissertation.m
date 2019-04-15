%

clc ;clear ;
imgnum=25;
close all
device_data= 'kinect' ;
dissertation_initial_parameters
P.mode = 'nothing' ;

%%  Run algorithm


algorithm_part1

draw_pairs_v2(ListPair,Line_new,Ic,1)
draw_disc_curv(Line_new,Ic,'Labeled line',2)

% contour_detection % script to find closed contours
% feature_3d_v2 % script to extract 3d features and stats of masks
if strcmp(P.mode,'manual')
    manus_pcl_process
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
elseif strcmp(P.mode,'nothing')
    
elseif strcmp(P.mode,'auto')
    manus_pcl_process
    for x0=1:size(ListPair,1)
        try
            pair_no = x0
            algorithm_part2
            algorithm_part3h1
            if f_success
                algorithm_part3h2
                PairsLabelAssignment % to label the pairs for training purposes
            end
        catch
            display(sprintf ('There was an error in computations of pair %d',pair_no))
            feat_vec(x0,:) = nan ;
            feat_vecN(x0,:)= nan ;
            PairTScore(x0) = 0 ; % to label the pairs for training purposes
        end
        clean_vars
    end
    
    
    MakeFeatureVector
    auto_pair_selection
    draw_pairs_v2(ListPair(sorted_pairs(1),:),Line_new,Ic,41) % filtered paired lines
end


%s1 = sprintf('data_training%d.mat',imgnum);
%save(s1,'P','PairTScore','PairFeatures_table','ListPair','Line_new','Ic')



%% Description
% algorithm_part1       % edge detection and transform pcl
% algorithm_part2h1     % do the shifting and check pair connections (shift all)
% algorithm_part2h2     % do the shifting and check pair connections (shift selected)
% algorithm_part3h1     % ransac fit plane , pca and corresponded pcls
% algorithm_part3h2     % assign the pose and orientation for the grasp draw pcl
% algorithm_part4       % send the point for ROS


%% for saving use the following codes:

% s1 = sprintf('runData0720_%d_Gradient.jpg',cc) ;
% figure(1) ; imshow(L22)
% saveas(gcf,s1)



