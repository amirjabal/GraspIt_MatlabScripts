
function draw_pcl(Cloud_B2, P_center, p_best, n_best, ro_best, Dir, fig_num, tit,P)

minx = min(p_best(:,1)) ; maxx = max(p_best(:,1));
miny = min(p_best(:,2)) ; maxy = max(p_best(:,2));
vecx = (minx:0.002:maxx) ; vecy = (miny:0.002:maxy) ;
[meshx,meshy] = meshgrid(vecx,vecy);

Zest = -(n_best(1)*meshx +n_best(2)*meshy - ro_best)/n_best(3) ;

temp1=[P_center+0.25*Dir(:,1) P_center] ;
temp2=[P_center+0.25*Dir(:,2) P_center] ;
temp3=[P_center+0.25*Dir(:,3) P_center] ;

ind2 = find(Cloud_B2(:,1)>2); 
Cloud_B2(ind2,:) = nan ; 

figure(fig_num) ;hold on ;  title(tit) ;

plot3(Cloud_B2(:,1),Cloud_B2(:,2),Cloud_B2(:,3),'.k') ;
hold on ; 
plot3(meshx(:), meshy(:), Zest(:),'ob','markersize',6) ;

plot3(p_best(:,1), p_best(:,2), p_best(:,3),'or') ;

plot3(temp1(1,2) , temp1(2,2) , temp1(3,2),'linewidth',10,'Marker','+','color','r') ;
plot3(P.baseloc(1),P.baseloc(2),P.baseloc(3),'linewidth',25,'Marker','+','color','g') ; % kinect position
plot3(0 ,0 ,0,'linewidth',25,'Marker','+','color','r') ;  % base position


plot3(temp1(1,:) , temp1(2,:) , temp1(3,:),'r','linewidth',8) ;
plot3(temp2(1,:) , temp2(2,:) , temp2(3,:),'g','linewidth',8) ;
plot3(temp3(1,:) , temp3(2,:) , temp3(3,:),'b','linewidth',8) ;
grid on 
xlabel('X')
ylabel('Y')
zlabel('Z')

%plot3(LL(1,:),LL(2,:),LL(3,:),'g','linewidth',8) ;

hold off


end


