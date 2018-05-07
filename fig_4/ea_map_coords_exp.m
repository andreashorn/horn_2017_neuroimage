function [XYZ_mm, XYZ_src_vx] = ea_map_coords_exp(XYZ_vx, trg, xfrm, src,whichnormmethod)
% This version of map_coords is based on Ged Ridgway's version but is
% optimized for usage in Lead-DBS. Especially, it supports ANTs and
% interpolations in high dimensional warping with SPM.

%  % high-dimensional warping / y_ deformation field:
%   % from target voxel space to source world and voxel space
%    [XYZ_mm XYZ_src_vx] = map_coords(XYZ_vx, '', 'y_img.nii', src);
%
% Ged Ridgway (drc.spm at gmail.com)


if nargin < 2
    error('map_coords:usage',...
        'Must specify at least coords and trg; empty [] for GUI prompt')
end

% Input coordinates
if isempty(XYZ_vx)
    XYZ_vx = spm_input('voxel coords? ', '+1', 'r', '1 1 1', [Inf 3])';
end
n = size(XYZ_vx, 2); % number of points
if size(XYZ_vx, 1) == 3
    % note to return 3*n later
    homog = false;
    % make homogeneous
    XYZ_vx = [XYZ_vx; ones(1, n)];
elseif size(XYZ_vx, 1) == 4
    homog = true;
else
    error('map_coords:dims',...
        'coord array must have 3 or 4 rows: [x;y;z] or [x;y;z;1]')
end

% Coordinate mapping
if ~exist('xfrm', 'var') || ~ischar(xfrm)
    % affine only
    if isempty(trg)
        trg = spm_select(1, 'image', 'Choose target image');
    end
    trg = spm_vol(trg);
    XYZ_mm = trg.mat * XYZ_vx;
    xfrm = []; % (now set to empty)
elseif isempty(xfrm)
    xfrm = spm_select([0 1], 'any',...
        'Select transformation file (e.g. sn.mat or HDW y_ field',...
        '', pwd, '\.(mat|img|nii)$'); % (empty if user chooses nothing)
end
if ~isempty(xfrm)
    if ~isempty(regexp(xfrm, 'sn\.mat$', 'once'))
        % DCT sn structure
        XYZ_mm = sn_trgvx2srcmm(XYZ_vx, xfrm);
    elseif ~isempty(regexp(xfrm, 'y_.*(nii|img)$', 'once'))
        % HDW transformation field
        
        
        % check if ANTs has been used here:
        directory=fileparts(xfrm);
        if strcmp(whichnormmethod,'ea_normalize_ants')
            [~,fn]=fileparts(xfrm);
            if ~isempty(strfind(fn,'inv'))
                useinverse=1;
            else
                useinverse=0;
            end
            V=spm_vol(src);
            
            %XYZ_vxLPS=[V.dim(1)-XYZ_vx(1,:);V.dim(2)-XYZ_vx(2,:);XYZ_vx(3,:);ones(1,size(XYZ_vx,2))];
            
             XYZ_mm_beforetransform=V(1).mat*XYZ_vx;
             XYZ_mm_beforetransform(1,:)=-XYZ_mm_beforetransform(1,:);
             XYZ_mm_beforetransform(2,:)=-XYZ_mm_beforetransform(2,:);
             
            XYZ_mm=ea_ants_applytransforms_to_points([directory,filesep],XYZ_mm_beforetransform,useinverse);
            XYZ_mm(1,:)=-XYZ_mm(1,:);
            XYZ_mm(2,:)=-XYZ_mm(2,:);
        else
            XYZ_mm = hdw_trgvx2srcmm(XYZ_vx, xfrm);
        end
    else
        error('map_coords:xfrm', 'unrecognised transformation file')
    end
elseif ~exist('XYZ_mm', 'var')
    error('map_coords:nothingdoing',...
        'failed to select target image or transformation, nothing to do!')
end

% Optional mapping from source world space (mm) to source voxel space
if nargout > 1
    if exist('src', 'var')
        if isempty(src)
            src = spm_select(1, 'image', 'Choose source image');
        end
        src = spm_vol(src);
        XYZ_src_vx = src.mat \ XYZ_mm;
    elseif ischar(xfrm) && ~isempty(regexp(xfrm, 'sn\.mat$', 'once'))
        load(xfrm, 'VF');
        XYZ_src_vx = VF.mat \ XYZ_mm;
    elseif exist('trg', 'var')
        % assume input actually world coords, and desired vox coord output
        XYZ_mm = XYZ_vx;
        XYZ_src_vx = trg.mat \ XYZ_mm;
    else
        error('map_coords:src_vx',...
            'source image (or sn.mat) not specified, but src_vx requested')
    end
end

% Use consistent style of coordinates between input and output
if ~homog % drop homogeneous ones from output
    XYZ_mm(4, :) = [];
    if exist('XYZ_src_vx', 'var')
        XYZ_src_vx(4, :) = [];
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function coord = sn_trgvx2srcmm(coord, matname)
% src_mm = sn_trgvx2srcmm(trg_vx, matname)
% Based on John Ashburner's get_orig_coord5.m
sn = load(matname); Tr = sn.Tr;
if numel(Tr) ~= 0 % DCT warp: trg_vox displacement
    d = sn.VG(1).dim(1:3); % (since VG may be 3-vector of TPM volumes)
    dTr = size(Tr);
    basX = spm_dctmtx(d(1), dTr(1), coord(1,:)-1);
    basY = spm_dctmtx(d(2), dTr(2), coord(2,:)-1);
    basZ = spm_dctmtx(d(3), dTr(3), coord(3,:)-1);
    for i = 1:size(coord, 2)
        bx = basX(i, :);
        by = basY(i, :);
        bz = basZ(i, :);
        tx = reshape(...
            reshape(Tr(:,:,:,1),dTr(1)*dTr(2),dTr(3))*bz',dTr(1),dTr(2) );
        ty = reshape(...
            reshape(Tr(:,:,:,2),dTr(1)*dTr(2),dTr(3))*bz',dTr(1),dTr(2) );
        tz =  reshape(...
            reshape(Tr(:,:,:,3),dTr(1)*dTr(2),dTr(3))*bz',dTr(1),dTr(2) );
        coord(1:3,i) = coord(1:3,i) + [bx*tx*by' ; bx*ty*by' ; bx*tz*by'];
    end
end
% Affine: trg_vox (possibly displaced by above DCT) to src_vox
coord = sn.VF.mat * sn.Affine * coord;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function coord = hdw_trgvx2srcmm(coord, hdwim)
% src_mm = hdw_trgvx2srcmm(trg_vx, y_hdw)
inds = coord(1:3, :);
% if abs(coord(1:3, :) - inds) > 0.01
%     warning('map_coords:hdw_rounding',...
%         'target voxel coords rounded for HDW')
% end
W = nifti(hdwim);

for i = 1:size(coord, 2)
    ind = inds(:, i);
    
               % linearly interpolate: 
    targ(1,1,1,:)=squeeze(W.dat(floor(ind(1)), floor(ind(2)), floor(ind(3)), 1, 1:3));
    seed(1,1,1,:)=[floor(ind(1)), floor(ind(2)), floor(ind(3))];
    vec(1,1,1,:)=squeeze(targ(1,1,1,:))-squeeze(seed(1,1,1,:));
    weight(1,1,1,:)=1-(pdist([squeeze(seed(1,1,1,:))';ind'])/sqrt(3));
    
    targ(1,1,2,:)=squeeze(W.dat(floor(ind(1)), floor(ind(2)), ceil(ind(3)), 1, 1:3));
    seed(1,1,2,:)=[floor(ind(1)), floor(ind(2)), ceil(ind(3))];
    vec(1,1,2,:)=squeeze(targ(1,1,2,:))-squeeze(seed(1,1,2,:));
    weight(1,1,2,:)=1-(pdist([squeeze(seed(1,1,2,:))';ind'])/sqrt(3));
    
    targ(1,2,1,:)=squeeze(W.dat(floor(ind(1)), ceil(ind(2)), floor(ind(3)), 1, 1:3));
    seed(1,2,1,:)=[floor(ind(1)), ceil(ind(2)), floor(ind(3))];
    vec(1,2,1,:)=squeeze(targ(1,2,1,:))-squeeze(seed(1,2,1,:));
        weight(1,2,1,:)=1-(pdist([squeeze(seed(1,2,1,:))';ind'])/sqrt(3));

    targ(2,1,1,:)=squeeze(W.dat(ceil(ind(1)), floor(ind(2)), floor(ind(3)), 1, 1:3));
    seed(2,1,1,:)=[ceil(ind(1)), floor(ind(2)), floor(ind(3))];
    vec(2,1,1,:)=squeeze(targ(2,1,1,:))-squeeze(seed(2,1,1,:));
        weight(2,1,1,:)=1-(pdist([squeeze(seed(2,1,1,:))';ind'])/sqrt(3));

    targ(1,2,2,:)=squeeze(W.dat(floor(ind(1)), ceil(ind(2)), ceil(ind(3)), 1, 1:3));
    seed(1,2,2,:)=[floor(ind(1)), ceil(ind(2)), ceil(ind(3))];
    vec(1,2,2,:)=squeeze(targ(1,2,2,:))-squeeze(seed(1,2,2,:));
        weight(1,2,2,:)=1-(pdist([squeeze(seed(1,2,2,:))';ind'])/sqrt(3));

    targ(2,1,2,:)=squeeze(W.dat(ceil(ind(1)), floor(ind(2)), ceil(ind(3)), 1, 1:3));
    seed(2,1,2,:)=[ceil(ind(1)), floor(ind(2)), ceil(ind(3))];
    vec(2,1,2,:)=squeeze(targ(2,1,2,:))-squeeze(seed(2,1,2,:));
        weight(2,1,2,:)=1-(pdist([squeeze(seed(2,1,2,:))';ind'])/sqrt(3));

    targ(2,2,1,:)=squeeze(W.dat(ceil(ind(1)), ceil(ind(2)), floor(ind(3)), 1, 1:3));
    seed(2,2,1,:)=[ceil(ind(1)), ceil(ind(2)), floor(ind(3))];
    vec(2,2,1,:)=squeeze(targ(2,2,1,:))-squeeze(seed(2,2,1,:));
        weight(2,2,1,:)=1-(pdist([squeeze(seed(2,2,1,:))';ind'])/sqrt(3));

    targ(2,2,2,:)=squeeze(W.dat(ceil(ind(1)), ceil(ind(2)), ceil(ind(3)), 1, 1:3));
    seed(2,2,2,:)=[ceil(ind(1)), ceil(ind(2)), ceil(ind(3))];
    vec(2,2,2,:)=squeeze(targ(2,2,2,:))-squeeze(seed(2,2,2,:));
        weight(2,2,2,:)=1-(pdist([squeeze(seed(2,2,2,:))';ind'])/sqrt(3));

%     rests=ind-floor(ind);
%     rrests=1-rests;
    
    weightsum=sum([weight(1,1,1,:)
        weight(1,1,2,:)
        weight(1,2,1,:)
        weight(2,1,1,:)
        weight(1,2,2,:)
        weight(2,1,2,:)
        weight(2,2,1,:)
        weight(2,2,2,:)]);
    
    coord(1:3,i)=ind+...
        sum([squeeze(vec(1,1,1,:))*weight(1,1,1,:),...
        squeeze(vec(1,1,2,:))*weight(1,1,2,:),...
        squeeze(vec(1,2,1,:))*weight(1,2,1,:),...
        squeeze(vec(2,1,1,:))*weight(2,1,1,:),...
        squeeze(vec(1,2,2,:))*weight(1,2,2,:),...
        squeeze(vec(2,1,2,:))*weight(2,1,2,:),...
        squeeze(vec(2,2,1,:))*weight(2,2,1,:),...
        squeeze(vec(2,2,2,:))*weight(2,2,2,:)],2)/weightsum;
    
% 
%    


%% original code:
%                coord(1:3, i) = squeeze(W.dat(ind(1), ind(2), ind(3), 1, 1:3));
end
