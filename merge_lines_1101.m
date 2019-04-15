

function [Line_new,ListPoint_new,Line_merged_n] = merge_lines_1101(LineIn,ListPoint,thresh_m, imgsize)

%LineFeature(c0,:) = [1-y1 2-x1 3-y2 4-x2 5-L 6-m 7-alpha 8-c0 9-lind1 10-lind2]

% Description
% first, finds all the starting and ending points of lines (Lpt),
% then, find the connected lines to each point of the list
%
% different from previous version is in calculating dm and a new condition
% is added !




%% merge lines
ListPoint_new = ListPoint ;
Line_new = LineIn ;
[o1 , ~]=size(Line_new) ;
Line_merged_n = cell(o1,1) ;
for i=1:o1
    Line_merged_n{i} = i ;
end

temp1 = Line_new(:,9:10) ;
Lpt = unique(temp1) ;
Lpt = sort(Lpt) ; % list of the line start and end points
for ii=1:length(Lpt)
    ptx = Lpt(ii) ;
    [ar , ~] = find(Line_new(:,9:10) == ptx) ; % ***
    i1 = length(ar) ;
    
    if (i1>1)
        clear M
        ar = sort(ar) ;
        cnt30 = 1 ;
        for cnt10=1:length(ar)-1
            p1 = ar(cnt10);
            for cnt20 = cnt10+1:length(ar)
                p2 = ar(cnt20) ;
                M(cnt30,:) = [p1 p2] ;
                cnt30 = cnt30 +1 ;
            end
        end
        
        [sm,~] = size(M) ;
        cnt3=1 ;
        while (cnt3<sm+1)
            
            alph1 = Line_new(M(cnt3,1),7) ;
            alph2 = Line_new(M(cnt3,2),7) ;
            
            dm = abs(alph1-alph2) ; % angles different
            flag_neg = false;
            if dm>90
                flag_neg=true;
                dm = 180 -dm ;
                if alph1<0
                    alph1=alph1+180 ;
                else
                    alph2=alph2+180 ;
                end
                
                %dm
            end
            
            if dm<thresh_m % less than threshold
                B1 = [(Line_new(M(cnt3,1),9))  (Line_new(M(cnt3,1),10))] ;
                B2 = [(Line_new(M(cnt3,2),9))  (Line_new(M(cnt3,2),10))] ;
                if (length(intersect(B1,B2))<2) % two lines are not exactly same
                    poo = setdiff([B1 B2],ptx) ; % start and end point of the new line
                    
                    L1 = Line_new(M(cnt3,1),:) ; L2 = Line_new(M(cnt3,2),:) ;
                    ind1  = poo(1) ; ind2 = poo(2) ;
                    [y1,x1] = ind2sub(imgsize,ind1) ; [y2,x2] = ind2sub(imgsize,ind2) ;
                    m = (y2-y1)/(x2-x1)  ;
                    L = sqrt((x2-x1)^2+(y2-y1)^2);
                    alpha = atand(-m) ;
                    
                    if (alpha >= min(alph1,alph2))&&(max(alph1,alph2) >= alpha)||(flag_neg) % intesection point is in the middle of the new line
                        Line_new(max(M(cnt3,1),M(cnt3,2)),:)=[] ;
                        Line_new(min(M(cnt3,1),M(cnt3,2)),:)=[] ;
                        jj1 = Line_merged_n{M(cnt3,1)};
                        jj2 = Line_merged_n{M(cnt3,2)};
                        Line_merged_n(max(M(cnt3,1),M(cnt3,2))) = [] ;
                        Line_merged_n(min(M(cnt3,1),M(cnt3,2))) = [] ;
                        [c0,~] = size(Line_new) ;
                        
                        if (abs(y2-y1)>abs(x2-1))||(abs(y2-y1)==abs(x2-1))
                            dir = 1 ; % line is vertical
                        else
                            dir = 2 ;  % Line is horizontal
                        end
                        
                        
                        Line_new(c0+1,:) = [y1 x1 y2 x2 L m alpha 0 ind1 ind2 0 dir] ; % start point/end point/length/slope/angle/number/label
                        Line_merged_n{c0+1} = [jj1 jj2] ;
                        
                        % merge the ListPoints
                        Lpp1 = ListPoint_new{M(cnt3,1)} ;
                        Lpp2 = ListPoint_new{M(cnt3,2)} ;
                        f1 = find(Lpp1==ind1); f2 = find(Lpp1==ind2);
                        f3 = find(Lpp2==ind1); f4 = find(Lpp2==ind2);
                        
                        if isempty(f1)
                            L_start = Lpp2 ;
                            L_end   = Lpp1 ;
                            if f3>1
                                L_start = flipud(L_start) ;
                            end
                            if f2==1
                                L_end = flipud(L_end) ;
                            end
                            
                        else
                            L_start = Lpp1 ;
                            L_end   = Lpp2 ;
                            if f1>1
                                L_start = flipud(L_start) ;
                            end
                            if f4==1 ;
                                L_end = flipud(L_end) ;
                            end
                            
                            
                        end
                        ListPoint_new(max(M(cnt3,1),M(cnt3,2))) = [] ;
                        ListPoint_new(min(M(cnt3,1),M(cnt3,2))) = [] ;
                        ListPoint_new{c0+1} = [L_start(1:end-1) ; L_end] ;
                        
                        
                        
                        cnt3 = sm+1 ; % in a case, the condition is true, it doesn't check for other pairs
                    else
                        cnt3 = cnt3+1 ;
                    end
                else
                    cnt3 = cnt3+1 ; % count for the next pair
                    
                    
                end
            else
                cnt3 = cnt3+1 ;
            end
            
        end
        
    end
end

[mx,~] = size(Line_new) ; Line_new(:,8) = 1:mx ;


end


