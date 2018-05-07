clear

labels={'PD_STN','Dyt_GPi','ET_VIM','MD_SCC','OCD_NAc','OCD_ALIC','TS_CMPVVOI','AD_FORNIX','ADD_NAc'};
for seed=1:length(labels)
    
    ea_flip_lr([labels{seed},'.nii'],['fl_',labels{seed},'.nii']);
    
  
    
    matlabbatch{1}.spm.util.imcalc.input = {['/Volumes/Neuro_Charite/ACPC/acpccon/dmriseeds_trackvis/seedspace.nii']
        [labels{seed},'.nii']
        ['fl_',labels{seed},'.nii']};
    matlabbatch{1}.spm.util.imcalc.output = [labels{seed},'.nii'];
    matlabbatch{1}.spm.util.imcalc.outdir = {'/Volumes/Neuro_Charite/ACPC/acpccon/dmriseeds_trackvis'};
    matlabbatch{1}.spm.util.imcalc.expression = '(i2+i3)';
    matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
    matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
    matlabbatch{1}.spm.util.imcalc.options.mask = -1;
    matlabbatch{1}.spm.util.imcalc.options.interp = 1;
    matlabbatch{1}.spm.util.imcalc.options.dtype = 16;
    cfg_util('run',{matlabbatch});
    delete(['fl_',labels{seed},'.nii']);
end