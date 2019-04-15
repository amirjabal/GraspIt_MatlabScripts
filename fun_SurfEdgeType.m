
function [seg_adj_type] = fun_SurfEdgeType(Id, seg_image, seg_adj_mat, seg_boundary)


% first version authored on 1/14/2019
% this function makes 3 masks (edge mask, obj mask and neighbor mask) at the common points between two neighbors
% (according to seg adj mat), then based on convex property, depth
% difference and valid values of each mask, 
% assign a type to for the border of those two surface segment (depth discount. (dd), convex curvature disc. (cdx) and cdv,
% or not reliable (NR))
% 


% % build 3 masks for each piece of the contour : edge mask, object mask, neighbor mask

seg_adj_type = strings(size(seg_adj_mat));

labels = [1:size(seg_adj_mat,1)];

for cnt=1:length(labels)
    
    obj_label  = labels(cnt);
    object = (seg_image == obj_label);
    
    boundary_temp = seg_boundary{obj_label,1};
    image_edge = zeros(size(seg_image));
    boundary_temp_lin = sub2ind(size(seg_image),boundary_temp(:,1), boundary_temp(:,2) );
    image_edge(boundary_temp_lin) = 1;
    image_edge_thicken =  bwmorph(image_edge,'thicken',3);
    
    neighbors_labels = find(seg_adj_mat(:,obj_label)) ;
    
    for cnt2=1:length(neighbors_labels)
        
        neighbor_label = neighbors_labels(cnt2);
        neighbor = (seg_image == neighbor_label);
        mask_edge = neighbor & image_edge_thicken;
        
        mask_edge_thicken = bwmorph(mask_edge,'thicken',7);
        
        mask_object = object & mask_edge_thicken ;
        mask_neighbor = neighbor & mask_edge_thicken ;
        
        dVal_obj = Id.*mask_object ; dVal_obj = dVal_obj(:) ;
        dVal_neigh = Id.*mask_neighbor ; dVal_neigh = dVal_neigh(:) ;
        dVal_edge = Id.*mask_edge ; dVal_edge = dVal_edge(:) ;
        
        dVal_obj(dVal_obj==0)=[];
        dVal_neigh(dVal_neigh==0)=[];
        dVal_edge(dVal_edge==0)=[];
        
        d_obj = mean(dVal_obj) ;
        d_neigh = mean(dVal_neigh) ;
        d_edge = mean(dVal_edge) ;
        
        d_ave = (d_obj + d_neigh) /2;
        d_diff = abs(d_neigh - d_obj) ;
        
        
        if (length(dVal_neigh)> 4*length(dVal_edge)) % coeff depends on how thick the masks are
            if d_diff > 25 % unit: mm
                seg_adj_type(obj_label, neighbor_label) = 'dd';
            elseif d_ave > d_edge
                seg_adj_type(obj_label, neighbor_label) = 'cdx';
            else
                seg_adj_type(obj_label, neighbor_label) = 'cdv';
            end
            
        else
            seg_adj_type(obj_label, neighbor_label) = 'NR'; % not reliable
        end
        
        %         figure; imshow(labeloverlay(Ic,mask_edge_thicken));title('thicken edge');
        %         figure; imshow(labeloverlay(Ic,mask_object));title('mask_object');
        %         figure; imshow(labeloverlay(Ic,mask_neighbor));title('mask_neighbor');
    end
    
end