


function [seg_boundary,seg_adj_mat,seg_image, raw_labels]= fun_SurfSegProcess(bw_edges, min_area, Id)

% authored on 2019 01 11
% this function assigns labels to bounded areas by the input binary image
% filters out small areas (currently anything smaller than min_area pixels)


% to do 2019 01 11: clean up this function and variables
% there are a couple of bugs I guess here

[s_boundary,raw_labels,~,~] = bwboundaries(bw_edges);

loc_of_edges = (bw_edges==1);
label_of_edge = unique(raw_labels(loc_of_edges));

regionStatsTable = regionprops('table',raw_labels,'Area');
rowLargeAreaF = regionStatsTable.Area> min_area ; % set a indep parameter for this value
labels_large = find(rowLargeAreaF) ;
labels_large=setdiff(labels_large,label_of_edge); % remove label of edges

labels_large(labels_large==0)=[];

% this loop removes the segment which include non valid values from the
% segmentation outputs
for cnt=1:length(labels_large)
    label = labels_large(cnt);
    lind = find(raw_labels == label);
    depth_values = Id(lind);
    nonvalid_values = find(depth_values==0);
    if ( (length(nonvalid_values)/length(depth_values)) > 0.5 )
        labels_large(cnt) = 0 ;
    end
end

labels_large(labels_large==0) = []; 


%% Assign new labels to the segments and create a new labeled image


seg_image = zeros(size(raw_labels));
seg_boundary = cell(1,1);

for cnt=1:length(labels_large)
    label = labels_large(cnt);  % label of object to find neighbours of
    seg_image(raw_labels==label)=cnt;
    seg_boundary{cnt,1}=s_boundary{label,1};

end


seg_adj_mat = zeros(length(labels_large),length(labels_large));
se = ones(5); 
for cnt=1:length(labels_large)
    label = cnt;
    object = (seg_image == label);
      % 8-connectivity for neighbours - could be changed
    neighbours = imdilate(object, se) & ~object;
    neighbourLabels = unique(seg_image(neighbours));
    
    neighbourLabels(neighbourLabels==0)=[];
    seg_adj_mat(cnt,neighbourLabels)= 1 ;
end