
% different between this file and depth_shift_v1 is
% 1)
% in this file the direction of movement is determind based on the inverse
% tan of the whole line while in the previous version is based on the Gdir
% at the marked pixel
% 2)
% in the previous version direction of movement was determinded seperately
% for each point but in this version, a same direction (according to line
% feature) is applied for all the points of that line

function [ListPoint_new2] = depth_shift_v20805(ListPoint_new,Gmag, Line_new, Id,P,ff)

param = P.param ; 
thresh_mag = P.thrsh_mag ; 
ListPoint_new2 = ListPoint_new ;

for cnt=1:length(ff) 
    Line_new(ff(cnt),7) ;
    
    dir = Line_new(ff(cnt),7) +90 ; 

    lpp = ListPoint_new2{ff(cnt)} ; % all of the points on this line
    
    obj_side = Line_new(ff(cnt),11) ; 
    if obj_side==9
        mh1 = 10;
        mh2 = 20 ; 
    elseif obj_side == 10
        mh1 = 20 ;
        mh2 = 10 ;
    end
    
    
    for cnt2=1:size(lpp,1)
        mask_im = zeros(size(Id)) ;
        linc = lpp(cnt2) ;
        [yc,xc] = ind2sub(size(Id),linc) ;
        
        vec = zeros(1,2*param+1) ;
        
        if ~((yc<(size(Id,1)-param))&&((1+param)<yc)&&(xc<(size(Id,2)-param))&&((1+param)<xc))
            continue  % if window is by the margins, skip the current itteration
        end
        
        
        % case 1 : load a 0 deg line
        if (dir<22.5)||(dir>157.5)
            mask_im(yc , xc-param:xc+param) = Gmag(yc , xc-param:xc+param) ;
            vec(:) = Id(yc , xc-param:xc+param) ;
            
            % case 2 : load a +45 deg line
        elseif (22.5<dir)&&(dir<67.5)
            temp = Gmag(yc-param:yc+param , xc-param:xc+param) ;
            temp2 = zeros(size(temp)) ;
            temp2(2*param+1:2*param:end-1) = temp(2*param+1:2*param:end-1) ;
            mask_im(yc-param:yc+param , xc-param:xc+param) = temp2 ;
            temp = Id(yc-param:yc+param , xc-param:xc+param) ;
            vec(:) = temp(2*param+1:2*param:end-1) ;
            
            
            % case 3 : load a +90 deg line
        elseif (67.5<dir)&&(dir<112.5)
            mask_im(yc-param:yc+param  ,xc) = Gmag(yc-param:yc+param  ,xc) ;
            vec(:) = Id(yc-param:yc+param,xc) ;
            
            % case 4 : load a +135 deg line
        elseif (112.5<dir)&&(dir<157.5)
            temp = Gmag(yc-param:yc+param , xc-param:xc+param) ;
            temp2 = zeros(size(temp)) ;
            temp2(1:2*param+2:end) = temp(1:2*param+2:end) ;
            mask_im(yc-param:yc+param , xc-param:xc+param) = temp2 ;
            temp = Id(yc-param:yc+param , xc-param:xc+param) ;
            vec(:) = temp(1:2*param+2:end) ;
        end
        
 
        mask_im2 = mask_im ;

        % normalize magnitude values
        if mh1>mh2  
            mask_im2(1:linc-1) = 0 ;
            mask_im2 = (1/(max(mask_im2(:))))*mask_im2 ;
            mask_im2(mask_im2>thresh_mag) = 0.001 ; % previous value 0.05/ I changed to this new value because of some issues on 06/30/2016
            [~,ind] = max(mask_im2(:)) ;
        else
            mask_im2(linc-1:end) = 0 ;
            mask_im2 = (1/(max(mask_im2(:))))*mask_im2 ;
            mask_im2(mask_im2>thresh_mag) = 0.001 ;  % previous value 0.05/ I changed to this new value because of some issues on 06/30/2016
            [~,ind] = max(mask_im2(:)) ;
        end
        
        ListPoint_new2{ff(cnt)}(cnt2) = ind ;
    end
end
end
