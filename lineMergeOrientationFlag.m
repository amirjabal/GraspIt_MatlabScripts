

function flag_out = lineMergeOrientationFlag(Line1, Line2, Gdir, win_width, delta_gdir)


% 2017 10 25 : this function extract Gdir values from a mask on object side
% for **DD edges** 
% if the average values of masks is less than delta_gdir, then triggers the
% output flag

% a possible bug: we consider 0 values in Gdir as non-returned values and
% filter it, while that's not always correct!

    %win_width = 9 ;
    %delta_gdir = 20 ;
    
    [~, winp1, winn1] = make_RecMask(Line1,win_width) ;
    [~, winp2, winn2] = make_RecMask(Line2,win_width) ;
    if Line1(11)== 9   % object is on the negetive side of the line
        maskOneSide1= roipoly(Gdir, winn1(2,:), winn1(1,:)) ;
        maskOneSide2= roipoly(Gdir, winn2(2,:), winn2(1,:)) ;
    elseif Line1(11)==10   % object is on the positive side of the line
        maskOneSide1= roipoly(Gdir, winp1(2,:), winp1(1,:)) ;
        maskOneSide2= roipoly(Gdir, winp2(2,:), winp2(1,:)) ;
    end
    I_marked1 = maskOneSide1.*Gdir ;
    I_marked2 = maskOneSide2.*Gdir ;
    vec1 = I_marked1(:) ;
    vec1(vec1==0)=[];
    gwin1= mean(vec1);
    vec2 = I_marked2(:) ;
    vec2(vec2==0)=[];
    gwin2 = mean(vec2);
    if abs(gwin1-gwin2)< delta_gdir
        flag_out = true ;
    else
        flag_out = false ;
    end
    % draw_LogicalOnImage(maskOneSide,L22,'mask',cnt1+cnt2) %
    % use for visualization of masks
end
