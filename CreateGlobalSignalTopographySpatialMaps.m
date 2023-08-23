%% This script will go through each subject folder within a main directory and create a 3dNifti file output 
%% consisting of unstandardized regression beta coefficients quantifying the association between the a ROI time-series 
%% (the global signal in this case from a gray matter brain mask) and the time-course of each voxel from a subjects 4D unzipped nifti file. 
%% Only TRs with a framewise displacement > 0.5mm will be included in the regression model. 


%% *****Must have SPM working**** 


%% File structure should have one home directory containing individual subject
%% folders labeled "s_0001", "s_0002", etc. 
%% Each subject folder should have:
%% 1) uncompressed nifti file for SPM (Filtered_4DVolume.nii)
%% 2) one text file with the time-series of interest (GlobalSignal.txt) 
%% 3) one text file with the framewise displacement for each TR (Power.txt)



cd {homedir}  %%change home directory path


files = dir('s*');  %identify all folders starting with "s" in directory to go through

for i = 1:length(files)
    cd (files(i).name)
    disp(files(i).name)
   
    
    
%%load unzipped 4D subject nifti into Matlab as a 2D array.    
    V = spm_vol(['Filtered_4DVolume.nii']);   
    [Y,XYZ] = spm_read_vols(V);
    a = size(Y,1);
    b = size(Y,2);
    c = size(Y,3);
    d = size(Y,4);
    Y = reshape(Y,a*b*c,d);
    
    
%% replace zeros with NaN and format mat file for regression
Y(Y==0)=NaN;
[row col] = size(Y);
Y = Y';  


%% load time series text file extracted using fslmeants
    gs = load('GlobalSignal.txt'); 
    

%% add constant to ROI time-series for regression  
for ss = 1:col              
  all(ss,:) = 1;
end

gs = horzcat(all,gs);
    
    
%% load motion statistics and identify TRs over .5mm Power FD     
FD = load('Power.txt'); 
     
for v = 1:length(FD)    
  vals(v,:) = FD(v,1)>=0.5;
end
    
   
%% order high TR volumes for deletion in reverse order (last high motion TR to first high motion TR)  
vals = double(vals);  
location = find(vals);
locationud = flipud(location); 

%delete TRs over 0.5mm Power FD in reverse order
for l = 1:length(locationud) 
  gs(locationud(l,:),:) = [];
  Y(locationud(l,:),:) = [];
end

    

%% identify regression coefficients between ROI time-series and each      
    final = double(gs'*gs)\double(gs'*Y);
    final(1,:)=[];  
    final = final';     

      
%% reshape final matrix and create 3d nifti output        
    Z = reshape(final,a,b,c);    
    Vout = V(1);
    Vout.fname = ['GlobalSignalTopography.nii']; %%change output name
    V = spm_write_vol(Vout, Z);

clearvars -except files

cd ..
end

        
    
    