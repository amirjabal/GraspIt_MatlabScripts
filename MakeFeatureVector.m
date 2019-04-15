
%%
% compare the statistics extracted from
% the masks on 2 sides of an edge

Id3 = Id ; 
Id3(Id3==0) = nan ; 
index_nan = isnan(Id3) ; 
index_nan2 = find(index_nan) ; 

[GxRaw, GyRaw] = imgradientxy(Id3);
[GmagRaw, GdirRaw] = imgradient(GxRaw, GyRaw);
GdirRaw(index_nan2) = nan ; 
Gdir(index_nan2) = nan ; 
%close all
% question: how to handle shadows?
data_feat = [] ; 

for n=1:length(LineInteresting)
[wint, winp, winn] = make_RecMask(LineInteresting(n,:),9) ;
maskTot = roipoly(Id3, wint(2,:), wint(1,:)) ;
maskpos= roipoly(Id3, winp(2,:), winp(1,:)) ;
maskneg= roipoly(Id3, winn(2,:), winn(1,:)) ;

%DrawLineFeature(LineInteresting(n,:),Ic,'Target Line',21)
%draw_2LogicalOnImage(maskpos,maskneg,Ic,'Red:Pos Blue:Neg',n)

index_pos = find(maskpos) ; 
index_neg = find(maskneg) ; 

dVal_Pos = Id3(index_pos) ; id1 = find(isnan(dVal_Pos)) ; dVal_Pos(id1) = [] ; 
dVal_Neg = Id3(index_neg) ; id1 = find(isnan(dVal_Neg)) ; dVal_Neg(id1) = [] ; 


gVal_Pos = Gdir(index_pos) ;id1 = find(isnan(gVal_Pos)) ; gVal_Pos(id1) = [] ; 
gVal_Neg = Gdir(index_neg) ;id1 = find(isnan(gVal_Neg)) ; gVal_Neg(id1) = [] ; 


gRVal_Pos = GdirRaw(index_pos) ;id1 = find(isnan(gRVal_Pos)) ; gRVal_Pos(id1) = [] ; 
gRVal_Neg = GdirRaw(index_neg) ;id1 = find(isnan(gRVal_Neg)) ; gRVal_Neg(id1) = [] ; 


data_feat(n,:) = [length(index_pos) ...
                length(dVal_Pos) length(dVal_Neg) ....
                mean(dVal_Pos) mean(dVal_Neg) median(dVal_Pos) median(dVal_Neg) ...
                mean(gVal_Pos) mean(gVal_Neg) mean(gRVal_Pos) mean(gRVal_Neg) ...
                median(gVal_Pos) median(gVal_Neg) median(gRVal_Pos) median(gRVal_Neg) ...
                sqrt(var(gVal_Pos)) sqrt(var(gVal_Neg)) sqrt(var(gRVal_Pos)) sqrt(var(gRVal_Neg)) ] ;

end

%%
PairFeatures = [] ; 

for pair_no=1:length(ListPair)
    
    idx1 = find(LineInteresting(:,8)==ListPair(pair_no,1)) ;
    idx2 = find(LineInteresting(:,8)==ListPair(pair_no,2)) ;
    PairFeatures(pair_no,:) = [feat_vec(pair_no,:) data_feat(idx1,:) data_feat(idx2,:)] ;
end

PairFeatures2 = ...
[PairFeatures(:,1), PairFeatures(:,2), PairFeatures(:,10), PairFeatures(:,11), PairFeatures(:,3)./PairFeatures(:,5), ...
 PairFeatures(:,3), PairFeatures(:,4)./PairFeatures(:,3), abs(PairFeatures(:,15)-PairFeatures(:,16)), abs(PairFeatures(:,25)-PairFeatures(:,26)), PairFeatures(:,13)./PairFeatures(:,12), PairFeatures(:,14)./PairFeatures(:,12),  ...
 PairFeatures(:,5), PairFeatures(:,6)./PairFeatures(:,5), abs(PairFeatures(:,34)-PairFeatures(:,35)), abs(PairFeatures(:,44)-PairFeatures(:,45)), PairFeatures(:,32)./PairFeatures(:,31), PairFeatures(:,33)./PairFeatures(:,31) , ...
 ] ; 


%%  convert the arrays to table
PairFeatures_table = array2table(PairFeatures,'VariableNames',{ ... 
    'e_ransac','pair_d',...
    'L_line1','n_line1','L_line2','n_line2',...
    'theta1','theta2','theta3',...
    'angle_3d','depth_ave',...
    'l_mask','l_d_pos','l_d_neg', ...
    'mean_d_pos' , 'mean_d_neg','median_d_pos','median_d_neg', ...
    'mean_g_pos','mean_g_neg','mean_gr_pos','mean_gr_neg',...
    'md_g_pos','md_g_neg','md_gr_pos','md_gr_neg',...
    'var_g_pos','var_g_neg','var_gr_pos','var_gr_neg',...
    'l_mask2','l_d_pos2','l_d_neg2',...
    'mean_d_pos2' , 'mean_d_neg2','median_d_pos2','median_d_neg2',...
    'mean_g_pos2','mean_g_neg2','mean_gr_pos2','mean_gr_neg2',...
    'md_g_pos2','md_g_neg2','md_gr_pos2','md_gr_neg2',...
    'var_g_pos2','var_g_neg2','var_gr_pos2','var_gr_neg2'}) ;


PairFeatures2_table = array2table(PairFeatures2, 'variablenames',...
    {'ErrorRANSAC' , 'PairDistance' , 'Angle3D', 'PairDepth', 'L1_L2', ...
  'Length_L1','Pixel_Length_L1','DeltaDepth_L1','DeltaGDir_L1','RatioPosMask_L1','RatioNegMask_L1',...
  'Length_L2','Pixel_Length_L2','DeltaDepth_L2','DeltaGDir_L2','RatioPosMask_L2','RatioNegMask_L2',...
 }) ;


%% Test the model
draw_pair_seperate  
% close all
% load('TrainedCubicSVM20180406.mat')
% yfit = trainedModel.predictFcn(PairFeatures2_table) 
% draw_pairs_v2(ListPair,Line_new,Ic,1)



%%

% edges = [-180:10:180];
% 
% figure; hold on ;
% subplot(1,2,1);histogram(dVal_Neg);
% subplot(1,2,2);histogram(dVal_Pos); hold off
% 
% figure; hold on ;
% subplot(2,2,1) ; histogram(gRVal_Neg,edges);
% subplot(2,2,2) ; histogram(gRVal_Pos,edges);
% subplot(2,2,3) ; histogram(gVal_Neg,edges);
% subplot(2,2,4) ; histogram(gVal_Pos,edges); hold off
% 
% 
% 
% 
% h2_neg = histogram(gRVal_Neg,edges);
% temp1 = h2_neg.Values ;
% h2_pos =  histogram(gRVal_Pos,edges);
% temp2 = h2_pos.Values ;
%figure;plot(temp1);hold on ; plot(temp2) ; hold off

    
