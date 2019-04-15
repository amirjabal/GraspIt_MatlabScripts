
close all
%load('H:/2017 Research/Manus Datasets codes/datasets/07191.mat')
%cc =25;
Id_o = avgdepM{cc};
L00 = label2rgb(fix(Id_o));
Ig = rgb2gray(L00);
im1 = zeros(size(Id_o)) ;
im1(Id_o==0)=1 ;
mask_sh_ed =  bwmorph(im1,'thicken',1);
Bsh = bwboundaries(mask_sh_ed );
figure ; imshow(Ig) ; hold on

for cntr=1:size(Bsh,1)
    if size(Bsh{cntr},1)<500 && size(Bsh{cntr},1)>15
        rows = Bsh{cntr}(:,1) ;
        cols = Bsh{cntr}(:,2) ;
        [~, idx1] = min(rows) ;
        [~, idx2] = max(rows) ;
        set1 = Bsh{cntr}(min(idx1,idx2):max(idx1,idx2),:) ;
        set2 = [Bsh{cntr}(1:min(idx1,idx2),:) ; Bsh{cntr}(max(idx1,idx2):end,:)] ;
        lset1 = sub2ind(size(im1), set1(:,1), set1(:,2));
        lset2 = sub2ind(size(im1), set2(:,1), set2(:,2));
        lset1_d = Id_o(lset1) ; lset1_d(lset1_d==0) = [];
        lset2_d = Id_o(lset2) ; lset2_d(lset2_d==0) = [];
        d_set1 = mean(lset1_d) ;
        d_set2 = mean(lset2_d) ;
        if d_set1>d_set2
            plot(set1(:,2),set1(:,1),'.','color','r') ; %background
            plot(set2(:,2),set2(:,1),'.','color','b') ;
        else
            plot(set1(:,2),set1(:,1),'.','color','b') ;
            plot(set2(:,2),set2(:,1),'.','color','r') ; %background
        end
        
        %%
        %         figure ;
        %         lset = sub2ind(size(im1), rows, cols);
        %         vector_val = Id_o(lset) ;
        %         vector_val(vector_val==0)= [];
        %         vector_grad = abs(gradient(vector_val));
        %         figure ; plot(vector_val)
        %         figure;plot(vector_grad)
        
        
    end
    
end

