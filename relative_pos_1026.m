function flag_out = relative_pos_1026(Line_i,Line_j)

% description 12/1/2015
% % description of the new code is in my notebook

if Line_i(11)~=13
    L_ref  = Line_i ;
    L2 = Line_j ;
else
    L_ref  = Line_j ;
    L2 = Line_i ;
end

m = L_ref(6) ;
a = L_ref(7) ; 
dir_obj = (L_ref(11)== 9) ;

if (a==90)||(a==-90)
    dir_dec = (L_ref(2)-L2(2)>0 ) ; 
else
    hr = L_ref(1)-m*L_ref(2) ;
    hL = L2(1)-m*L2(2) ;
    dir_dec = (hr-hL)>0 ;
    if m>1
    dir_dec =~dir_dec ;
    end
end

% if the second line was discountinuity too, another condition is needed to
% check, otherwise if the direction of object and second lines are equal,
% flag is true.
if (L2(11)~=13)&&(dir_obj==dir_dec) 
    flag_out = (L2(11)~=L_ref(11)) ; 
else %
    flag_out = (dir_obj==dir_dec) ;
end
end



    
    
    