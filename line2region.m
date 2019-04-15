
function mask = line2region (I,L1,L2)

% description: this function takes two lines and outputs the region between them 

p1 = [L1(1) ; L1(2)] ;
p2 = [L1(3) ; L1(4)] ;
p3 = [L2(1) ; L2(2)] ;
p4 = [L2(3) ; L2(4)] ;

% find out the order of points for making the mask
if (norm(((p1+p3)/2)-((p2+p4)/2)) > norm(((p1+p4)/2)-((p2+p3)/2)))
    win = [p1 p2 p4 p3] ;
else
    win = [p1 p2  p3 p4] ;
    
end

mask = roipoly(I, win(2,:), win(1,:)) ;
end
