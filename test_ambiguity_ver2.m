

%% this function, checks for ambiguity
% it just perfomrs on DD edges
% shift the pixels in direction of the object and extract depth values and
% Gdir values from corresponded images. Therefore, we end up with two 1D
% vectors. After normalizing the derivative of the vector, we check if
% there's peak in vector with great distance from the other peaks

out_amb = zeros(1,4) ; 
ff = 1 ; 

tic

for cc=1:size(Line_new,1) ;
%for cc=38

%%


if Line_new(cc,5)<25 % length of line
    continue
end
    

if Line_new(cc,11)== 9   % object is on the negetive side of the line
    param = -10 ;
elseif Line_new(cc,11)==10   % object is on the positive side of the line
    param = +10 ;
else
    continue
end

[yc,xc] = ind2sub(size(Id),ListPoint_new{cc}) ;

if (Line_new(cc,12) == 1) % line is vertical
    xcnew= xc + param ;
    ycnew = yc ;
else % line is vertical
    xcnew= xc ;
    ycnew = yc + param ;
end
lindnew = sub2ind(size(Id),ycnew,xcnew) ;

% cut a piece from 2 sides
lindnew = lindnew(6:end-5);

vec_depth = Id(lindnew) ; 
vec_Gdir = Gdir(lindnew);
vecD_depth = diff(vec_depth);
vecD_Gdir = diff(vec_Gdir);
vecD_depth = abs(abs(vecD_depth)/max(abs(vecD_depth)));
vecD_Gdir = abs(abs(vecD_Gdir)/max(abs(vecD_Gdir)));

ind_d = find(vecD_depth > 0.5) ;
ind_g = find(vecD_Gdir  > 0.5) ;

if length(ind_d)==1
    %display('break in depth')
    out_amb(ff,:) = [cc 1 ycnew(ind_d) xcnew(ind_d)] ;
    ff = ff+1 ; 
    i_test = false(size(Id)) ; 
    i_test(lindnew)= true ; 
    i_test(ListPoint_new{cc}) = true ; 
    draw_LogicalOnImage(i_test,Ic,'break in depth',15)
    out_amb(ff-1,:)
    prompt = 'next loop? ';
    inp1 = input(prompt) ; 
    close(figure(15))
end

if length(ind_g)==1
    %display('break in orientation')
    out_amb(ff,:) = [cc 2 ycnew(ind_g) xcnew(ind_g)] ;
    ff = ff+1 ; 
    i_test = false(size(Id)) ; 
    i_test(lindnew)= true ; 
    i_test(ListPoint_new{cc}) = true ; 
    draw_LogicalOnImage(i_test,Ic,'break in curve',15)
    out_amb(ff-1,:)
    prompt = 'next loop? ';
    inp1 = input(prompt) ; 
    close(figure(15))
end




end



% for cnt2 = 1:length(xcnew)
%     win_adj(cnt2,:) = Gdir(ycnew(cnt2),xcnew(cnt2):xcnew(cnt2)+5) ; 
% end

toc
% 
% Lineamb= Line_new(out_amb(:,1),:)   ;
% DrawLineFeature(Lineamb,Ic,'marked lines',5)




