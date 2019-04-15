
% description: this function draws point cloud and marks 2 set of points

function drawPclMarkedPts(Cloud_B2, target_pts, original_points, fig_num, tit,P)


figure(fig_num) ;
hold on
title(tit) ;
plot3(Cloud_B2(:,1),Cloud_B2(:,2),Cloud_B2(:,3),'.k') ;
plot3(original_points(:,1), original_points(:,2), original_points(:,3),'or') ;
plot3(target_pts(:,1), target_pts(:,2), target_pts(:,3),'og') ;
plot3(P.baseloc(1),P.baseloc(2),P.baseloc(3),'linewidth',25,'Marker','+','color','g') ; % kinect position
plot3(0 ,0 ,0,'linewidth',25,'Marker','+','color','r') ;  % base position
grid on 
xlabel('X') ; ylabel('Y') ; zlabel('Z')
hold off


end


