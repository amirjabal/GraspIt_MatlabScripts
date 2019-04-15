function [ind ] = NextMove_v2(loc, xe, ye, Line_new) 


% it is different from the previous version in:
% it considers more than two lines


for i=1:length(loc)
    ym(i) = 0.5*(Line_new(loc(i),1)+Line_new(loc(i),3)) ;
    xm(i) = 0.5*(Line_new(loc(i),2)+Line_new(loc(i),4)) ;
    d(i) = norm([xe-xm(i),ye-ym(i)]) ;
end

[~,ind] = min(d) ;

end




