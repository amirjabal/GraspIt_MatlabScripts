
function DrawLineFeature(LineFeature,back_img,tit,fig_num)

%LineFeature(n,:) = [y1 x1 y2 x2 L m alpha number] ; 
[xx,~] = size(LineFeature) ;
cc = hsv(xx) ; 
cc = cc(randperm(xx),:);
figure(fig_num) ; imshow(back_img) ; hold on ;title (tit) ;

for c0=1:xx
    x1 = LineFeature(c0,2) ; x2 = LineFeature(c0,4) ; 
    y1 = LineFeature(c0,1) ; y2 = LineFeature(c0,3) ; 

plot([x1 x2] , [y1 y2],'LineWidth',3, 'Color', cc(c0,:)) ; hold on
end
hold off
end
