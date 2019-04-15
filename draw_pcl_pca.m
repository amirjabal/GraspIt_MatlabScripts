

% description: this function draws point cloud and mark the points which
% cause the failure in the ransac plane fitting

function draw_pcl_pca(Cloud_B2, target_pts, original_points,P_center, fig_num, tit,P)

coeff = pca(target_pts);
if coeff(3,3)>0
    coeff = -coeff ; 
end


temp1=[P_center+0.25*coeff(:,1) P_center] ;
temp2=[P_center+0.25*coeff(:,2) P_center] ;
temp3=[P_center+0.25*coeff(:,3) P_center] ;

figure(fig_num) ; title(tit) ;
hold on
plot3(Cloud_B2(:,1),Cloud_B2(:,2),Cloud_B2(:,3),'.k') ;
plot3(original_points(:,1), original_points(:,2), original_points(:,3),'or') ;
plot3(target_pts(:,1), target_pts(:,2), target_pts(:,3),'og') ;

plot3(P.baseloc(1),P.baseloc(2),P.baseloc(3),'linewidth',25,'Marker','+','color','g') ; % kinect position
plot3(0 ,0 ,0,'linewidth',25,'Marker','+','color','r') ;  % base position

plot3(temp1(1,:) , temp1(2,:) , temp1(3,:),'r','linewidth',8) ;
plot3(temp2(1,:) , temp2(2,:) , temp2(3,:),'g','linewidth',8) ;
plot3(temp3(1,:) , temp3(2,:) , temp3(3,:),'b','linewidth',8) ;
grid on 
xlabel('X') ; ylabel('Y') ; zlabel('Z')

hold off


end


