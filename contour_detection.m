
%% ********CONTOUR DETECTION STEP
BW90 = or(BW20,BW30);
BW91  = morpho_modify_0712(BW90) ;
[s_boundary,s_label,s_number,s_dep] = bwboundaries(BW91);

regionStatsTable = regionprops('table',s_label,'Centroid','Area','PixelIdxList');
LabelVal = [1:size(regionStatsTable,1)]';
regionStatsTable = [table(LabelVal) regionStatsTable ] ;
rowLargeAreaF = regionStatsTable.Area>500 ; % set a indep parameter for this value
rowLargeArea = find(rowLargeAreaF) ;

ListSegLine = cell(size(rowLargeArea,1),2) ;
for n=2:size(rowLargeArea,1)
    ListSegTemp = lineseg(s_boundary(rowLargeArea(n)), P.tol_line); %
    ListSegLine{n,1}= rowLargeArea(n);
    ListSegLine{n,2}= ListSegTemp{1};
    figure(n);imshow(Ic); hold on
    r1 = ListSegLine{n,2}(:,1);
    c1 = ListSegLine{n,2}(:,2);
    line(c1,r1,'color','red','LineWidth',3)
    hold off
    
    
    
    indLabel = find(SL==n ) ;
    intrestRegion3D = zeros(size(indLabel,1),3);
    intrestRegion3D(:,1) = pcloudL1(indLabel) ; intrestRegion3D(:,2) = pcloudL2(indLabel) ; intrestRegion3D(:,3) = pcloudL3(indLabel) ;
    [coeff,~,latent] = pca(intrestRegion3D) ;
    pca_array (:,:,n) = coeff ;   
end



[LineFeatureSS,ListPointSS] = Lseg_to_Lfeat_v2(ListSegLine(:,2),s_boundary(rowLargeArea),size(Id)) ;
DE1  = morpho_modify_0712(BW20) ;
[BW20_back,~] = edge(Id_background,'canny',P.thresh_dis);
DE1_back  = morpho_modify_0712(BW20_back) ;

[LineFeatureSS] = LabelLine_EdgeType(Id_background,DE1_back,LineFeatureSS,P,ListPointSS) ;




% acosd(dot(pca_vec(41,:),pca_vec(34,:)))
%figure;imagesc(Id_o);
% h2=impoly;
% BW2=createMask(h2);

%%
% P.Cons_Cam = 526;     % PRIME SENSE FOCAL LENGTH
% P.center = [ 313.8042  259.2228];
% %P.Cons_Cam = 200;
% %P.center = [ 768/2  576/2];
% [pcloud, ~] = depthToCloud_v2(Id_o,P.Cons_Cam , [1 1], P.center) ;
% pcloudL1 = pcloud(:,:,1) ; pcloudL2 = pcloud(:,:,2) ; pcloudL3 = pcloud(:,:,3) ;
%





