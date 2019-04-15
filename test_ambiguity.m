
function [line_masks] = ambiguity_test(Id,Gdir,Line_new,P)



%%

P.label_win_sized =6; 

for cc=1:size(Line_new,1) ;
    uL = Line_new(cc,:) ;
    if uL(5) > P.Cons_Lmin ;
        p1 = [uL(1) ; uL(2)] ;
        p2 = [uL(3) ; uL(4)] ;
        if (Line_new(cc,12) == 1 ) % line is vertical
            ptd1 = [uL(1) ; uL(2)-P.label_win_sized ] ; % [y1 ; x1-ts]
            ptd2 = [uL(1) ; uL(2)+P.label_win_sized ] ; % [y1 ; x1+ts]
            ptd3 = [uL(3) ; uL(4)-P.label_win_sized ] ; % [y2 ; x2-ts]
            ptd4 = [uL(3) ; uL(4)+P.label_win_sized ] ; % [y2 ; x2+ts]
            Line_new(cc,12) = 1 ; % line is vertical
        else % Line is horizontal
            ptd1 = [uL(1)-P.label_win_sized ; uL(2)] ;  % [y1-ts ; x1]
            ptd2 = [uL(1)+P.label_win_sized ; uL(2)] ;  % [y1+ts ; x1]
            ptd3 = [uL(3)-P.label_win_sized ; uL(4)] ;  % [y2-ts ; x2]
            ptd4 = [uL(3)+P.label_win_sized ; uL(4)] ;  % [y2+ts ; x2]   
        end
        
        % find out the order of points for detecting the interesting area
        if (norm(((ptd1+ptd3)/2)-((ptd2+ptd4)/2)) > norm(((ptd1+ptd4)/2)-((ptd2+ptd3)/2)))
            vxd1 = [ptd1 ptd3 ptd4 ptd2] ;
            winp = [p1     p2 ptd4 ptd2] ;
            winn = [ptd1 ptd3 p2     p1] ;
            
            if(-45<uL(7))&&(uL(7)<-22.5)  % this condition added in the new version to solve a bug of the code!
                winn = [p1     p2 ptd4 ptd2] ;
                winp = [ptd1 ptd3 p2     p1] ;
            end
            
        else % i guess this case never happens here in this code
            display ('check LabelLineFeature_1026! A bug happend!')
            vxd1 = [ptd1 ptd4 ptd3 ptd2] ;
            winp = [p1   ptd4 p2   ptd2] ;
            winn = [ptd1   p2 ptd3   p1] ;
        end
 
        
        if (Line_new(cc,11)== 9 )  % object is on the negetive side of the line
            amb_mask = winp ; 
        elseif(Line_new(cc,11)== 10)   % object is on the positive side of the line
            amb_mask = winn ;
        end
        
        d_mask = roipoly(Id, amb_mask(2,:), amb_mask(1,:)) ;
        
        line_masks(:,:,cc) = d_mask ;       
    end
end
end

