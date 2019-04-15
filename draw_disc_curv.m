
function draw_disc_curv(Line_new,back_img,tit,fig_num)


figure(fig_num)
imshow(back_img) ; title (tit) ; hold on

for ii=1:length(Line_new)
    if (Line_new(ii,11)~=0)
        if (Line_new(ii,11)==9)
            cc = 'r' ;
        elseif(Line_new(ii,11)==10)
            cc = 'b' ;
        elseif(Line_new(ii,11)==13)
            cc = 'g' ;
        elseif(Line_new(ii,11)==12)
            cc = 'k' ;
        end
        y1 = Line_new(ii,1) ;
        x1 = Line_new(ii,2) ;
        y2 = Line_new(ii,3) ;
        x2 = Line_new(ii,4) ;
        plot([x1 x2] , [y1 y2],'LineWidth',3, 'Color', cc ); hold on ;
    end
end
hold off

end