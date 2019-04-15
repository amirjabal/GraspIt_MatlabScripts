
function draw_Spairs(ListPair,selected,Line_new,backim,fig_num)

% draw selected pairs

% draw the paired lines
figure(fig_num)
cc = hsv(size(selected,1)) ; % set color
imshow(backim) ; title (sprintf('%d pairs',size(selected,1))) ; hold on


for cntd=1:size(selected,1)
    
    pl = ListPair(selected(cntd),:); % paired line
    
    for ii=1:2
        y1 = Line_new(pl(ii),1) ;
        x1 = Line_new(pl(ii),2) ;
        y2 = Line_new(pl(ii),3) ;
        x2 = Line_new(pl(ii),4) ;
        plot([x1 x2] , [y1 y2],'LineWidth',3, 'Color', cc(cntd,:) ); hold on ;
        str1 = sprintf('*%d',selected(cntd));
        %text(fix((x1+x2)/2),fix((y1+y2)/2),str1,'Color',cc(cntd,:),'LineWidth',2)    
        text(fix((x1+x2)/2),fix((y1+y2)/2),str1,'Color',cc(cntd,:),'LineWidth',2)  
    end
end
hold off
