
function [Line_new] = LabelLine_EdgeType(Id,BW20,Line_new,P, ListPoint_new)


%description : label lines: disc. or curv.
% pros and cons: it just compares with discontinuty image to check if it is
% discountinuty edge or not!!


% Line_new(:,11)  % a feature to show disc+/disc-/curv
% Line_new(:,12)  % a feature to show vertical/horizontal

% 2017/10/25
% updates: - checks for CD edges and label if they are convex or concave
% - some code lines are transfered to a new func




for cc=1:size(Line_new,1) ;
    uL = Line_new(cc,:) ;
    if uL(5) > P.Cons_Lmin ;
        
        [wint, winp, winn] = make_RecMask(uL,P.label_win_sized) ;
        maskTot = roipoly(Id, wint(2,:), wint(1,:)) ;
        
        totIdx = find(maskTot==1) ;
        nTot = length(totIdx) ;
        maskd2 = BW20(totIdx) ;
        xjd  = find(maskd2==1) ;
        tdd = length(xjd)/length(maskd2) ;
        
        maskpos= roipoly(Id, winp(2,:), winp(1,:)) ;
        maskneg= roipoly(Id, winn(2,:), winn(1,:)) ;
        
        dVal_Pos = Id.*maskpos ; dVal_Pos = dVal_Pos(:) ;
        dVal_Neg = Id.*maskneg ; dVal_Neg = dVal_Neg(:) ;
        
        dVal_Pos(dVal_Pos==0)=[];
        dVal_Neg(dVal_Neg==0)=[];
        
        dp = mean(dVal_Pos) ;
        dn = mean(dVal_Neg) ;
        
        if (tdd>P.thresh_label_dis) % edge is disc.
            if dp>dn
                Line_new(cc,11)= 9 ;  % object is on the negetive side of the line
            elseif(dp<dn)
                Line_new(cc,11)= 10 ;  % object is on the positive side of the line
            end
            
            % added on 2017/07/25 : check if the percentage of non-return
            % values in the mask is higher than a threshold, assume object
            % is on the opposite direction
            if ((length(dVal_Pos)/(nTot/2))<0.7) && ((length(dVal_Neg)/(nTot/2))<0.7) % if both have zeros
                [~, idxx1] = max([(length(dVal_Pos)/(nTot/2)) ; (length(dVal_Neg)/(nTot/2))]) ;
                switch idxx1
                    case 1
                        Line_new(cc,11)= 10 ;  %
                    case 2
                        Line_new(cc,11)= 9 ;
                end
            elseif (length(dVal_Pos)/(nTot/2))<0.7
                Line_new(cc,11)= 9 ;  % object is on the negetive side of the line bc pos side is shadows
            elseif(length(dVal_Neg)/(nTot/2))<0.7
                Line_new(cc,11)= 10 ;  % object is on the positive side of the line bc neg side is shadows
            end
        else % edge is not disc ==>> CD
            linde = ListPoint_new{cc} ;
            mask_line =Id(linde);
            mask_line(mask_line==0) = [] ;
            dl = sum(mask_line(:))/length(mask_line); % line average depth
            if dl<((dp+dn)/2)
                Line_new(cc,11)= 13 ; % convex
            else
                Line_new(cc,11)= 12 ; % concave
            end
        end
    end
end
end

