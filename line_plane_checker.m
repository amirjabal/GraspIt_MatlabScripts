
function [dd] = line_plane_checker(L1,L2)

v1 = L1(:,1)-L1(:,2) ;
v2 = L1(:,1)-L2(:,1) ;

n1 = cross(v1,v2);

d1 = -dot(n1,L1(:,1)) ; 

p = L2(:,2);

dd = (dot(p,n1)+d1)/norm(n1) ;
end
