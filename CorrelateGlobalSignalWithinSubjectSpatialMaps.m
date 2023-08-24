  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% Must have SPM in pathway
  %% Correlate within whole-brain voxel-wise individual subject nifti files across pipelines
  %% Data should be in format of a main directory with sub-directories of preprocessing pipelines,
  %% with each sub-directory containing one unzipped 4D nifti file containing all individual subject's whole-brain voxel-wise spatial maps (all.nii)



 cd /u/Homedirectory %% change to home directory

 folder = {'one' 'two' 'three' 'four'}  %% Correlate niftis across four subdirectories of different preprocessing pipelines

   
 %% put nifti information into a 3-D array matlab array: voxel-wise betas x subject x preprocessing pipeline       
for f = 1:length(folder) 
   
       cd (folder{f})
    
       
       V = spm_vol(['all.nii']);  
       [Y,XYZ] = spm_read_vols(V);
      
       a = size(Y,1)
       b = size(Y,2)
       c = size(Y,3)
       d = size(Y,4)
       
       all(:,:,f)= reshape(Y,a*b*c,d);
     
       cd ../..
end
      
 %% turn all zeros to NaN then calculate correlation coefficients for each subject across preprocessing pipelines
 %% creates a 3d array: correlation matrix (row x column) x subject
      
      all(all==0)=NaN;


for s = 1:size(all,2)
    
    new = squeeze(all(:,s,:));
    allcorr(:,:,s) = corrcoef(new,'rows','pairwise');

end

%% calculate 3rd dimension mean across subjects representing the average within-subject correlation matrix between preprocessing pipelines

mean(allcorr,3)
        
        

 
  

  




