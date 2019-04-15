close all
%%%


cc = 8 ;
Id_o = avgdepM{cc};

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

% APPLY OR OPERATION TO THE PROCESSED LOGICAL IMAGES FROM DISC. AND CURV.
DE_o = or(DE10,BW20) ;
DE3  = morpho_modify_0712(DE_o) ;


%%

BW_forg = shadows_detection(Id) ;

Ig =rgb2gray(L00) ;
im1 = zeros(size(Id)) ;
im1(Id==0)=1 ;

mask_sh_ed =  bwmorph(im1,'thicken',2); % mask of shadows+ their boundaries
BW_discXSh = and(~mask_sh_ed,BW20) ;  % mask of disc excluding shadows
BW_discXShMorpho  = morpho_modify_0712(BW_discXSh) ;
BW_disc_fSh = or(BW_discXSh,BW_forg) ;

mask_sh_ed5 =  bwmorph(im1,'thicken',5);
BW_curvXSh = and(~mask_sh_ed5,BW30) ; % mask of curve excluding shadows
BW_curveXShMorpho  = morpho_modify_0712(BW_curvXSh) ;


draw_LogicalOnImage(BW20,Ig,'BW20',11)
draw_LogicalOnImage(BW30,Ig,'BW30',12)

draw_LogicalOnImage(BW_discXSh,Ig,'filtered disc',13)
draw_LogicalOnImage(BW_curvXSh,Ig,'filtered cruve',15)
draw_LogicalOnImage(BW_forg,Ig,'BWforg',17)

draw_LogicalOnImage(BW_discXShMorpho,Ig,'filtered disc morpho',14)
draw_LogicalOnImage(BW_curveXShMorpho,Ig,'filtered curve morpho',16)
draw_LogicalOnImage(BW_disc_fSh,Ig,'disc final',18)













