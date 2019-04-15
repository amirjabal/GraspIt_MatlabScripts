

function [wint, winp, winn] = make_RecMask(uL,win_width)

        p1 = [uL(1) ; uL(2)] ;
        p2 = [uL(3) ; uL(4)] ;
        dy = abs(uL(1)-uL(3)) ;
        dx = abs(uL(2)-uL(4)) ;
        if (dy>dx)||(dy==dx) % line is vertical
            ptd1 = [uL(1) ; uL(2)-win_width] ; % [y1 ; x1-ts]
            ptd2 = [uL(1) ; uL(2)+win_width ] ; % [y1 ; x1+ts]
            ptd3 = [uL(3) ; uL(4)-win_width ] ; % [y2 ; x2-ts]
            ptd4 = [uL(3) ; uL(4)+win_width ] ; % [y2 ; x2+ts]
        else % Line is horizontal
            ptd1 = [uL(1)-win_width ; uL(2)] ;  % [y1-ts ; x1]
            ptd2 = [uL(1)+win_width ; uL(2)] ;  % [y1+ts ; x1]
            ptd3 = [uL(3)-win_width ; uL(4)] ;  % [y2-ts ; x2]
            ptd4 = [uL(3)+win_width ; uL(4)] ;  % [y2+ts ; x2]
        end
        % find out the order of points for detecting the interesting area
        if (norm(((ptd1+ptd3)/2)-((ptd2+ptd4)/2)) > norm(((ptd1+ptd4)/2)-((ptd2+ptd3)/2)))
            wint = [ptd1 ptd3 ptd4 ptd2] ;
            winp = [p1     p2 ptd4 ptd2] ;
            winn = [ptd1 ptd3 p2     p1] ;
            
            if(-45<uL(7))&&(uL(7)<-22.5)  % this condition added in the new version to solve a bug of the code!
                winn = [p1     p2 ptd4 ptd2] ;
                winp = [ptd1 ptd3 p2     p1] ;
            end  
        else % i guess this case never happens here in this code
            display ('check LabelLineFeature_1026! A bug happend!')
            wint = [ptd1 ptd4 ptd3 ptd2] ;
            winp = [p1   ptd4 p2   ptd2] ;
            winn = [ptd1   p2 ptd3   p1] ;
        end
end
