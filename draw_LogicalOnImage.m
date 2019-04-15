

function draw_LogicalOnImage(In,back_img,tit,fig_num)


figure(fig_num)
imshow(back_img) ;
title (tit) ; 
hold on
[row1,col1]=find(In==1) ;  
plot(col1,row1,'.','color','r') ;
hold off

end