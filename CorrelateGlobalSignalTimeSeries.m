
%% Correlated time-series temporal correlations across various preprocessing pipelines across all subjects
%% Data should be in this format of a main directory with sub-directories of preprocessing pipelines,
%% with each sub-directory containing a folder (s_0001, s_0002, etc.) that has each subjects ROI time-series text file (GlobalSignal.Txt)

    
%%Identify main directory and list each sub-directory in the 'folder' variable


cd Home/MainDirectory
folder = {'Pipeline1' 'Pipeline2' 'Pipeline3' 'Pipeline4'}


for f = 1:length(folder)
 
   %%cd into sub-directory and make a list of all subject folders     
   cd (folder{f})
   files = dir('s_*')
        
        
        
            for s = 1:length(files)
                
                
                for l = 1:length(folder)
                    
                    filename = strcat('Home/MainDirectory',folder{l},'/',files(s).name,'/GlobalSignal.txt');
                    display(files(s).name)
                    
                    ts(:,l,s)=load(filename);             
                    
                end
                
                 corrmat(:,:,s) = corrcoef(ts(:,:,s),'rows','complete');  %calculate correlation coefficients 
                
            end
            

    
    cd ..
    save('GS_ts_correlations.mat','corrmat')
            
    
end             
