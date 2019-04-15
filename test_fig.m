

close all
BW90 = or(BW20,BW30);
BW91  = morpho_modify_0712(BW90) ;
[B,L,N,A] = bwboundaries(BW91);

w10=label2rgb(L);
figure;imshow(w10)
colors=['b' 'g' 'r' 'c' 'm' 'y'];
for k=1:length(B),
    
    figure;
    imshow(BW91); hold on;
  boundary = B{k};
  cidx = mod(k,length(colors))+1;
  plot(boundary(:,2), boundary(:,1),...
       colors(cidx),'LineWidth',2);

  %randomize text position for better visibility
  rndRow = ceil(length(boundary)/(mod(rand*k,7)+1));
  col = boundary(rndRow,2); row = boundary(rndRow,1);
  h = text(col+1, row-1, num2str(L(row,col)));
  set(h,'Color',colors(cidx),'FontSize',14,'FontWeight','bold');
end