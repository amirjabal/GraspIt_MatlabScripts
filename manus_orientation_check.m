
%% flipping the direction of the ransac plane if it's necessary 
% and determining if the grasp is top/side grasping.

vec_x = [1 ; 0 ; 0] ; %camera's x axis (points forward)
vec_x_b = P.rot'*P.rot2*vec_x ; %

% n_best ;  normal vector of the fitted ransac plane
theta10 = acosd(dot(n_best,vec_x_b)/(norm(n_best)*norm(vec_x_b))) ; 


if theta10>90
    Dir_ZZ = -n_best;
else
    Dir_ZZ = n_best ; 
end

vec_z_b = [0 ; 0 ; 1] ; % base z axis (points up)
theta20 = acosd(dot(n_best,vec_z_b)/(norm(n_best)*norm(vec_z_b))) ; 

if (theta20>45) && (theta20<135)
    flag_orientation = 'side' ;
else
    flag_orientation = 'top' ;
end


vec_x_b = [1 ; 0 ; 0] ; % base x axis (points forward)
theta30 = acosd(dot(n_best,vec_x_b)/(norm(n_best)*norm(vec_x_b))) ; 



