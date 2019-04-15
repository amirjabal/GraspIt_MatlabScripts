
function draw_pcl_Xaxis(Cloud_B2, LL1, LL2, fig_num, tit)


temp1  = LL1 ;
temp2 = LL2 ; 

% temp1=[P_center+0.25*Dir(:,1) P_center] ;
% temp2=[P_center+0.25*Dir(:,2) P_center] ;
% temp3=[P_center+0.25*Dir(:,3) P_center] ;

ind2 = find(Cloud_B2(:,1)>2); 
Cloud_B2(ind2,:) = nan ; 

figure(fig_num) ;hold on ;  title(tit) ;

plot3(Cloud_B2(:,1),Cloud_B2(:,2),Cloud_B2(:,3),'.k') ;



%plot3(temp1(1,2) , temp1(2,2) , temp1(3,2),'linewidth',10,'Marker','+','color','r') ;

plot3(temp1(1,:) , temp1(2,:) , temp1(3,:),'r','linewidth',8) ;
plot3(temp2(1,:) , temp2(2,:) , temp2(3,:),'g','linewidth',8) ;
%plot3(temp3(1,:) , temp3(2,:) , temp3(3,:),'b','linewidth',8) ;
grid on 
xlabel('X')
ylabel('Y')
zlabel('Z')

%plot3(LL(1,:),LL(2,:),LL(3,:),'g','linewidth',8) ;

hold off


end


