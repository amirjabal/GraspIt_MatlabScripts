

% purpose: finding the optimal way to combine BW20 and BW30 to have minimum
% artifacts

%% ******** Modifying BW20 and BW30

BW_forg = shadows_detection(Id) ;

Ig =rgb2gray(L00) ;
mask_holes = zeros(size(Id)) ;
mask_holes(Id==0)=1 ;

mask_sh_ed =  bwmorph(mask_holes,'thicken',2); % mask of shadows+ their boundaries
BW_discXSh = and(~mask_sh_ed,BW20) ;  % mask of disc excluding shadows
%BW_discXShMorpho  = morpho_modify_0712(BW_discXSh) ;
BW_disc_fSh = or(BW_discXSh,BW_forg) ;
BW20p = BW_disc_fSh ; 

%
BW20_thicken =  bwmorph(BW20,'thicken',P.sizeGFilter);
BW20_thicken_not = ~BW20_thicken ; 
BW30_XDis = and(BW20_thicken_not,BW30) ; 
BW30p = BW30_XDis ; 


% just for testing
% mask_sh_ed5 =  bwmorph(mask_holes,'thicken',5);
% BW_curvXSh = and(~mask_sh_ed5,BW30) ; % mask of curve excluding shadows
% BW_curveXShMorpho  = morpho_modify_0712(BW_curvXSh) ;


% draw_2LogicalOnImage(BW20,BW30_XDis,Ic,'disc/curve new',12)
% draw_2LogicalOnImage(BW20,BW30,Ic,'depth/curve old.',11)
% 
% draw_2LogicalOnImage(BW30,BW30_XDis,Ic,'old vs new',11)
% draw_LogicalOnImage(BW20,Ic,'depth disc',12)
% 
% draw_LogicalOnImage(DE10,Ic,'after morpho old',13)
% draw_LogicalOnImage(DE10_new,Ic,'after morpho new',14)
% draw_2LogicalOnImage(BW20_thicken,BW30,Ic,'depth/curve disc.',14)



%% *******SECTION 2*******

% SEGMENT AND LABEL THE CURVATURE LINES (CONVEX/CONCAVE)
DE10  = morpho_modify_0712(BW30p) ;
[ListEdgeC, ~,~ ] = edgelink(DE10, P.tol_edge); %
ListSegLineC = lineseg(ListEdgeC, P.tol_line); %
[LineFeatureC,ListPointC] = Lseg_to_Lfeat_v2(ListSegLineC,ListEdgeC,size(Id)) ; %LineFeature(c0,:) = [y1 x1 y2 x2 L m alpha c0 lind1 lind2]
[Line_newC,ListPoint_newC,Line_merged_nC] = merge_lines_1101(LineFeatureC,ListPointC,P.thresh_m, size(Id)) ; % merge broken lines
[Line_newC] = LabelLineCurveFeature_v3(Id,Line_newC,ListPoint_newC,P) ; % label the lines (/max/min)


% DROP THE CONVEX LINES AND MAKE A NEW LOGICAL IMAGE
ind1 = find(Line_newC(:,11)==13) ;
ptn = [] ;
for mt=1:length(ind1)
    ptn = [ptn ; ListPoint_newC{ind1(mt)}(:)] ;
end
BWn = false(size(Id)) ;
BWn(ptn) = true ;

% APPLY OR OPERATION TO THE PROCESSED LOGICAL IMAGES FROM DISC. AND CURV.
DE_o = or(BWn,BW20p) ;
DE3  = morpho_modify_0712(DE_o) ;

clear ListEdgeC ListSegLineC LineFeatureC ListPointC Line_newC ListPoint_newC Line_merged_nC
clear mt ind1 ptn

%% *******SECTION 3*******

% SEGMENT AND LABEL THE COMBINED IMAGE (DISC./CURV.)
[ListEdge,~, ~ ] = edgelink(DE3, P.tol_edge); %
ListSegLine = lineseg(ListEdge, P.tol_line); %
[LineFeature,ListPoint] = Lseg_to_Lfeat_v2(ListSegLine,ListEdge,size(Id)) ; %LineFeature(c0,:) = [y1 x1 y2 x2 L m alpha c0 lind1 lind2]
[Line_new,ListPoint_new,Line_merged_n] = merge_lines_1101(LineFeature,ListPoint,P.thresh_m, size(Id)) ; % merge broken lines
DE1  = morpho_modify_0712(BW20p) ;
[Line_new] = LabelLineFeature_1026(Id,DE1,Line_new,P) ; % label the lines (dis/curv)

clear ListEdge ListSegLine DE1

%% *******SECTION 4*******

% SELECT THE DISIRED LINES FROM THE LIST
f1 = find(Line_new(:,11)~=0) ;
LineInteresting = Line_new(f1,:) ;
[~ ,index]  = sort(LineInteresting(:,7)) ;
LineInteresting = LineInteresting(index,:)   ;

% MATCH THE LINES TO GET THE PAIRS
ListPair = line_match_1026(LineInteresting,P) ;

clear index f1