
clc
close all

im1 = zeros(size(Id_o)) ;
im1(Id_o==0)=1 ;
mask_sh_ed =  bwmorph(im1,'thicken',1); %mask shadows and edges


Itest(:,:,1)= 255*mask_sh_ed ; 
Itest(:,:,2)= 255*im1; 
Itest(:,:,3)= im1; 


mask_sh_ed2 =  bwmorph(mask_sh_ed,'bridge',3);
%mask_sh_ed2 =  bwmorph(im1,'thicken',2);
mask_ed = xor(mask_sh_ed2,im1) ;
figure;imshow(mask_ed)
% mask_ed = xor(mask_sh_ed,im1) ;
% 
% figure;imshow(mask_ed)
% [ListEdge_ed, ~,~ ] = edgelink(mask_ed, 3); %
% 
%  drawedgelist(ListEdge_ed, size(im1), 1, 'rand', 2); axis off  
%  
%[BW2,~] = edge(im1,'canny');
%  figure;imshow(BW2)
 [ListEdge_ed1, bw00,~ ] = edgelink(mask_ed); %

 
 drawedgelist(ListEdge_ed1, size(im1), 1, 'rand', 5); axis off  
 
 
 
 %%
 
im1 = zeros(size(Id_o)) ;
im1(Id_o==0)=1 ;
mask_sh_ed =  bwmorph(im1,'thicken',1);
Bsh = bwboundaries(mask_sh_ed );
figure;imshow(Ig)
hold on 
plot(Bsh{35}(:,2),Bsh{35}(:,1),'.','color','g') ;