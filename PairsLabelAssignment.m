


DrawSelectedPoints(TargetPoints, TargetPoints_noshift,30,Ic,'Selected Points')
drawPclMarkedPts(Cloud_B2, set_points, original_points, 31, 'PCL - Before and After Shifting',P)
draw_pcl_Xaxis(Cloud_B2, LL1, LL2,32, 'Fit Lines') % draw fit lines on the PCL
draw_pcl(Cloud_B2, P_centerRAN, p_best, n_best, ro_best, Dir_vecRAN, 33, 'RANSAC-Point Cloud',P)
draw_pairs_v2(ListPair(x0,:),Line_new,Ic,34)
prompt = 'score for this pair? 0~5 ';
x_prmpt= input(prompt) ;
(x0) = x_prmpt ;
close figure 30 31 32 33 34