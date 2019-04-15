
% 7/17/2015 (notebook)
% check overlap between two lines
% according to types of triangle that 3 points of end points of the line
% make.

function f_val = check_overlap(L1,L2)

%LineFeature = [y1 x1 y2 x2 L m] ;

p1 = [L1(2) L1(1)] ;
p2 = [L1(4) L1(3)] ;
p3 = [L2(2) L2(1)] ;
p4 = [L2(4) L2(3)] ;

a = pdist2(p1,p2) ;
b = pdist2(p2,p3) ;
c = pdist2(p1,p3) ;
d = pdist2(p1,p4) ;
e = pdist2(p2,p4) ;
f = pdist2(p3,p4) ;
  
angle = @(x,y,z) acosd((y^2+z^2-x^2)/(2*y*z)) ;   % cosine law

a143 = angle(c,d,f) ; a134 = angle(d,c,f) ;
a243 = angle(b,e,f) ; a234 = angle(e,b,f) ; 
a312 = angle(b,a,c) ; a321 = angle(c,b,a) ;
a412 = angle(e,a,d) ; a421 = angle(d,a,e) ;

f_val = ( ((a143<90)&(a134<90)) | ((a243<90)&(a234<90)) |...
          ((a312<90)&(a321<90)) | ((a412<90)&(a421<90)) ) ;


end


