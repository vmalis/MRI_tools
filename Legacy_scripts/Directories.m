%%% Making Directories

cd ~/Desktop/DATA2


 mkdir('Seniors')
 mkdir('Junior')



%% Generating names of the folders to be processed


%% SENIORS

    for str = {'US'}    %Put initials of senior subjects here
     
        
        
        fname1 = sprintf('%s',str{1}); 
        mkdir('Seniors',fname1);
        
        fname2 = sprintf('Seniors/%s',str{1}); 
        fname3 = sprintf('Seniors/%s/%s_IDEAL',str{1},str{1});

        
            for str2 = {'DTI','EIGENVECTOR','FS','FS_MASKED','FS_MASKED_BC', 'IDEAL','MASK','RESULTS','SLICER_RESULTS','UTE','UTE_SEG_GL','UTE_SEG_GM','UTE_SEG_SOL','WS', 'WS_MASKED', 'WS_MASKED_BC','WS_SEG_GL','WS_SEG_GM','WS_SEG_SOL'}
           
            fname5 = sprintf('%s_%s',str{1},str2{1}); 
       
            mkdir(fname2,fname5);
       
            end
            
        mkdir(fname3,'FS');
        mkdir(fname3,'WS');
     
    
    end
    
%% Junior

 for str = {'VM','RC'}      %Put initials of junior subjects here
        
        fname1 = sprintf('%s',str{1}); 
        mkdir('Junior',fname1);
        
        fname2 = sprintf('Junior/%s',str{1}); 
        fname3 = sprintf('Junior/%s/%s_IDEAL',str{1},str{1});
        
            for str2 = {'DTI','EIGENVECTOR','FS','FS_MASKED','FS_MASKED_BC', 'IDEAL','MASK','RESULTS','SLICER_RESULTS','UTE','UTE_SEG_GL','UTE_SEG_GM','UTE_SEG_SOL','WS', 'WS_MASKED', 'WS_MASKED_BC','WS_SEG_GL','WS_SEG_GM','WS_SEG_SOL'}
           
            fname5 = sprintf('%s_%s',str{1},str2{1}); 
       
            mkdir(fname2,fname5);
       
            end
            
        mkdir(fname3,'FS');
        mkdir(fname3,'WS');
       
    
    end