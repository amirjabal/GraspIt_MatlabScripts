function pair_no = point2pair(ListPair,Line_new,xypos,P)
% xypos = [347 256];
% xypos = [318 326];
Pairlines = [];
pair_candidate = [];
for i  = 1:length(ListPair(:,1))
    % [1-2.start_Y,X  3-4.end_Y-X  5.Length  6.slope  7.angle  8. number  
    % 9-10.linear index 11. pos/neg/curvature  12.1_vertical 2_horizental]
    Pairlines(2*i-1,1:12) = Line_new(ListPair(i,1),:);
    Pairlines(2*i,1:12) = Line_new(ListPair(i,2),:);
    
    l1s = [Pairlines(2*i-1,2) Pairlines(2*i-1,1)];
    l1e = [Pairlines(2*i-1,4) Pairlines(2*i-1,3)];
    l2s = [Pairlines(2*i,2) Pairlines(2*i,1)];
    l2e = [Pairlines(2*i,4) Pairlines(2*i,3)];

    d1 = abs(det([l1e-l1s;xypos-l1s]))/norm(l1e-l1s);%distance from the selected point to edge1
    d2 = abs(det([l2e-l2s;xypos-l2s]))/norm(l2e-l2s);
    Pairlines(2*i-1,13) = d1;
    Pairlines(2*i,13) = d2;
    l1 = Pairlines(2*i-1,5);
    l2 = Pairlines(2*i,5);
    if (d1+d2)<P.Cons_Dmax
        pair_candidate = [pair_candidate;[i d1*l1+d2*l2]];
    end
    
end
pair_candidate = sortrows(pair_candidate,2);
% pair_candidate
pair_no = pair_candidate(end,1)
reccandidate = [];
reccandidate(1,:) = Line_new(ListPair(pair_no,1),1:4);
reccandidate(2,:) = Line_new(ListPair(pair_no,2),1:4);
recX = min([reccandidate(:,2);reccandidate(:,4)]);
recY = min([reccandidate(:,1);reccandidate(:,3)]);
recL = max([reccandidate(:,2);reccandidate(:,4)])-recX;
recW = max([reccandidate(:,1);reccandidate(:,3)])-recY;

fid3=fopen('C:\\MANUS\\CommonSpace\\new_vision\\rec.txt','w');
fprintf(fid3, '%f  \n', [recX recY recL recW]);
fclose(fid3);


% pair_no = 1;
end
        
        
    