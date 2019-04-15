

% figure;
% subplot(1,2,1); imagesc(seg_obj_image)
% subplot(1,2,2); imagesc(I_ref)

% seg_obj_relabled = seg_obj_image;
% ref_labels = unique(I_ref);
% 
% for cnt=1:length(ref_labels)
%     ref_idx = find(I_ref==cnt);
%     extracted_labels = seg_obj_image(ref_idx);
%     extracted_labels(extracted_labels==0)=[];
%     guessed_label = median(extracted_labels);
%     seg_obj_relabled(find(seg_obj_image==guessed_label))=cnt;
% end


labels_meas = unique(seg_obj_image);
labels_meas(labels_meas==0)=[];
labels_ref = unique(I_ref);

mat_MeasToExpected = zeros(length(labels_meas),length(labels_ref)) ;  

for cnt=1:length(labels_meas)
    l_meas = labels_meas(cnt);
    
    vals_ref = I_ref(find(seg_obj_image==l_meas));
    %mat_MeasToExpected (cnt,:) = [l_meas, hist(vals_ref,length(labels_ref))/length(vals_ref);
    mat_MeasToExpected (cnt,:) = hist(vals_ref,length(labels_ref));
end
    
    