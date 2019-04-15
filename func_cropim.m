function im_out = func_cropim(im_in,zone_val)

    im_out = im_in(zone_val(1):zone_val(2),zone_val(3):zone_val(4),:);

end
