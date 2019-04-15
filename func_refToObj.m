

ref_labels = double(unique(I_ref));
mat_refObj = nan(length(ref_labels),2);
mat_refObj(:,1) = double(ref_labels);

for cnt=2:length(ref_labels)
    I_mask = I_ref==ref_labels(cnt) ;
    I_mask2 = double(I_mask).*seg_obj_image;
    I_mask2 = I_mask2(:); 
    I_mask2(I_mask2==0) = [];
    mat_refObj(cnt,2) = median(I_mask2); 
    
end

mat_refObj(1,2) = 0;
I_obj_new = zeros(size(I_ref));

for cnt=2:length(mat_refObj)
    new_label = mat_refObj(cnt,1);
    old_label = mat_refObj(cnt,2);
    mask_old= find(seg_obj_image==old_label);
    I_obj_new(mask_old)=new_label;
end


for cnt=2:length(mat_refObj)
    ground_truth = find(I_ref==mat_refObj(cnt,1));
    segment_output = find(I_obj_new==mat_refObj(cnt,1));
    TP = length(intersect(ground_truth,segment_output));
    FP = length(setdiff(segment_output,ground_truth));
    FN = length(setdiff(ground_truth,segment_output));
    TN = size(I_ref,1)*size(I_ref,2)-length(union(ground_truth,segment_output));
    
    Precision_seg = TP/(TP+FP);
    Recall_seg = TP/(TP+FN);
    
    %Accuracy_Seg = (TP+TN)/(TP+TN+FP+FN);
    
    
end
    
    
eval_vector(imgnum,:) = [length(unique(mat_refObj(:,1))),length(unique(mat_refObj(:,2))) ];