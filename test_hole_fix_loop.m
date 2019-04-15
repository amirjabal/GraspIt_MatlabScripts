% clc ; clear all ; close all
% load('H:/2017 Research/Manus Datasets codes/datasets/07191.mat')
for cc = 1
    
%     device_data= 'prime';
%     manus_initial_parameters
    
    im1 = zeros(size(Id_o)) ;
    im1(Id_o==0)=1 ;
    im1= bwlabel(im1) ;
    
    % need to be modified
    im2 = zeros(size(im1)) ;
    im2(P.zone(1):P.zone(2) , P.zone(3):P.zone(4)) = im1(P.zone(1):P.zone(2) , P.zone(3):P.zone(4)) ; %number 36
    %im2(280:402,378:430) = im1(280:402,378:430) ; %number 42
    label_val = unique(im2) ;
    label_val(label_val==0)=[];
    jj = 0 ;
    L00 = label2rgb(fix(Id_o));
    Ig = rgb2gray(L00);
    figure; imshow(Ig) ; hold on
    tic
    for cntr=1:length(label_val)
    %for cntr=36:36
        tt1 = find(im2==label_val(cntr));
        if length(tt1)>20 && length(tt1)<5000
            im3 = zeros(size(im2)) ; im3(im2==label_val(cntr)) = 1;
            
            
            mask1 =  bwmorph(im3,'thicken',1);
            mask_val = mask1.*Id_o ;
            
            mask_bound = zeros(size(mask1)) ;
            mask_bound(mask_val>0)=1 ;
            
            
            %%
            index = find(mask_val>0) ;
            set_main = mask_val(index) ;
            
            CC = bwconncomp(mask_bound) ;
            vec_index = [];
            for i=1:length(CC.PixelIdxList)
                vec_index = [vec_index ; CC.PixelIdxList{i}];
            end
            
            
            [row,col] = ind2sub(size(Ig),vec_index) ;
            [~, idx1] = min(row) ;
            [~, idx2] = max(row) ;
            I1 = row(idx1); J1 = col(idx1) ;
            I2= row(idx2); J2 = col(idx2) ;
            set1 = vec_index(min(idx1,idx2):max(idx1,idx2)) ;
            set2 = [vec_index(1:min(idx1,idx2)) ; vec_index(max(idx1,idx2):end)] ;
            
            
            
            
            %         vector_val = mask_val(vec_index);
            %         vector_grad = abs(gradient(vector_val));
            %         %figure;plot(vector_val);
            %         %figure; plot(vector_grad)
            %
            %         [~, idx1] = max(vector_grad) ;
            %         [~ ,idx2] = min(vector_val) ;
            %         mask_final = zeros(size(Id_o)) ;
            %         mask_final(vec_index(idx1)) = 1;
            %         mask_final(vec_index(idx2)) = 1;
            %         %figure;imshow(mask_final)
            
            
            [I1,J1] = ind2sub(size(Ig),vec_index(idx1)) ;
            [I2,J2] = ind2sub(size(Ig),vec_index(idx2)) ;
            
            
            
            %[I1,J1] = ind2sub(size(Ig),set1) ;
            %[I2,J2] = ind2sub(size(Ig),set2) ;
            
            plot(J1,I1,'*','color','r') ;
            plot(J2,I2,'*','color','b') ;
            
            
            hold on
        else
            jj = jj+1 ;
        end
    end
    grid on
    hold off
    toc
    jj
    cntr
end


% [I10,J10] = ind2sub(size(Ig),CC.PixelIdxList{1}) ;
% figure ; imshow(Ig) ; hold on
% plot(J10,I10,'.','color','r') ;
vec1 = CC.PixelIdxList{1}; [I2,J2] = ind2sub(size(Ig),vec4) ;
vec2 = CC.PixelIdxList{2};
vec3 = CC.PixelIdxList{3};
vec4 = CC.PixelIdxList{4};
vec5 = CC.PixelIdxList{5};

