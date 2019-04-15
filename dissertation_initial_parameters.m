
%% load data

Load_Image_Win


%  Id_o = imread('Image0001.png');
%  Id_o = double(Id_o) ; 
%  Ic = label2rgb(Id_o);
Id_background = Id_o;
%load ('1116.mat')



%% LARGE OBJECTS PARAMETERS

% edge detection and line segmenting process
P.lld = 100 ; P.hhd = 8000; %bounds for removing data %default 50 1800
P.thresh_dis  = 0.05 ; % defualt 0.07


P.thresh_curve  = 0.25 ; % defualt 0.25
P.sizeGFilter = 5 ;  % ** 5
P.flag_ManualGradModif = false ; 
P.thresh_ManuaGradModif = 2 ; % default: 2
P.thresh_curve_mirror = 0.45 ; % ** 0.55
P.filter_Id = false ; 
P.flag_GdirMirror = false ; 
P.filter_gd = false ;

P.zone  = [5 475 5 635] ;
P.bound = 5 ;
P.tol_edge = 3 ;
P.tol_line = 7 ; %default was 3
P.label_win_size = 11 ; % half of window length % default : 3
P.label_win_sized = 9; % window for lineLabelFeature
P.thresh_label_dis = 0.040; % default: 0.04 /threshold for percentage of marked pixels in the window for disc.
P.lsize = 11 ; % size of window for do the depth_modify process
P.thresh_m = 22 ; % parameter for merging lines % angle_thresh default: 10



% pair matching
P.Cons_Dmax = 100 ;  % defualt (July 12 2016): 40 or 50
P.Cons_Dmin = 10  ; % dmax = default : 40
P.Cons_Lmin = 20; % default = 12
P.Cons_AlphaD = 25 ; % defualt (July 12 2016): 20 or 30
%P.d_thin = 0.001 ; % maximum distance between the pairs to consider as a thin object (unit:meter)
P.d_thin3 = 0.001;
P.d_thin2 = 10 ;


P.max_L3d = 20 ; % maximum length for a line (cm)
P.max_distance_3d = 8 ; % unit is cm / used in auto pair selection
P.max_error_ransac = 0.2 ; % used in auto pair selection


% shifting disc lines parameters
P.param = 5 ; %function depth_shift %default 6
P.thrsh_mag= 0.3 ; % function depth_shift default 0.3
%P.dm = 4 ; % shif displacemnet for depth modification (v6)


P.final_off = 5.5 ; % offset of final pose wrt the center (cm)
P.stop_off = 20 ; % offset of stop pose wrt the center (cm)

%% % GENERAL PARAMETERS
% flags
P.seq_shot = 20 ;
P.flag_save_input = true;
P.flag_d_stream = true ;
P.fillhole = false;
P.fig_pcl = true ; % draw point cloud figure?
P.pair_sel = false ; % select pair by the area
P.shift_all = false ; % a flag to control shifting for all the lines or just the selected pair



% CAMERA'S PARAMETERS
if strcmp(device_data, 'prime')
    P.Cons_Cam = 535;     % PRIME SENSE FOCAL LENGTH
    P.center = [ 317.8042  239.2228]; % PRIME SENSE CENTER POINT
    yaw = (pos(cc,4))/180*pi;
    pit = -(pos(cc,5))/180*pi;
    roll = (sign(pos(cc,6))*(180-abs(pos(cc,6))))/180*pi;
    camera_offset = [63,38,37];
    P.baseloc = (1*pos(cc,1:3)+[angle2dcm(yaw, pit,roll )'*camera_offset']')/1000;
    % [angle2dcm(yaw, pit,roll )'*camera_offset']' ;
    P.pos = pos(cc,:);
    P.rot = angle2dcm(yaw, pit,roll );%
    P.rot2 = eye(3);
    pos(cc,:);
    P.flag_tran = 1;
elseif strcmp(device_data, 'kinect')
    %P.zone  = [50 450 50 490] ;
    %P.zone = [40,320,10,420] ;
    P.zone  = [15 465 15 625] ;
    P.Cons_Cam = 535;    
    P.center = [ 317.8042  239.2228];
    
    P.rot = eye(3);
    P.rot2 = eye(3);
    P.baseloc = [0 0 0];
end

    



%% save data
% % Receive_Image_Ros_v3
% % save the imported data
% for  t0=1:1
% if P.flag_save_input
%     prompt1 = 'tag for saving??';
%     seq_n = input(prompt1) ;
%     if seq_n~=0 ;
%         e = yyyymmdd(datetime('today'));
%         name_ws = sprintf('ExpClut_%d_%d.mat',e,seq_n) ;
%         save(name_ws,'Ic','Id_o','Ixyz','ichd','P') ;
%     end
%
% end
% end

%% clean the workspace


%clearvars('-except','Ic','Id_o','Ixyz','P','hdsub','pclsub','data_num','xypos')