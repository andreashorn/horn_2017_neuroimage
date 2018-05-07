clear

labels={'PD_STN','Dyt_GPi','ET_VIM','MD_SCC','OCD_NAc','OCD_ALIC','TS_CMPVVOI','AD_FORNIX','ADD_NAc'};
labels={'TS_CMPVVOI'};
for seed=1:length(labels)
    
    ea_flip_lr([labels{seed},'.nii'],['fl_',labels{seed},'.nii']);
    
    
    matlabbatch{1}.spm.util.imcalc.input = {['acpccon/fmriseeds/seedspace.nii']
        [labels{seed},'.nii']
        ['fl_',labels{seed},'.nii']};
    matlabbatch{1}.spm.util.imcalc.output = [labels{seed},'.nii'];
    matlabbatch{1}.spm.util.imcalc.outdir = {'acpccon/fmriseeds'};
    matlabbatch{1}.spm.util.imcalc.expression = '(i2+i3)*500';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = -1;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
    cfg_util('run',{matlabbatch});
    clear matlabbatch
    
    matlabbatch{1}.spm.spatial.smooth.data = {['/PA/Neuro/_projects/ACPC/A15_allquerypoints_fig4/acpccon/fmriseeds/',labels{seed},'.nii,1']};
    matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';
    %cfg_util('run',{matlabbatch});
    clear matlabbatch
    %movefile(['acpccon/fmriseeds/s',labels{seed},'.nii'],['acpccon/fmriseeds/',labels{seed},'.nii']);
    
    
    matlabbatch{1}.spm.util.imcalc.input = {['acpccon/dmriseeds/seedspace.nii']
        [labels{seed},'.nii']
        ['fl_',labels{seed},'.nii']};
    matlabbatch{1}.spm.util.imcalc.output = [labels{seed},'.nii'];
    matlabbatch{1}.spm.util.imcalc.outdir = {'acpccon/dmriseeds'};
    matlabbatch{1}.spm.util.imcalc.expression = '(i2+i3)';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = -1;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
    cfg_util('run',{matlabbatch});
    delete(['fl_',labels{seed},'.nii']);
end