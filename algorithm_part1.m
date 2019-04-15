%% *******SECTION 1*******

%% REMOVE OUT OF ZONE DATA, FILL THE ZEROS, FILTER OUT OF RANGE DATA
Id1 = Id_o(P.zone(1):P.zone(2) , P.zone(3):P.zone(4)) ;

if P.fillhole
    tic
    [Id2, ~] = zeroElimMedianHoleFill(Id1);%%%% % ** slower but better
    display('Duration for hole filling: ')
    toc
else
    Id2 = Id1 ;
end

Id3 = zeros(size(Id_o)) ; Id3(P.zone(1):P.zone(2) , P.zone(3):P.zone(4)) = Id2 ;
Id3(Id3<P.lld)= 0 ; Id3(Id3>P.hhd)= 0 ; Id = Id3 ;

L00 = label2rgb(fix(Id_o));
L11 = label2rgb(fix(Id));

clear  Id1 Id2 Id3
%% FIND DEPTH DICOUNTINUTIES
[BW20,~] = edge(Id,'canny',P.thresh_dis);
BW20 = remove_boundries(BW20, P.zone , P.bound) ;

%% Filtering and taking Gradient for Curvature discountinuity
if P.filter_Id
    Idf = wiener2(Id,[P.sizeGFilter P.sizeGFilter]) ;
    [Gx, Gy] = imgradientxy(Idf);
else
    [Gx, Gy] = imgradientxy(Id);
end

if P.filter_gd
    Gx = wiener2(Gx,[P.sizeGFilter P.sizeGFilter]) ;
    Gy = wiener2(Gy,[P.sizeGFilter P.sizeGFilter]) ;
end

[Gmag, Gdir] = imgradient(Gx, Gy);

%%  Gdir modification

% Manually modifying Gdir for the elements which both Gx and Gy have small variations
% Purpose: removing the noise which appears in Gdir by Gx Gy sign flipping (Specially in front-view images)
if P.flag_ManualGradModif
    Gxm = Gx;
    Gym = Gy;
    indx11 = find(abs(Gxm)<P.thresh_ManuaGradModif);
    indx12 = find(abs(Gym)<P.thresh_ManuaGradModif);
    indx13 = intersect(indx11,indx12) ;
    Gdir(indx13) =  0;
end

clear indx11 indx12 indx13
%% Converting Gdir to 2 images with diff ranges and FINDING CURVATURE DISCOUNTINUTIES

% Since range of values for Gdir is [-180 ~ +180],
% we convert it to 2 matrices in the range of [-90~+90] and [0~+180] and
% then apply the edge detection (Details in my reports)

%case 1 : mirroring left-half to the right-half (left and right)
%case 2 : mirrors bottom-half to the top-half (up and down)

if P.flag_GdirMirror
    GdirLR = Gdir ;
    GdirLR(Gdir>90) = 180-GdirLR(Gdir>90);
    GdirLR(Gdir<-90) = -(180+GdirLR(Gdir<-90));
    
    GdirUD = Gdir ;
    index3= find(GdirUD<0) ;
    GdirUD(index3) = abs(Gdir(index3));
    if P.filter_gd
        GdirLR = wiener2(GdirLR,[P.sizeGFilter P.sizeGFilter]);
        GdirUD = wiener2(GdirUD,[P.sizeGFilter P.sizeGFilter]);
    end
    GdirLR(Id==0) = 0 ;
    GdirUD(Id==0) = 0 ;
    Gdir_modified = Gdir ;
    Gdir_modified(Id==0) = 0;
    
    [BW_GLR,~] = edge(GdirLR,'canny',P.thresh_curve_mirror);
    [BW_GUD,~] = edge(GdirUD,'canny',P.thresh_curve_mirror);
    BW30 = or(BW_GLR,BW_GUD) ;
    L22 = label2rgb(fix(180+Gdir_modified));
else
    if P.filter_gd
        Gdir = wiener2(Gdir,[P.sizeGFilter P.sizeGFilter]);
    end
    [BW30,~] = edge(Gdir,'canny',P.thresh_curve);
    L22 = label2rgb(fix(180+Gdir));
end

BW30 = remove_boundries(BW30, P.zone , P.bound) ;

%% *******SECTION 2*******

% SEGMENT AND LABEL THE CURVATURE LINES (CONVEX/CONCAVE)
DE10  = morpho_modify_0712(BW30) ;
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
DE_o = or(BWn,BW20) ;
DE3  = morpho_modify_0712(DE_o) ;

clear ListEdgeC ListSegLineC LineFeatureC ListPointC Line_newC ListPoint_newC Line_merged_nC
clear mt ind1 ptn

%% *******SECTION 3*******

% SEGMENT AND LABEL THE COMBINED IMAGE (DISC./CURV.)
[ListEdge,~, ~ ] = edgelink(DE3, P.tol_edge); %
ListSegLine = lineseg(ListEdge, P.tol_line); %
[LineFeature,ListPoint] = Lseg_to_Lfeat_v2(ListSegLine,ListEdge,size(Id)) ; %LineFeature(c0,:) = [y1 x1 y2 x2 L m alpha c0 lind1 lind2]

% OLD SETUP FOR MERGING : 
% merging the lines if satisfyin easy condition (same 2d slope)
% [Line_new,ListPoint_new,Line_merged_n] = merge_lines_1101(LineFeature,ListPoint,P.thresh_m, size(Id)) ; % merge broken lines
% DE1  = morpho_modify_0712(BW20) ;
% [Line_new] = LabelLineFeature_1026(Id,DE1,Line_new,P) ; % label the lines (dis/curv)


% NEW SETUP FOR MERGING :
% merging the lines if satisfying hard conditions (same 3d orientation)
DE1  = morpho_modify_0712(BW20) ;
[BW20_back,~] = edge(Id_background,'canny',P.thresh_dis);
DE1_back  = morpho_modify_0712(BW20_back) ;
[LineFeature] = LabelLine_EdgeType(Id_background,DE1_back,LineFeature,P,ListPoint) ; % label the lines (disc/curv)
[Line_new,ListPoint_new,Line_merged_n] = mergeLines_hardCond(LineFeature,ListPoint,Id, Gdir,BW20 , P) ;

clear ListEdge ListSegLine DE1

%% *******SECTION 4*******

% SELECT THE DESIRED LINES FROM THE LIST
f1 = find(Line_new(:,11)~=0) ;
LineInteresting = Line_new(f1,:) ;

% Use these lines to consider CD and DD
% g1 = find(Line_new(:,11)==9) ; 
% g2 = find(Line_new(:,11)==10) ; 
% g3 = find(Line_new(:,11)==13);
% gtot = [g1;g2;g3] ;
% LineInteresting = Line_new(gtot,:) ;



[~ ,index]  = sort(LineInteresting(:,7)) ;
LineInteresting = LineInteresting(index,:)   ;

% MATCH THE LINES TO GET THE PAIRS
ListPair = line_match_1026(LineInteresting,P) ;

clear index f1