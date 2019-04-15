


%% post process on each of the segments for the matter of sub segmentation based on clustering

labels = unique(seg_image); labels(labels==0)=[];

for cnt=1:length(labels)
    roi = find(seg_image==labels(cnt));
    roi_d = Id_o(roi);
    roi_gdir = Gdir(roi);
    
    idx_nan = find(roi_d==0);
    roi_d(idx_nan)=[];
    roi_gdir(idx_nan)=[];
    
    seg_depth_mat(cnt,:) = [mean(roi_d), median(roi_d), min(roi_d), max(roi_d)] ;
    seg_gdir_mat(cnt,:)  = [mean(roi_gdir), median(roi_gdir), min(roi_gdir), max(roi_gdir)] ;
    
    
    figure; histogram(roi_d) ; title(sprintf('depth %d',cnt));
    figure; histogram(roi_gdir); title(sprintf('gradient %d',cnt));
    mask = zeros(size(seg_image));
    mask(roi)=1;
    figure ; imshow(mask);  title(sprintf('mask %d',cnt));
    %figure;plot(roi_d,roi_gdir,'*') ; title(sprintf('representation %d',cnt));
end


seg_image_colored = label2rgb(seg_image) ;
figure;imshow(seg_image_colored)
c1 = seg_image_colored(:,:,1);
c2 = seg_image_colored(:,:,2);
c3 = seg_image_colored(:,:,3);

figure; hold on ; title('2d rep'); xlabel('depth values') ; ylabel('gradient values'); zlabel('row');grid on;
color_rand = hsv(length(labels)) ;
for cnt=1:length(labels)
    roi = find(seg_image==labels(cnt));
    roi_d = Id_o(roi);
    roi_gdir = Gdir(roi);
    [roi_row,roi_col] = ind2sub(size(seg_image),roi);
    
    idx_nan = find(roi_d==0);
    roi_d(idx_nan)=[];
    roi_gdir(idx_nan)=[];
    
    roi_row(idx_nan)=[];
    roi_col(idx_nan)=[];
    
    %plot(roi_d,roi_gdir,'*','Color',color_rand(cnt,:)) ;
    plot3(roi_d,roi_gdir,roi_col,'*','Color',[c1(roi(1)),c2(roi(1)),c3(roi(1))]) ;
end
hold off



%% individual process 

roi = find( seg_image == 2);
roi_d = Id_o(roi);
roi_gdir = Gdir(roi);

idx_nan = find(roi_d==0);
roi_modif = roi;

roi_modif(idx_nan) = []; 
roi_d(idx_nan)=[];
roi_gdir(idx_nan)=[];

figure; plot(roi_d,roi_gdir,'*') ;


%% 

X = [roi_d , roi_gdir] ;

% [idx1,C1] = kmeans(X,1);
% [silh1,h1] = silhouette(X,idx1,'cityblock');
% cluster1= mean(silh1)

[idx2,C2] = kmeans(X,2);
figure
[silh2,h2] = silhouette(X,idx2,'cityblock');
h2 = gca;
h2.Children.EdgeColor = [.8 0.8 1];
xlabel 'Silhouette Value'
ylabel 'Cluster'
cluster2= mean(silh2)

[idx3,C3] = kmeans(X,3);
figure
[silh3,h3] = silhouette(X,idx3,'cityblock');
h3 = gca;
h3.Children.EdgeColor = [.8 0.8 1];
xlabel 'Silhouette Value'
ylabel 'Cluster'
cluster3= mean(silh3)


figure;
plot(X(idx2==1,1),X(idx2==1,2),'r.','MarkerSize',12)
hold on
plot(X(idx2==2,1),X(idx2==2,2),'b.','MarkerSize',12)

plot(C2(:,1),C2(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3) 
title 'Cluster Assignments and Centroids'
hold off


figure;imagesc(seg_image);
roi_clus_1 = roi_modif(find(idx2==1));
roi_clus_2 = roi_modif(find(idx2==2));
clustered_image = zeros(size(seg_image)) ; 
clustered_image (roi_clus_1) = 1;
clustered_image (roi_clus_2) = 2 ;
figure;imshow(label2rgb(clustered_image))

figure;
plot(X(idx==1,1),X(idx==1,2),'r.','MarkerSize',12)
hold on
plot(X(idx==2,1),X(idx==2,2),'b.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3) 
legend('Cluster 1','Cluster 2','Centroids',...
       'Location','NW')
title 'Cluster Assignments and Centroids'
hold off


