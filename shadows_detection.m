

% input depth image
% output :
% if region is so small: remove edges
% if region is normal: detected foregrounds
% if region is large: all the boundaries

function BW_forg = shadows_detection(Id)

im1 = zeros(size(Id)) ;
im1(Id==0)=1 ;
mask_sh_ed =  bwmorph(im1,'thicken',1);
Bsh = bwboundaries(mask_sh_ed );
BW_forg = false(size(Id)) ;


for cntr=1:size(Bsh,1)
    if size(Bsh{cntr},1)>500 % large regions
        l_set = sub2ind(size(im1), Bsh{cntr}(:,1), Bsh{cntr}(:,2));
        BW_forg(l_set) = true ;
    elseif size(Bsh{cntr},1)>15 && size(Bsh{cntr},1)<500 % normal regions
        rows = Bsh{cntr}(:,1) ;
        [~,locs1,~,p1] = findpeaks(rows);
        [~,locs2,~,p2] = findpeaks(-rows);
        flag1= p1>0.3*(max(rows)-min(rows)); locs1 = flag1.*locs1 ; locs1(locs1==0)=[]; % check if distance between max and min is larger than 30 percent of data range
        flag2= p2>0.3*(max(rows)-min(rows)); locs2 = flag2.*locs2 ; locs2(locs2==0)=[]; %
        % case 1: shadow has 4 sides (turned around the objects)
        if (sum(flag1)>1 || sum(flag2)>1) && (sum(flag1)>0) && (sum(flag2)>0)
            if sum(flag1)==1
                [~, locs1(2)] = max(rows) ;
            elseif sum(flag2)==1
                [~, locs2(2)] = min(rows) ;
            end
            locs = sort([locs1(:);locs2(:)]) ;
            set10 = Bsh{cntr}(locs(1):locs(2)-1,:) ;
            set20 = Bsh{cntr}(locs(2):locs(3)-1,:) ;
            set30 = Bsh{cntr}(locs(3):locs(4)-1,:) ;
            set40 =[Bsh{cntr}(locs(4):end,:) ; Bsh{cntr}(1:locs(1),:)];
            
            lset10 = sub2ind(size(im1), set10(:,1), set10(:,2));
            lset20 = sub2ind(size(im1), set20(:,1), set20(:,2));
            lset30 = sub2ind(size(im1), set30(:,1), set30(:,2));
            lset40 = sub2ind(size(im1), set40(:,1), set40(:,2));
            
            lset10_d = Id(lset10) ; lset10_d(lset10_d==0) = [];
            lset20_d = Id(lset20) ; lset20_d(lset20_d==0) = [];
            lset30_d = Id(lset30) ; lset30_d(lset30_d==0) = [];
            lset40_d = Id(lset40) ; lset40_d(lset40_d==0) = [];
            depth_set = [mean(lset10_d) mean(lset20_d) mean(lset30_d) mean(lset40_d)] ;
            [~, idxx1] = min(depth_set) ; depth_set(idxx1) = inf;
            [~, idxx2] = min(depth_set) ;          
            switch idxx1
                case 1
                    f_Set = set10 ;  % foreground set
                    l_set = lset10 ;
                case 2
                    f_Set = set20 ;
                    l_set = lset20 ;
                case 3
                    f_Set = set30 ;
                    l_set = lset30 ;
                case 4
                    f_Set = set40 ;
                    l_set = lset40 ;
            end
            switch idxx2
                case 1
                    f_Set = [f_Set ; set10 ] ;  % foreground set
                    l_set = [l_set ;lset10 ] ;
                case 2
                    f_Set = [f_Set ; set20 ] ;  % foreground set
                    l_set = [l_set ;lset20 ] ;
                case 3
                    f_Set = [f_Set ; set30 ] ;  % foreground set
                    l_set = [l_set ;lset30 ] ;
                case 4
                    f_Set = [f_Set ; set40 ] ;  % foreground set
                    l_set = [l_set ;lset40 ] ;
            end    
            % case 2: shadow has 2 sides
        else
            [~, idx1] = min(rows) ;
            [~, idx2] = max(rows) ;
            set1 = Bsh{cntr}(min(idx1,idx2):max(idx1,idx2),:) ;
            set2 = [Bsh{cntr}(max(idx1,idx2):end,:) ; Bsh{cntr}(1:min(idx1,idx2),:)] ;
            set_rows = [set1(:,1);set2(:,1)];
            lset1 = sub2ind(size(im1), set1(:,1), set1(:,2));
            lset2 = sub2ind(size(im1), set2(:,1), set2(:,2));
            lset1_d = Id(lset1) ; lset1_d(lset1_d==0) = [];
            lset2_d = Id(lset2) ; lset2_d(lset2_d==0) = [];
            d_set1 = mean(lset1_d) ;
            d_set2 = mean(lset2_d) ;
            depth_set = [mean(lset1_d) mean(lset2_d)] ;
            [~, idxx] = min(depth_set) ;
            switch idxx
                case 1
                    f_Set = set1 ;  % foreground set
                    l_set = lset1 ;
                case 2
                    f_Set = set2 ;
                    l_set = lset2 ;
            end
        end
        BW_forg(l_set) = true ;
    end
end

end


