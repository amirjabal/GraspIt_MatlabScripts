
if ~P.shift_all
    
    SelectedLines = [] ;
    SelectedLines = [ListPair(pair_no,1) ; ListPair(pair_no,2) ] ;
    
    % return a 2d mask for tracking purposes
    maskroi = line2region (Ic,Line_new(SelectedLines(1),:),Line_new(SelectedLines(2),:)) ;
    
    %% *******SECTION 1*******
    
    % in order to pass only the disc. lines to depth shifting function
    f1 = [] ; f2 = [] ;
    if(Line_new(SelectedLines(1),11)==9)||(Line_new(SelectedLines(1),11)==10)
        f1 = SelectedLines(1) ;
    end
    if (Line_new(SelectedLines(2),11)==9)||(Line_new(SelectedLines(2),11)==10)
        f2 = SelectedLines(2) ;
    end
    
    [ListPoint_new_shifted] = depth_shift_v20805(ListPoint_new,Gmag, Line_new, Id, P,[f1 ; f2]) ;
    
    %% *******SECTION 2*******
    % CHECK PAIR CONNECTIONS
    [LPath, LFlag] = pair_connectionSingle_v2(DE3,ListPair,Line_new,pair_no) ; % this function is for a single pair
    % ADD THE CONNECTED POINTS TO THE PAIR'S BELONGED POINTS (EXTEND THE
    % POINTS) ???
    LFlag(:,3) = LFlag(:,1)&LFlag(:,2) ;
    ind = find(LFlag(:,3)==1) ;
    for i=1:length(ind)
        row = ind(i) ;
        Path{i} = unique([LPath{row,1};LPath{row,2}]) ;
        PathPoints{i} = [] ;
        for j=1:length(Path{i})
            PathPoints{i} = [PathPoints{i} ; ListPoint_new_shifted{Path{i}(j)}] ;
        end
    end
    ListGraspableLines = num2cell(ListPair) ;
    ListGraspableLines(ind,:) = LPath(ind,:) ;
    clear ind i row Path PathPoints f1 f2 SelectedLines
    
end

%% convert the target lines to a list of points
TargetLines = [ListGraspableLines{pair_no,1} ; ListGraspableLines{pair_no,2} ] ;
TargetLines = unique(TargetLines) ;  % this line is added on july 13 2017
TargetPoints = [] ; TargetPoints_noshift = [] ;
for i=1:size(TargetLines,1)
    TargetPoints = [TargetPoints ; ListPoint_new_shifted{TargetLines(i)}] ;
end
for i=1:size(TargetLines,1)
    TargetPoints_noshift = [TargetPoints_noshift ; ListPoint_new{TargetLines(i)}] ;
end



