

figure;
plot3(pcloudL1(:),pcloudL2(:),pcloudL3(:),'.k') ;
hold on
P_center = [-0.235 -0.086 0.842]';
mmm1 = pca_vec(17,:); 
temp3=[P_center-0.4*mmm1' P_center] ;
plot3(temp3(1,:) , temp3(2,:) , temp3(3,:),'r','linewidth',8) ;
hold off



% h1=impoly;
% BW1=createMask(h1);
%indx1=find(BW1); 

% h2=impoly;
% BW2=createMask(h2);
%indx2=find(BW2); 


Ixyz1 = Ixyz(:,:,1);Ixyz2 = Ixyz(:,:,2);Ixyz3 = Ixyz(:,:,3);

pt1 = [Ixyz1(indx1) Ixyz2(indx1) Ixyz3(indx1) ] ; 
pt2 = [Ixyz1(indx2) Ixyz2(indx2) Ixyz3(indx2) ] ; 

[coeff1,~,latent1] = pca(pt1) ;
[coeff2,~,latent2] = pca(pt2) ;

pca_vec1=coeff1(3,:) ;
pca_vec2=coeff2(:,3) ;
acosd(dot(pca_vec1,pca_vec2))

figure;plot3(pcloudL1(:),pcloudL2(:),pcloudL3(:),'.b');hold on
P_center = [0.707 -0.979 0.1025 ]';
hold on
mmm1 = pca_vec1;
temp3=[P_center-0.4*mmm1' P_center] ;
plot3(temp3(1,:) , temp3(2,:) , temp3(3,:),'g','linewidth',8) ;
hold off