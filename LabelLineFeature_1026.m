
function [Line_new] = LabelLineFeature_1026(Id,BW20,Line_new,P)


%description : label lines: disc. or curv.
% pros and cons: it just compares with discontinuty image to check if it is
% discountinuty edge or not!!


Line_new(:,11) = 0 ; % a feature to show disc+/disc-/curv
Line_new(:,12) = 0 ; % a feature to show vertical/horizontal

for cc=1:size(Line_new,1) ;
    uL = Line_new(cc,:) ;
    if uL(5) > P.Cons_Lmin ;
        p1 = [uL(1) ; uL(2)] ;
        p2 = [uL(3) ; uL(4)] ;
        dy = abs(uL(1)-uL(3)) ;
        dx = abs(uL(2)-uL(4)) ;
        if (dy>dx)||(dy==dx)
            ptd1 = [uL(1) ; uL(2)-P.label_win_sized ] ; % [y1 ; x1-ts]
            ptd2 = [uL(1) ; uL(2)+P.label_win_sized ] ; % [y1 ; x1+ts]
            ptd3 = [uL(3) ; uL(4)-P.label_win_sized ] ; % [y2 ; x2-ts]
            ptd4 = [uL(3) ; uL(4)+P.label_win_sized ] ; % [y2 ; x2+ts]
            Line_new(cc,12) = 1 ; % line is vertical
        else
            ptd1 = [uL(1)-P.label_win_sized ; uL(2)] ;  % [y1-ts ; x1]
            ptd2 = [uL(1)+P.label_win_sized ; uL(2)] ;  % [y1+ts ; x1]
            ptd3 = [uL(3)-P.label_win_sized ; uL(4)] ;  % [y2-ts ; x2]
            ptd4 = [uL(3)+P.label_win_sized ; uL(4)] ;  % [y2+ts ; x2]
            Line_new(cc,12) = 2 ;  % Line is horizontal
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
        
        maskd1 = roipoly(Id, vxd1(2,:), vxd1(1,:)) ;
        edd = find(maskd1==1) ;
        maskd2 = BW20(edd) ;
        xjd  = find(maskd2==1) ;
        tdd = length(xjd)/length(maskd2) ;
        if (tdd>P.thresh_label_dis) % edge is disc.
            
            maskpos= roipoly(Id, winp(2,:), winp(1,:)) ;
            maskneg= roipoly(Id, winn(2,:), winn(1,:)) ;
            edp = find(maskpos==1) ;
            edn = find(maskneg==1) ;
            depth_pos = Id(edp) ;
            depth_neg = Id(edn) ;
            depth_pos(depth_pos==0)=[];
            depth_neg(depth_neg==0)=[];
            dp = sum(depth_pos)/length(depth_pos) ;
            dn = sum(depth_neg)/length(depth_neg) ;
            if dp>dn
                Line_new(cc,11)= 9 ;  % object is on the negetive side of the line
            elseif(dp<dn)
                Line_new(cc,11)= 10 ;  % object is on the positive side of the line
            end
            
            % added on 2017/07/25 : check if the percentage of non-return
            % values in the mask is higher than a threshold, assume object
            % is on the opposite direction
            if ((length(depth_pos)/length(edp))<0.7) && ((length(depth_neg)/length(edn))<0.7) % if both have zeros
                [~, idxx1] = max([(length(depth_pos)/length(edp)) ; (length(depth_neg)/length(edn))]) ;
                switch idxx1
                    case 1
                        Line_new(cc,11)= 10 ;  %
                    case 2
                        Line_new(cc,11)= 9 ;
                end
            elseif (length(depth_pos)/length(edp))<0.7
                Line_new(cc,11)= 9 ;  % object is on the negetive side of the line bc pos side is shadows
            elseif(length(depth_neg)/length(edn))<0.7
                Line_new(cc,11)= 10 ;  % object is on the positive side of the line bc neg side is shadows
            end
        else
            Line_new(cc,11)= 13 ; % it is curvature
        end
    end
end
end

