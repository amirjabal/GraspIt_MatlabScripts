function ListPair = line_match_1026(LineInteresting,P)


% 05/25/2016 modified version of v2

[N, ~] = size(LineInteresting) ;
m_mat = zeros (N,N) ;
d_mat = zeros(N,N) ;
ListPair = [0 0] ;
i = 1;
cnt = 1;
while i <= N
    if LineInteresting(i,5)> P.Cons_Lmin % if lenghth of line is larger than min
        j=i+1;
        while j <= N
            if LineInteresting(j,5)> P.Cons_Lmin % if lenghth of line is larger than min
                % if satifies the slope constraint
                if (abs(LineInteresting(i,7)-LineInteresting(j,7)) <= P.Cons_AlphaD)||(abs(LineInteresting(i,7)-LineInteresting(j,7))>= (180-P.Cons_AlphaD))
                    m_mat(i,j) = 1;
                    d = distance2d(LineInteresting(i,:),LineInteresting(j,:)) ;
                    d_mat(i,j) = d ;
                    if d < P.Cons_Dmax && d> P.Cons_Dmin % if satisfies the maximum distance
                        flag_overlap = check_overlap (LineInteresting(i,:),LineInteresting(j,:)) ; %satisfies the overlap
                        if (flag_overlap)
                            flag_relative = relative_pos_1026(LineInteresting(i,:),LineInteresting(j,:)) ; % relative pose
                            if flag_relative
                                ListPair (cnt,:) = [LineInteresting(i,8),LineInteresting(j,8)] ;
                                cnt = cnt+1 ;
                            end
                        end
                    end
                else
                    %break  % because lines are sorted according to m
                end
                j = j+1 ;
            end
        end
    end
    i=i+1;
end
