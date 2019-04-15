
function [eout,thresh,gv_45,gh_135] = edge_modified(varargin)
%EDGE Find edges in intensity image.
%   EDGE takes an intensity or a binary image I as its input, and returns a
%   binary image BW of the same size as I, with 1's where the function
%   finds edges in I and 0's elsewhere.
%
%   EDGE supports six different edge-finding methods:
%
%      The Sobel method finds edges using the Sobel approximation to the
%      derivative. It returns edges at those points where the gradient of
%      I is maximum.
%
%      The Prewitt method finds edges using the Prewitt approximation to
%      the derivative. It returns edges at those points where the gradient
%      of I is maximum.
%
%      The Roberts method finds edges using the Roberts approximation to
%      the derivative. It returns edges at those points where the gradient
%      of I is maximum.
%
%      The Laplacian of Gaussian method finds edges by looking for zero
%      crossings after filtering I with a Laplacian of Gaussian filter.
%
%      The zero-cross method finds edges by looking for zero crossings
%      after filtering I with a filter you specify.
%
%      The Canny method finds edges by looking for local maxima of the
%      gradient of I. The gradient is calculated using the derivative of a
%      Gaussian filter. The method uses two thresholds, to detect strong
%      and weak edges, and includes the weak edges in the output only if
%      they are connected to strong edges. This method is therefore less
%      likely than the others to be "fooled" by noise, and more likely to
%      detect true weak edges.
%
%   The parameters you can supply differ depending on the method you
%   specify. If you do not specify a method, EDGE uses the Sobel method.
%
%   Sobel Method
%   ------------
%   BW = EDGE(I,'sobel') specifies the Sobel method.
%
%   BW = EDGE(I,'sobel',THRESH) specifies the sensitivity threshold for
%   the Sobel method. EDGE ignores all edges that are not stronger than
%   THRESH.  If you do not specify THRESH, or if THRESH is empty ([]),
%   EDGE chooses the value automatically.
%
%   BW = EDGE(I,'sobel',THRESH,DIRECTION) specifies directionality for the
%   Sobel method. DIRECTION is a string specifying whether to look for
%   'horizontal' or 'vertical' edges, or 'both' (the default).
%
%   BW = EDGE(I,'sobel',...,OPTIONS) provides an optional string
%   input. String 'nothinning' speeds up the operation of the algorithm by
%   skipping the additional edge thinning stage. By default, or when
%   'thinning' string is specified, the algorithm applies edge thinning.
%
%   [BW,thresh] = EDGE(I,'sobel',...) returns the threshold value.
%
%   Prewitt Method
%   --------------
%   BW = EDGE(I,'prewitt') specifies the Prewitt method.
%
%   BW = EDGE(I,'prewitt',THRESH) specifies the sensitivity threshold for
%   the Prewitt method. EDGE ignores all edges that are not stronger than
%   THRESH. If you do not specify THRESH, or if THRESH is empty ([]),
%   EDGE chooses the value automatically.
%
%   BW = EDGE(I,'prewitt',THRESH,DIRECTION) specifies directionality for
%   the Prewitt method. DIRECTION is a string specifying whether to look
%   for 'horizontal' or 'vertical' edges, or 'both' (the default).
%
%   BW = EDGE(I,'prewitt',...,OPTIONS) provides an optional string
%   input. String 'nothinning' speeds up the operation of the algorithm by
%   skipping the additional edge thinning stage. By default, or when
%   'thinning' string is specified, the algorithm applies edge thinning.
%
%   [BW,thresh] = EDGE(I,'prewitt',...) returns the threshold value.
%
%   Roberts Method
%   --------------
%   BW = EDGE(I,'roberts') specifies the Roberts method.
%
%   BW = EDGE(I,'roberts',THRESH) specifies the sensitivity threshold for
%   the Roberts method. EDGE ignores all edges that are not stronger than
%   THRESH. If you do not specify THRESH, or if THRESH is empty ([]),
%   EDGE chooses the value automatically.
%
%   BW = EDGE(I,'roberts',...,OPTIONS) provides an optional string
%   input. String 'nothinning' speeds up the operation of the algorithm by
%   skipping the additional edge thinning stage. By default, or when
%   'thinning' string is specified, the algorithm applies edge thinning.
%
%   [BW,thresh] = EDGE(I,'roberts',...) returns the threshold value.
%
%   Laplacian of Gaussian Method
%   ----------------------------
%   BW = EDGE(I,'log') specifies the Laplacian of Gaussian method.
%
%   BW = EDGE(I,'log',THRESH) specifies the sensitivity threshold for the
%   Laplacian of Gaussian method. EDGE ignores all edges that are not
%   stronger than THRESH. If you do not specify THRESH, or if THRESH is
%   empty ([]), EDGE chooses the value automatically.
%
%   BW = EDGE(I,'log',THRESH,SIGMA) specifies the Laplacian of Gaussian
%   method, using SIGMA as the standard deviation of the LoG filter. The
%   default SIGMA is 2; the size of the filter is N-by-N, where
%   N=CEIL(SIGMA*3)*2+1.
%
%   [BW,thresh] = EDGE(I,'log',...) returns the threshold value.
%
%   Zero-cross Method
%   -----------------
%   BW = EDGE(I,'zerocross',THRESH,H) specifies the zero-cross method,
%   using the specified filter H. If THRESH is empty ([]), EDGE chooses
%   the sensitivity threshold automatically.
%
%   [BW,THRESH] = EDGE(I,'zerocross',...) returns the threshold value.
%
%   Canny Method
%   ----------------------------
%   BW = EDGE(I,'canny') specifies the Canny method.
%
%   BW = EDGE(I,'canny',THRESH) specifies sensitivity thresholds for the
%   Canny method. THRESH is a two-element vector in which the first element
%   is the low threshold, and the second element is the high threshold. If
%   you specify a scalar for THRESH, this value is used for the high
%   threshold and 0.4*THRESH is used for the low threshold. If you do not
%   specify THRESH, or if THRESH is empty ([]), EDGE chooses low and high
%   values automatically.
%
%   BW = EDGE(I,'canny',THRESH,SIGMA) specifies the Canny method, using
%   SIGMA as the standard deviation of the Gaussian filter. The default
%   SIGMA is sqrt(2); the size of the filter is chosen automatically, based
%   on SIGMA.
%
%   [BW,thresh] = EDGE(I,'canny',...) returns the threshold values as a
%   two-element vector.
%
%   Class Support
%   -------------
%   I is a nonsparse numeric array. BW is of class logical.
%
%   Remarks
%   -------
%   For the 'log' and 'zerocross' methods, if you specify a
%   threshold of 0, the output image has closed contours because
%   it includes all of the zero crossings in the input image.
%
%   The function EDGE changed in version 7.2 (R2011a). Previous versions
%   of the Image Processing Toolbox used a different algorithm for
%   computing the Canny method. If you need the same results produced
%   by the previous implementation, use BW = EDGE(I,'canny_old',...).
%
%   Example
%   -------
%   Find the edges of the circuit.tif image using the Prewitt and Canny
%   methods:
%
%       I = imread('circuit.tif');
%       BW1 = edge(I,'prewitt');
%       BW2 = edge(I,'canny');
%       figure, imshow(BW1)
%       figure, imshow(BW2)
%
%   See also FSPECIAL, IMGRADIENT, IMGRADIENTXY.

%   Copyright 1992-2015 The MathWorks, Inc.

%   [BW,thresh,gv,gh] = EDGE(I,'sobel',...) returns vertical and
%   horizontal edge responses to Sobel gradient operators. You can
%   also use these expressions to obtain gradient responses:
%   if ~(isa(I,'double') || isa(I,'single')); I = im2single(I); end
%   gh = imfilter(I,fspecial('sobel') /8,'replicate'); and
%   gv = imfilter(I,fspecial('sobel')'/8,'replicate');
% 
%   [BW,thresh,gv,gh] = EDGE(I,'prewitt',...) returns vertical and
%   horizontal edge responses to Prewitt gradient operators. You can
%   also use these expressions to obtain gradient responses:
%   if ~(isa(I,'double') || isa(I,'single')); I = im2single(I); end
%   gh = imfilter(I,fspecial('prewitt') /6,'replicate'); and
%   gv = imfilter(I,fspecial('prewitt')'/6,'replicate');
%
%   [BW,thresh,g45,g135] = EDGE(I,'roberts',...) returns 45 degree and
%   135 degree edge responses to Roberts gradient operators. You can
%   also use these expressions to obtain gradient responses:
%   if ~(isa(I,'double') || isa(I,'single')); I = im2single(I); end
%   g45  = imfilter(I,[1 0; 0 -1]/2,'replicate'); and
%   g135 = imfilter(I,[0 1;-1  0]/2,'replicate');

[a,method,thresh,sigma,thinning,H,kx,ky] = parse_inputs(varargin{:});

% Check that the user specified a valid number of output arguments
if ~any(strcmp(method,{'sobel','roberts','prewitt'})) && (nargout>2)
    error(message('images:edge:tooManyOutputs'))
end

% Transform to a double precision intensity image if necessary
if ~isa(a,'double') && ~isa(a,'single')
    a = im2single(a);
end

[m,n] = size(a);

if strcmp(method,'canny')
    % Magic numbers
    PercentOfPixelsNotEdges = .7; % Used for selecting thresholds
    ThresholdRatio = .4;          % Low thresh is this fraction of the high.
    
    % Calculate gradients using a derivative of Gaussian filter
    [dx, dy] = smoothGradient(a, sigma);
    
    % Calculate Magnitude of Gradient
    magGrad = hypot(dx, dy);
    
    % Normalize for threshold selection
    magmax = max(magGrad(:));
    if magmax > 0
        magGrad = magGrad / magmax;
    end
    
    % Determine Hysteresis Thresholds
    [lowThresh, highThresh] = selectThresholds(thresh, magGrad, PercentOfPixelsNotEdges, ThresholdRatio, mfilename);
    
    % Perform Non-Maximum Suppression Thining and Hysteresis Thresholding of Edge
    % Strength
    e = thinAndThreshold(dx, dy, magGrad, lowThresh, highThresh);
    thresh = [lowThresh highThresh];  
end

if nargout==0,
    imshow(e);
else
    eout = e;
end

if isempty(a)
    if nargout==2
        if nargin == 2
            if strcmp(method,'canny')
                thresh = nan(1,2);
            else
                thresh = nan(1);
            end
        end
    end    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : parse_inputs
%
function [I,Method,Thresh,Sigma,Thinning,H,kx,ky] = parse_inputs(varargin)
% OUTPUTS:
%   I      Image Data
%   Method Edge detection method
%   Thresh Threshold value
%   Sigma  standard deviation of Gaussian
%   H      Filter for Zero-crossing detection
%   kx,ky  From Directionality vector

narginchk(1,5)

I = varargin{1};

validateattributes(I,{'numeric','logical'},{'real','nonsparse','2d'},mfilename,'I',1);

% Defaults
Method    = 'sobel';
Direction = 'both';
Thinning  = true;

methods    = {'canny','canny_old','prewitt','sobel','marr-hildreth','log','roberts','zerocross'};
directions = {'both','horizontal','vertical'};
options    = {'thinning','nothinning'};

% Now parse the nargin-1 remaining input arguments

% First get the strings - we do this because the interpretation of the
% rest of the arguments will depend on the method.
nonstr = [];   % ordered indices of non-string arguments
for i = 2:nargin
    if ischar(varargin{i})
        str = lower(varargin{i});
        j = find(strcmp(str,methods));
        k = find(strcmp(str,directions));
        l = find(strcmp(str,options));
        if ~isempty(j)
            Method = methods{j(1)};
            if strcmp(Method,'marr-hildreth')
                error(message('images:removed:syntax','EDGE(I,''marr-hildreth'',...)','EDGE(I,''log'',...)')) 
            end
        elseif ~isempty(k)
            Direction = directions{k(1)};
        elseif ~isempty(l)
            if strcmp(options{l(1)},'thinning')
                Thinning = true;
            else
                Thinning = false;
            end
        else
            error(message('images:edge:invalidInputString', varargin{ i }))
        end
    else
        nonstr = [nonstr i]; %#ok<AGROW>
    end
end

% Now get the rest of the arguments
[Thresh,Sigma,H,kx,ky] = images.internal.parseNonStringInputsEdge(varargin,Method,Direction,nonstr);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : smoothGradient
%
function [GX, GY] = smoothGradient(I, sigma)

% Create an even-length 1-D separable Derivative of Gaussian filter

% Determine filter length
filterLength = 8*ceil(sigma);
n = (filterLength - 1)/2;
x = -n:n;

% Create 1-D Gaussian Kernel
c = 1/(sqrt(2*pi)*sigma);
gaussKernel = c * exp(-(x.^2)/(2*sigma^2));

% Normalize to ensure kernel sums to one
gaussKernel = gaussKernel/sum(gaussKernel);

% Create 1-D Derivative of Gaussian Kernel
derivGaussKernel = gradient(gaussKernel);

% Normalize to ensure kernel sums to zero
negVals = derivGaussKernel < 0;
posVals = derivGaussKernel > 0;
derivGaussKernel(posVals) = derivGaussKernel(posVals)/sum(derivGaussKernel(posVals));
derivGaussKernel(negVals) = derivGaussKernel(negVals)/abs(sum(derivGaussKernel(negVals)));

% Compute smoothed numerical gradient of image I along x (horizontal)
% direction. GX corresponds to dG/dx, where G is the Gaussian Smoothed
% version of image I.
GX = imfilter(I, gaussKernel', 'conv', 'replicate');

GX = imfilter(GX, derivGaussKernel, 'conv', 'replicate');


%added for handling angles in the range of -180 to 180 
G1 = GX ; 
indx1 = find((G1)>180) ;
G1(indx1)= -360+G1(indx1) ;
indx3 = find(G1<-180);
G1(indx3)= 360+G1(indx3) ;
GX = abs(G1) ; 
display('after modification')
min(min(GX))
max(max(GX))

%

% Compute smoothed numerical gradient of image I along y (vertical)
% direction. GY corresponds to dG/dy, where G is the Gaussian Smoothed
% version of image I.
GY = imfilter(I, gaussKernel, 'conv', 'replicate');
GY  = imfilter(GY, derivGaussKernel', 'conv', 'replicate');



%added for handling angles in the range of -180 to 180 
G2 = GY ; 
indx1 = find((G2)>180) ;
G2(indx1)= -360+G2(indx1) ;
indx3 = find(G2<-180);
G2(indx3)= 360+G2(indx3) ;
GY = abs(G2) ; 















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : selectThresholds
%
function [lowThresh, highThresh] = selectThresholds(thresh, magGrad, PercentOfPixelsNotEdges, ThresholdRatio, ~)

[m,n] = size(magGrad);

% Select the thresholds
if isempty(thresh)
    counts=imhist(magGrad, 64);
    highThresh = find(cumsum(counts) > PercentOfPixelsNotEdges*m*n,...
        1,'first') / 64;
    lowThresh = ThresholdRatio*highThresh;
elseif length(thresh)==1
    highThresh = thresh;
    if thresh>=1
        error(message('images:edge:thresholdMustBeLessThanOne'))
    end
    lowThresh = ThresholdRatio*thresh;
elseif length(thresh)==2
    lowThresh = thresh(1);
    highThresh = thresh(2);
    if (lowThresh >= highThresh) || (highThresh >= 1)
        error(message('images:edge:thresholdOutOfRange'))
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Local Function : thinAndThreshold
%
function H = thinAndThreshold(dx, dy, magGrad, lowThresh, highThresh)
% Perform Non-Maximum Suppression Thining and Hysteresis Thresholding of
% Edge Strength
    
% We will accrue indices which specify ON pixels in strong edgemap
% The array e will become the weak edge map.

E = cannyFindLocalMaxima(dx,dy,magGrad,lowThresh);

if ~isempty(E)
    [rstrong,cstrong] = find(magGrad>highThresh & E);
    
    if ~isempty(rstrong) % result is all zeros if idxStrong is empty
        H = bwselect(E, cstrong, rstrong, 8);
    else
        H = false(size(E));
    end
else
    H = false(size(E));
end
