
function [seg_obj, seg_obj_image] = fun_Surf2Obj(seg_adj_type, seg_adj_mat , seg_image)


% First version is authored on 1/14/2019

    %% this section use seg_adj_type_mat to combine the segments
    
    % currently the only condition to check is if the common edge is convex
    % also it check if the seg adj type matrix returns symmetric, otherwise
    % doesn't consider that edge
    
   
    labels = 1:length(seg_adj_type);
    
    for i = 1:length(labels)
        for j = 1:length(labels)
            if seg_adj_type(i,j) ~= seg_adj_type(j,i)
                seg_adj_type(i,j) = 'NS'; % not sysmmetric
                seg_adj_type(j,i) = 'NS';
            end
        end
    end
    
    lind1 = find(tril(seg_adj_mat)==1);
    lind2 = find(seg_adj_type == 'cdx');
    [row,col] = ind2sub(size(seg_adj_mat),intersect(lind1,lind2));
    seg_obj_temp = cell(1,1);
    
    for cnt1=1:length(row)
        seg_obj_temp{cnt1,1} = [row(cnt1),col(cnt1)];
    end
    
    
    seg_obj = seg_obj_temp;
    % merge surfaces that have convexity
    % we run the loops 2 times to make sure it converges
    for cnt1=1:length(seg_obj)
        for cnt2 = 1:length(seg_obj)
            if cnt1==cnt2
                continue
            end
            
            
            set_temp = intersect (seg_obj{cnt1,1},seg_obj{cnt2,1}) ;
            if ~isempty(set_temp)
                seg_obj{cnt1,1} = union(seg_obj{cnt1,1},seg_obj{cnt2,1});
            end
        end
    end
    
    for cnt1=1:length(seg_obj)
        for cnt2 = 1:length(seg_obj)
            if cnt1==cnt2
                continue
            end
            set_temp = intersect (seg_obj{cnt1,1},seg_obj{cnt2,1}) ;
            if ~isempty(set_temp)
                seg_obj{cnt1,1} = union(seg_obj{cnt1,1},seg_obj{cnt2,1});
            end
        end
    end
    
    
    % create an image based on new labels of the object
    
    seg_obj_image = seg_image;
    
    for cnt1 = 1:length(seg_obj)
        labels_temp = seg_obj{cnt1,1};
        for cnt2=1:length(labels_temp)
            lind_temp = find(seg_image==labels_temp(cnt2));
            seg_obj_image(lind_temp) = length(labels) + cnt1 ;
        end
    end
    