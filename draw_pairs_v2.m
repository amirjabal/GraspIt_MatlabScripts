
function draw_pairs_v2(ListPair,Line_new,backim,fig_num)

if (size(ListPair,1)==1)&&(ListPair(1)==0)
    display ('no pairs detected')
else
    % draw the paired lines
    figure(fig_num)
    cc = hsv(size(ListPair,1)) ; % set color
    imshow(backim) ; title (sprintf('%d pairs',size(ListPair,1))) ; hold on
    
    
    for cntd=1:size(ListPair,1)
        pl = ListPair(cntd,:); % paired line
        for ii=1:2
            y1 = Line_new(pl(ii),1) ;
            x1 = Line_new(pl(ii),2) ;
            y2 = Line_new(pl(ii),3) ;
            x2 = Line_new(pl(ii),4) ;
            plot([x1 x2] , [y1 y2],'LineWidth',3, 'Color', cc(cntd,:) ); hold on ;
            str1 = sprintf('*%d',cntd);
            text(fix((x1+x2)/2)+fix(20*rand),fix((y1+y2)/2+5),str1,'Color',cc(cntd,:),'LineWidth',2)
        end
    end
end
hold off
end

