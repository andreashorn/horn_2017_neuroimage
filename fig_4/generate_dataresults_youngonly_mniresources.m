function generate_dataresults_youngonly(varargin)



switch varargin{4}
    case 1 % tra
        mapresults2mni_youngonly_mniresources(varargin);
end








function outpoints = tal2mni(inpoints)
% Converts coordinates to MNI brain best guess
% from Talairach coordinates
% FORMAT outpoints = tal2mni(inpoints)
% Where inpoints is N by 3 or 3 by N matrix of coordinates
%  (N being the number of points)
% outpoints is the coordinate matrix with MNI points
% Matthew Brett 2/2/01

dimdim = find(size(inpoints) == 3);
if isempty(dimdim)
  error('input must be a N by 3 or 3 by N matrix')
end
if dimdim == 2
  inpoints = inpoints';
end

% Transformation matrices, different zooms above/below AC
rotn = spm_matrix([0 0 0 0.05]);
upz = spm_matrix([0 0 0 0 0 0 0.99 0.97 0.92]);
downz = spm_matrix([0 0 0 0 0 0 0.99 0.97 0.84]);

inpoints = [inpoints; ones(1, size(inpoints, 2))];
% Apply inverse translation
inpoints = inv(rotn)*inpoints;

tmp = inpoints(3,:)<0;  % 1 if below AC
inpoints(:, tmp) = inv(downz) * inpoints(:, tmp);
inpoints(:, ~tmp) = inv(upz) * inpoints(:, ~tmp);
outpoints = inpoints(1:3, :);
if dimdim == 2
  outpoints = outpoints';
end



function outpoints = tal2icbm_spm(inpoints)
%
% This function converts coordinates from Talairach space to MNI
% space (normalized using the SPM software package) using the 
% tal2icbm transform developed and validated by Jack Lancaster 
% at the Research Imaging Center in San Antonio, Texas.
%
% http://www3.interscience.wiley.com/cgi-bin/abstract/114104479/ABSTRACT
% 
% FORMAT outpoints = icbm_spm2tal(inpoints)
% Where inpoints is N by 3 or 3 by N matrix of coordinates
% (N being the number of points)
%
% ric.uthscsa.edu 3/14/07

% find which dimensions are of size 3
dimdim = find(size(inpoints) == 3);
if isempty(dimdim)
  error('input must be a N by 3 or 3 by N matrix')
end

% 3x3 matrices are ambiguous
% default to coordinates within a row
if dimdim == [1 2]
  disp('input is an ambiguous 3 by 3 matrix')
  disp('assuming coordinates are row vectors')
  dimdim = 2;
end

% transpose if necessary
if dimdim == 2
  inpoints = inpoints';
end

% Transformation matrices, different for each software package
icbm_spm = [0.9254 0.0024 -0.0118 -1.0207
	   	   -0.0048 0.9316 -0.0871 -1.7667
            0.0152 0.0883  0.8924  4.0926
            0.0000 0.0000  0.0000  1.0000];

% invert the transformation matrix
icbm_spm = inv(icbm_spm);

% apply the transformation matrix
inpoints = [inpoints; ones(1, size(inpoints, 2))];
inpoints = icbm_spm * inpoints;

% format the outpoints, transpose if necessary
outpoints = inpoints(1:3, :);
if dimdim == 2
  outpoints = outpoints';
end



