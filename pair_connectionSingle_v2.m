%%

% it is different from the previous version in:
% the function nextmove_v2 is used instead of nextmove

% it is same 


%%
function [LPath, LFlag] = pair_connectionSingle_v2(DE3,ListPair,Line_new,pair_no)


ObjList = bwconncomp(DE3);
ListObj = ObjList.PixelIdxList ;
LFlag = false(length(ListPair),2) ;

for i=pair_no 
    
    flag_connection = false ;
    L_s = ListPair(i,1) ; L_e = ListPair(i,2) ;
    pt1 = Line_new(L_s,1:2)' ; pt2 = Line_new(L_s,3:4)' ;
    pt3 = Line_new(L_e,1:2)' ; pt4 = Line_new(L_e,3:4)' ;
    
    % find out the order of points
    if (norm(((pt1+pt3)/2)-((pt2+pt4)/2)) > norm(((pt1+pt4)/2)-((pt2+pt3)/2)))
        % order of points: p1 - p3 - p4 - p2
        pstart = [Line_new(L_s,9) Line_new(L_s,10)] ;
        pend   = [Line_new(L_e,9) Line_new(L_e,10)] ;
    else
        % order of points: p1 - p4 - p3 - p2
        pstart = [Line_new(L_s,9) Line_new(L_s,10)] ;
        pend   = [Line_new(L_e,10) Line_new(L_e,9)] ;
    end
    
    for j=1:2 % once from left side, once from right side of the lines
        Line_path = [] ;
        
        for k=1:length(ListObj)
            if ~isempty(find(ListObj{k}==pstart(j),1)) ;
                loc_s = k ;
            end
            if ~isempty(find(ListObj{k}==pend(j),1)) ;
                loc_e = k ;
            end
        end
        
        if loc_s == loc_e  % the object which lines are belonged to!
            flag_connection(j) = true ; % the lines are connected together
            flag_reached = false ;
            pnt_s = pstart(j) ;
            L_prev = L_s ;
            [ye,xe] = ind2sub(size(DE3),pend(j)) ;
            
            
            while ~flag_reached
                
                Line_path = [Line_path ; L_prev]  ;
                loc1 = find(Line_new(:,9)==pnt_s) ; %
                loc2 = find(Line_new(:,10)==pnt_s) ;
                loc = unique([loc1;loc2]) ; loc(loc==L_prev) = [] ;
                
                if (ismember(L_e,loc))
                    flag_reached = true ;
                    Line_path = [Line_path ; L_e] ;
                    LFlag(i,j) = true ; 
                    
                    
                elseif (isempty(loc)) ;
                    %display('this branch is open')
                    %[i j]
                    flag_reached = true ;
                    L_next = L_prev ;
                    
                elseif (length(loc)==1);
                    L_next = loc(1) ;
                elseif (length(loc)>1);
                    [ind] = NextMove_v2(loc, xe, ye, Line_new) ;
                    L_next = loc(ind) ;
                end
                
                temp = pnt_s ;
                pnt_s = Line_new(L_next,9:10) ;
                pnt_s(pnt_s==temp) = [] ;
                L_prev = L_next ;
                
                if length(Line_path)>10
                    flag_reached = true ;
                    %display('got stuck in the loop')
                    %[i j]
                end
            end
        end
        LPath{i,j}= Line_path ;
    end
end



end

