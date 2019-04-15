


% based on the following features, filters the pairs

error_ransac = error_plane/size(set_points,1)*100 ; 
flag1 = flag_orientation ; 
d_pair = dis_L1L2_3d ; % unit: meter / distance of the mean point of the second line from the first line
n1 = size(set_points,1) ; % number of inlier points in ransac plane
n2 = size(set_points2,1) ; % number of points for fitting the first line
n3 = size(set_points3,1) ; % number of points for fitting the second line

feat_vec(x0,:) = [error_ransac n1 n2 n3 d_pair] ;
if (error_ransac<0.11) && (n1>45) && (n2>4) && (n3>4) && (d_pair>0.02) && (d_pair<0.07) && (strcmp(flag1,'side'))
    display(sprintf('pair number %d passed', pair_no))
    filtered_pairs = [filtered_pairs , pair_no] ;
else
    display(sprintf('pair number %d is dropped', pair_no))
end

sqrt(sum((var_v1(:,1)-var_v1(:,2)).^2))
sqrt(sum((var_l1(:,1)-var_l1(:,2)).^2))
sqrt(sum((var_v2(:,1)-var_v2(:,2)).^2))  
sqrt(sum((var_l2(:,1)-var_l2(:,2)).^2)) 


