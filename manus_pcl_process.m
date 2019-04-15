
%% convert depth image to 3d point cloud


% pcl_o    : original pcl in camera's frame
% Ixyz     : filtered pcl in camera's frame (3 layer matrix)
% Ixyz2    : filtered pcl in camera's frame (1 layer matrix)
% Cloud_B  : filtered pcl in base's frame   (3 layer matrix)
% Cloud_B2 : filtered pcl in base's frame   (1 layer matrix)

[pcl_o,~] = depthToCloud_v2(Id_o,P.Cons_Cam, [1 1],P.center) ; % convert the original depth image to pcl (3 layer matrix)
[Ixyz,~]  = depthToCloud_v2(Id,P.Cons_Cam, [1 1],P.center) ; % convert cropped depth image to pcl (3 layer matrix)
pcl_o(:,:,2) = -pcl_o(:,:,2) ; pcl_o(:,:,3) = -pcl_o(:,:,3) ; 
Ixyz(:,:,2) = -Ixyz(:,:,2) ; Ixyz(:,:,3) = -Ixyz(:,:,3) ; % aligned with Manus axis

Cloud_Xk = Ixyz(:,:,1) ; Cloud_Yk = Ixyz(:,:,2) ; Cloud_Zk = Ixyz(:,:,3) ;

% convert to a one layer matrix
Ixyz2 = reshape(Cloud_Xk(:),1,size(Id,1)*size(Id,2));
Ixyz2(2,:) = reshape(Cloud_Yk(:),1,size(Id,1)*size(Id,2));
Ixyz2(3,:) = reshape(Cloud_Zk(:),1,size(Id,1)*size(Id,2));

% translate and rotate the point cloud to the base frame
Cloud_B2 = P.rot'*P.rot2*Ixyz2 ;
Cloud_B2 = [Cloud_B2(1,:)+P.baseloc(1) ; Cloud_B2(2,:)+P.baseloc(2) ; Cloud_B2(3,:)+P.baseloc(3) ]' ;

% convert the pcl to a 3-layer matrix
Cloud_B(:,:,1) = reshape(Cloud_B2(:,1),size(Id)) ;
Cloud_B(:,:,2) = reshape(Cloud_B2(:,2),size(Id)) ;
Cloud_B(:,:,3) = reshape(Cloud_B2(:,3),size(Id)) ;

Ixyz2 = Ixyz2';


clear Cloud_Xk Cloud_Yk Cloud_Zk



