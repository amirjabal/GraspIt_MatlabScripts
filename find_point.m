function out1 = find_point(u1,u2,edgelist)

location = [0 0] ;

for cnt=1:length(edgelist)
    


r1 = find([edgelist{cnt}(:,1)]==u1) ;
r2 = find([edgelist{cnt}(:,2)]==u2) ;
a = intersect (r1,r2) ; 
if ~isempty(a)    
location = [location  ; cnt , a] ;  % cnt is number of the cell, a is number of the row
end

out1  = location ; 

end
