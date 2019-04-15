
function out2 = remove_boundries(In, Zone, BoundM)


% remove the boundries of zone from the edge detection output

% out1 = true(size(In)) ; 
% out1(Zone(1):Zone(2) , Zone(3)) = false ;
% out1(Zone(1):Zone(2) , Zone(4)) = false ;
% out1(Zone(1) , Zone(3):Zone(4)) = false ;
% out1(Zone(2) , Zone(3):Zone(4)) = false ;

i = BoundM; 

out1 = true(size(In)) ; 
out1(Zone(1):Zone(2) , Zone(3)-i:Zone(3)+i) = false ;
out1(Zone(1):Zone(2) , Zone(4)-i:Zone(4)+i) = false ;
out1(Zone(1)-i:Zone(1)+i , Zone(3):Zone(4)) = false ;
out1(Zone(2)-i:Zone(2)+i , Zone(3):Zone(4)) = false ;



%out1 = bwmorph(out1,'thick',10);

out2 = and(In,out1); 


end