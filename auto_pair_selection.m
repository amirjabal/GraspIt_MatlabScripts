

%%

%feat_vec(x0,:) = [error_ransac dis_L1L2_3d  Line1_3dLength*100  Line1_nPixel  Line2_3dLength*100  Line2_nPixel  theta20 theta30] ;
%feat_vecN(x0,:) = [error_ransac/0.15  Line1_3dLength*100/Line1_nPixel  Line2_3dLength*100/Line2_nPixel...
%    abs(theta20-90)/180 min(theta30,180-theta30)/180  length(line1)/line2]; % normalized version **last element (theta30 needs be normalized better!!)

% weight_vec = [2 1 1 0.5 0.5 1] ; % july 26
weight_vec = [4 1 1 0.5 0.5 1 0.2 0.5 1] ;
error_pair = feat_vecN*weight_vec';

x0 = size(ListPair,1);
for i=1:x0 ;
if ((feat_vec(i,1) > P.max_error_ransac) || (feat_vec(i,2) > P.max_distance_3d) ||  (feat_vec(i,3)>P.max_L3d) || (feat_vec(i,5)>P.max_L3d))
    error_pair(i) = nan ;
end
end

error_pair = error_pair/sum(weight_vec);


[~,sorted_pairs] = sort(error_pair) ; 
temp1 = find(isnan(error_pair)==1) ;
sorted_pairs = setdiff(sorted_pairs,temp1,'stable') ;
sorted_pairs

