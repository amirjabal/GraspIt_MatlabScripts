


function draw_2LogicalOnImage(In1,In2,back_img,tit,fig_num)


figure(fig_num)
imshow(back_img) ;
title (tit) ; 
hold on
[row1,col1]=find(In1==1) ;  
plot(col1,row1,'.','color','r') ;
hold on
[row2,col2]=find(In2==1) ;  
plot(col2,row2,'.','color','b') ;
hold off

end