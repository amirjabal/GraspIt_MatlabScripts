function d = distance2d(L_one,L_two)

% written on 7/14/2015
% it calculates the distance between a point (midle pointo of smaller line)...
% from a line (larger line)

%LineFeature = [y1 x1 y2 x2 L m] ;
if L_one(5)<L_two(5)
    L1 = L_one ;
    L2 = L_two ;   
else
    L1 = L_two ;
    L2 = L_one ;
end

x0 = (L1(2)+L1(4))/2 ; y0 = (L1(1)+L1(3))/2 ;

x1 = L2(2) ; y1 = L2(1) ;
x2 = L2(4) ; y2 = L2(3) ;

d = abs((x2-x1)*(y1-y0)-(x1-x0)*(y2-y1))/sqrt((x2-x1)^2+(y2-y1)^2) ;