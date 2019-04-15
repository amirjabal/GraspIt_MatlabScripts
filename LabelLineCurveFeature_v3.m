
function [Line_new] = LabelLineCurveFeature_v2(Id,Line_new,ListPoint_new,P)


%description : label the maximum curvature edges (convex/concave)
% based on the comparison between depth of edge points and average depth of
% its neighborhood

Line_new(:,11) = 0 ;

for cc=1:size(Line_new,1) ;
    uL = Line_new(cc,:) ;
    %if uL(5) > P.Cons_Lmin ;
    if 1
        dy = abs(uL(1)-uL(3)) ;
        dx = abs(uL(2)-uL(4)) ;
        if (dy>dx)||(dy==dx)
            
            pt1 = [uL(1) ; uL(2)-P.label_win_size ] ; % [y1 ; x1-ts]
            pt2 = [uL(1) ; uL(2)+P.label_win_size ] ; % [y1 ; x1+ts]
            pt3 = [uL(3) ; uL(4)-P.label_win_size ] ; % [y2 ; x2-ts]
            pt4 = [uL(3) ; uL(4)+P.label_win_size ] ; % [y2 ; x2+ts]

        else
            
            pt1 = [uL(1)-P.label_win_size ; uL(2)] ; % [y1 ; x1-ts]
            pt2 = [uL(1)+P.label_win_size ; uL(2)] ; % [y1 ; x1+ts]
            pt3 = [uL(3)-P.label_win_size ; uL(4)] ; % [y2 ; x2-ts]
            pt4 = [uL(3)+P.label_win_size ; uL(4)] ; % [y2 ; x2+ts]
           
        end
        
        % find out the order of points for detecting the interesting area
        if (norm(((pt1+pt3)/2)-((pt2+pt4)/2)) > norm(((pt1+pt4)/2)-((pt2+pt3)/2)))
            vx1 = [pt1 pt3 pt4 pt2] ;
            
        else
            vx1 = [pt1 pt4 pt3 pt2] ;
  
        end
        mask1 = roipoly(Id, vx1(2,:), vx1(1,:)) ;
        mask4 = Id.*mask1 ;
        mask4(mask4==0) = []  ;
        A1 = sum(mask4(:))/length(mask4) ;
        lind = ListPoint_new{cc} ;
        mask5 =Id(lind);
        mask5(mask5==0) = [] ;
        A2 = sum(mask5(:))/length(mask5);
        B1 = length(mask4)*A1 - length(mask5)*A2 ;
        B11 = B1/(length(mask4)-length(mask5)) ;
        
        if B11<A2
            Line_new(cc,11)= 12 ;
        else
            Line_new(cc,11)= 13 ;
        end
        
        
        
    end
end

