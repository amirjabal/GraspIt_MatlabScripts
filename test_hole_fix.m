close all
im1 = zeros(size(Id_o)) ; 
im1(Id_o==0)=1 ; 
im1= bwlabel(im1) ; 

% need to be modified
im2 = zeros(size(im1)) ; 
%im2(260:390,300:450) = im1(260:390,300:450) ; %number 36
im2(280:402,378:430) = im1(280:402,378:430) ; %number 42

im3 = zeros(size(im2)) ; im3(im2==42) = 1; 


mask1 =  bwmorph(im3,'thicken',1);
mask_val = mask1.*Id_o ;

mask_bound = zeros(size(mask1)) ; 
mask_bound(mask_val>0)=1 ; 

figure; imshow(mask_bound)
figure; imagesc(mask_val)

%%
index = find(mask_val>0) ; 
set_main = mask_val(index) ; 

CC = bwconncomp(mask_bound) ; 
vec_index = []; 
for i=1:length(CC.PixelIdxList)
    vec_index = [vec_index ; CC.PixelIdxList{i}];
end


vector_val = mask_val(vec_index);
vector_grad = abs(gradient(vector_val));
figure;plot(vector_val);
figure; plot(vector_grad)

[~, idx1] = max(vector_grad) ;
[~ ,idx2] = min(vector_val) ;
mask_final = zeros(size(Id_o)) ;
mask_final(vec_index(idx1)) = 1;
mask_final(vec_index(idx2)) = 1; 
figure;imshow(mask_final)
Ig = rgb2gray(L00);



[I1,J1] = ind2sub(size(Ig),vec_index(idx1)) ;
[I2,J2] = ind2sub(size(Ig),vec_index(idx2)) ;


figure; imshow(Ig) ; hold on
plot(J1,I1,'.','color','r') ;
plot(J2,I2,'.','color','r') ;


