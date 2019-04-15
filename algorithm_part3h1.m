
%%
% extract the coordinates of the target points from the point cloud
original_points = Cloud_B2(TargetPoints_noshift,:) ;
set_points = Cloud_B2(TargetPoints,:) ;
ind1 = find(isnan(set_points(:,1))); set_points(ind1,:)=[];

%% fit Ransac plane [purposes: 1)throwing away outliers. 2)using the normal vector as the approach direction.]

r_set = [fix(0.6*size(set_points,1))  50  0.018  fix(0.8*size(set_points,1))] ; % set of parameters (nno k t d )
nno = r_set(1) ; %smallest number of points required
k = r_set(2);    %number of iterations
t = r_set(3) ;   %threshold used to id a point that fits well
d = r_set(4);    %number of nearby points required % default : 0.8*size(....)
f_success = false ;

for cntr = 1:3
    [f_success,p_best,n_best,ro_best,~,~,~,error_plane,~]=local_ransac_tim_v2(set_points,nno,k,t,d);
    if f_success
        break
    elseif cntr == 3
        display('There is not a proper plane - select a new pair')
    else
        display('Fitting the plane was not successful, will retry!')
    end
end

if ~f_success
    d = fix(0.75*size(set_points,1)) ;
    [f_success,p_best,n_best,ro_best,~,~,~,error_plane,~]=local_ransac_tim_v2(set_points,nno,k,t,d);
    if f_success
        display('After reducing the ransac threshold parameter (0.8 to 0.7), a plane is fitted')
    else
        display('There is not a proper plane even after reducing threshold')
        error_plane = 100 ; 
    end
end

error_ransac = error_plane/size(set_points,1)*100 ; 
clear cntr