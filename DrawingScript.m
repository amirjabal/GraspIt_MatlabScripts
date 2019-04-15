
% DRAW THE DESIRED FIGURES AND SAVE WORKSPACE

%% sec 1
figure(5) ; imshow(L00) ; title('Original depth')
figure(6) ; imshow(L11) ; title('Processed depth')
figure(7) ; imshow(L22) ; title('Gradient Direction')

draw_LogicalOnImage(BW20,Ic,'depth disc - BW20',11)
draw_LogicalOnImage(BW30,Ic,'curve disc - BW30',12)
draw_2LogicalOnImage(BW20,BW30,Ic,'depth/curve disc.',13)

%% sec 2
draw_LogicalOnImage(DE10,Ic,'morpho of curve disc - DE10',21)
draw_LogicalOnImage(BWn,Ic,'processed curve disc - BWn',22)
draw_LogicalOnImage(DE_o,Ic,'after OR - DE_o',23)
draw_LogicalOnImage(DE3,Ic,'after OR and morpho - DE3',24)

%% sec 3
DrawLineFeature(LineFeature,Ic,'Non-modified lines',31) 
DrawLineFeature(Line_new,Ic,'Modified lines',32)
draw_disc_curv(Line_new,Ic,'Labeled line',33)


%% sec 4
draw_pairs_v2(ListPair,Line_new,Ic,40) % paired lines
draw_pair_seperate     % not movie
%draw_pair_seperate_0617 % + a movie

DrawSelectedPoints(TargetPoints, TargetPoints_noshift,75,Ic,'Selected Points')

[length(set_points) length(p_best)]


%% to remember
%figure ; surf(Idss) ; set (gca,'Ydir','reverse') ;set (gca,'Zdir','reverse')
%saveas(figure(5),sprintf('data%d-3.jpg',pic_num))

B500 = labeloverlay(Ic,BW20);
figure;imshow(B500)
