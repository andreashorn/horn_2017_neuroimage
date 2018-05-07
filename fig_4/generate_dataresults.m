function generate_dataresults(varargin)
clc
lead
whichnormmethod='ea_normalize_ants'; %'ea_normalize_spmdartel' / 'ea_normalize_ants';


load('lg/LEAD_groupanalysis.mat');
try load(['results_',whichnormmethod]); end
cfg.acmcpc=2; % relative to AC/MCP/PC.

if nargin
    querypoint=varargin{1};
else
    querypoint=[-12.02  -1.53   -1.91];
end




leaddir=[fileparts(which('lead')),filesep];

switch whichnormmethod
    case 'ea_normalize_spmdartel' % use dartel MNI template
        tempfile=[leaddir,'templates',filesep,'dartel',filesep,'dartelmni_6.nii'];
%     case 'ea_normalize_ants'
%         ea_error('ANTs normalization is not supported as of now.');
    otherwise % use mni_hires
        tempfile=[leaddir,'templates',filesep,'mni_hires.nii'];
end

results.acpc=querypoint;


%% step minus one, measure using tal2mni.m:


  
results.mni_tal2mni=tal2mni(results.acpc);


save(['results_',whichnormmethod],'results');

load(['results_',whichnormmethod]);


%% step minus one-half, measure using tal2icbm_spm.m:


 
        results.mni_tal2icbm_spm=tal2icbm_spm(results.acpc);

save(['results_',whichnormmethod],'results');

load(['results_',whichnormmethod]);

%% step zero, measure on MNI space:

% establish pt folders

root='/Volumes/Neuro_Charite/ACPC/MNIonly/';

clear ptlist meanwarpmni
   ptlist{1}=[root,'mnisubject'];
   
cfg.mapmethod=0;

        cfg.xmm=results.acpc(1); cfg.ymm=results.acpc(2); cfg.zmm=results.acpc(3);
        
        fid=ea_acpc2mni(cfg,ptlist,whichnormmethod,tempfile,'mni_mnimeasure.nii');
               
        for fi=1:length(fid)
            meanwarpmni(fi,:)=fid(fi).WarpedPointMNI;
        end
        meanwarpmni=mean(meanwarpmni,1);
            
        results.mni_mnimeasure=meanwarpmni;

save(['results_',whichnormmethod],'results');

load(['results_',whichnormmethod]);
%% step one, warp back to MNI using HCP data:

% establish pt folders

root='/Volumes/Neuro_Charite/HCP/';
prefix='mgh_1*';
clear ptlist meanwarpmni
ptdir=dir([root,prefix]);

for pt=1:length(ptdir);
   ptlist{pt}=[root,ptdir(pt).name]; 
end
cfg.mapmethod=0;

        cfg.xmm=results.acpc(1); cfg.ymm=results.acpc(2); cfg.zmm=results.acpc(3);
        
        fid=ea_acpc2mni(cfg,ptlist,whichnormmethod,tempfile,'mni_hcp.nii');
        
        for fi=1:length(fid)
            meanwarpmni(fi,:)=fid(fi).WarpedPointMNI;
        end

            
        results.mni_hcp=meanwarpmni;
        results.mni_hcp_std=std(meanwarpmni,0,1);
        results.mni_hcp_mean=mean(meanwarpmni,1);



save(['results_',whichnormmethod],'results');

load(['results_',whichnormmethod]);
%% step two A, warp back to MNI using PPMI Control's data:

% establish pt folders

root='/Volumes/Neuro_Charite/ACPC/PPMI_Control_T2/';
prefix='';
clear ptlist meanwarpmni
ptdir=dir([root,prefix]);
cnt=1;
for pt=1:length(ptdir);
    if ptdir(pt).isdir && ~strcmp(ptdir(pt).name(1),'.')
        ptlist{cnt}=[root,ptdir(pt).name];
        cnt=cnt+1;
    end
end

cfg.mapmethod=0;

        cfg.xmm=results.acpc(1); cfg.ymm=results.acpc(2); cfg.zmm=results.acpc(3);
        fid=ea_acpc2mni(cfg,ptlist,whichnormmethod,tempfile,'mni_ppmicontrol.nii');

        for fi=1:length(fid)
            meanwarpmni(fi,:)=fid(fi).WarpedPointMNI;
        end
            
        results.mni_ppmicontrol=meanwarpmni;
        results.mni_ppmicontrol_std=std(meanwarpmni,0,1);
        results.mni_ppmicontrol_mean=mean(meanwarpmni,1);

save(['results_',whichnormmethod],'results');

load(['results_',whichnormmethod]);



%% step two B, warp back to MNI using PPMI Parkinson's data:

% establish pt folders

root='/Volumes/Neuro_Charite/ACPC/PPMI_PD_T2/';
prefix='';
clear ptlist meanwarpmni
ptdir=dir([root,prefix]);
cnt=1;
for pt=1:length(ptdir);
    if ptdir(pt).isdir && ~strcmp(ptdir(pt).name(1),'.')
        ptlist{cnt}=[root,ptdir(pt).name];
        cnt=cnt+1;
    end
end

cfg.mapmethod=0;

        cfg.xmm=results.acpc(1); cfg.ymm=results.acpc(2); cfg.zmm=results.acpc(3);
        
        fid=ea_acpc2mni(cfg,ptlist,whichnormmethod,tempfile,'mni_ppmipd.nii');
        
        for fi=1:length(fid)
            meanwarpmni(fi,:)=fid(fi).WarpedPointMNI;
        end
        results.mni_ppmipd=meanwarpmni;
        results.mni_ppmipd_std=std(meanwarpmni,0,1);
        results.mni_ppmipd_mean=mean(meanwarpmni,1);


save(['results_',whichnormmethod],'results');

load(['results_',whichnormmethod]);



%% step three, warp back to MNI using DBS peers Parkinson's data:

% establish pt folders

root='/Volumes/Neuro_Charite/ACPC/DBS_PD/';
prefix='';
clear ptlist meanwarpmni
ptdir=dir([root,prefix]);


cfg.mapmethod=0;
    cnt=1;
for pt=1:length(M.patient.list)
    
        if ptdir(pt).isdir && ~strcmp(ptdir(pt).name(1),'.')
        ptlist{cnt}=[root,ptdir(pt).name];
        cnt=cnt+1;
        end
end
    

   
        cfg.xmm=results.acpc(1); cfg.ymm=results.acpc(2); cfg.zmm=results.acpc(3);
        
        fid=ea_acpc2mni(cfg,ptlist,whichnormmethod,tempfile,'mni_dbspd.nii');
        
        for fi=1:length(fid)
            try
            meanwarpmni(fi,:)=fid(fi).WarpedPointMNI;
            catch
                keyboard
            end
        end

            
        results.mni_dbspd=meanwarpmni;
        results.mni_dbspd_std=std(meanwarpmni,0,1);
        results.mni_dbspd_mean=mean(meanwarpmni,1);

save(['results_',whichnormmethod],'results');
plotresults;










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



