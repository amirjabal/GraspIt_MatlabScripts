figure ;
[xx,~] = size(ListPair) ;  % number of paired lines
cc = hsv(xx) ; % set color
imshow(Ic) ; title (sprintf('%d pairs',xx)) ; hold on
tt0 = zeros(length(Line_new),1) ;
t2 = size(ListPair) ; % length list pair
for cntd=1:t2(1)
    
    pl = ListPair(cntd,:); % paired line
    figure(43); imshow(Ic) ; hold on 
    for ii=1:2
        y1 = Line_new(pl(ii),1) ;
        x1 = Line_new(pl(ii),2) ;
        y2 = Line_new(pl(ii),3) ;
        x2 = Line_new(pl(ii),4) ;
        plot([x1 x2] , [y1 y2],'LineWidth',3, 'Color', cc(cntd,:) ); hold on ;
        str1 = sprintf('*%d',cntd);
        text(fix((x1+x2)/2)+2*tt0(Line_new(pl(ii),11)),fix((y1+y2)/2+5),str1,'Color',cc(cntd,:),'LineWidth',2)
        tt0(Line_new(pl(ii),11)) =  tt0(Line_new(pl(ii),11))+1 ;
    end
    hold off
    
    F(cntd) = getframe(gcf) ; 
    
    
    %saveas(figure(50),sprintf('pair%d-%d.jpg',pic_num,cntd))
    %close (figure(50))
end


hold off
clear xx cntd cc ii y1 x1 y2 x2 str1 pl tt0 t2

figure ; movie (gcf,F,1,0.3)

