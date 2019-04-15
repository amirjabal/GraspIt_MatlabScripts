
function draw_shifted_pointes(ListPoint_new,ListPoint_new_shifted,ff,fig_num,back_img,tit,Id)


%draw the original points and modified points (after shifting)

for cnt=1:length(ff) ;

    
    lp_old = ListPoint_new{ff(cnt)} ; % all of the points on this line
    lp_new = ListPoint_new_shifted{ff(cnt)} ; % all of the points on this line
    [Io,Jo] = ind2sub(size(Id),lp_old) ; 
    [In,Jn] = ind2sub(size(Id),lp_new) ; 
       
   
    figure(fig_num+cnt) ; imshow(back_img) ; title (tit) ; hold on
    plot(Jo,Io,'.','color','g') ; hold on
    plot(Jn,In,'o','color','r') ; hold off

end
end