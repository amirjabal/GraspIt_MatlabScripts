

%% *******SECTION 1*******

% REMOVE OUT OF ZONE DATA, FILL THE ZEROS, FILTER OUT OF RANGE DATA
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

% FIND DEPTH DICOUNTINUTIES
[BW20,~] = edge(Id,'canny',P.thresh_dis);
BW20 = remove_boundries(BW20, P.zone , P.bound) ;

% FIND CURVATURE DISCOUNTINUTIES
[Gx, Gy] = imgradientxy(Id);
[Gmag, Gdir] = imgradient(Gx, Gy);

if P.filter_gd
    Gdir = wiener2(Gdir,[5 5]);
end

[BW30,~] = edge(Gdir,'canny',P.thresh_curve);
BW30 = remove_boundries(BW30, P.zone , P.bound) ;

L00 = label2rgb(fix(Id_o));
L11 = label2rgb(fix(Id));
L22 = label2rgb(fix(180+Gdir));