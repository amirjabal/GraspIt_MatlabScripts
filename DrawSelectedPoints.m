


function DrawSelectedPoints(TargetPoints, TargetPoints_noshift, fig_num,back_img,tit)


[In,Jn] = ind2sub(size(back_img),TargetPoints) ;
[Io,Jo] = ind2sub(size(back_img),TargetPoints_noshift) ;

figure(fig_num) ; imshow(back_img) ; title (tit) ; hold on
plot(Jn,In,'o','color','g') ;
plot(Jo,Io,'.','color','r') ;
hold off

end
