%% This script downloads Himawari 8/9 Data from their given FTP server
% you will have to sign up and for their services where they will give you
% a Username and Password in order to access their FTP
% JAXA Website to get your FTP Credentials
% https://www.eorc.jaxa.jp/ptree/faq.html#0103
% created by Denny on 23 Oct 2023.

%% Change Directory of FTP and destination directory
% downloads the .nc files
% In your working directory, there should be this script and 
% himawari_ftp_connect_download.m
% Files will be downloaded into the folder where your script is.

% Define FTP server information
ftpServer = 'ftp.ptree.jaxa.jp';
ftpUser = 'XXX';
ftpPassword = 'XXX';

% creates a new folder and the raw data downloaded is saved there. 
FullFile = './SSTraw';
mkdir(FullFile)

% Connect to the FTP server. FTP stands for File Transfer Protocol
ftpObj = ftp(ftpServer, ftpUser, ftpPassword);

% Change this to specify which month to download in the format of MM.
% Multiple values for multiple months to be downloaded in the loop
MM = {'03'};

for j = 1:length(MM)

% cd to desired path in the ftp
cd(ftpObj, '/pub/himawari/L3/SST/v201_nc4_normal_std_monthly/');

% ### Sea Surface Temperature
%  YYYYMMDDhhmmss-JAXA-L2P_GHRSST-SSTskin-Hnn_AHI-vVER-v02.0-fvFVER.nc
% 
%  where YYYY: 4-digit year of observation start time (timeline);
%        MM: 2-digit month of timeline;
%        DD: 2-digit day of timeline;
%        hh: 2-digit hour of timeline;
%        mm: 2-digit minutes of timeline;
%        ss: 2-digit seconds (fixed to "00");
%        nn: 2-digit number of Himawari satellite;
%          08: Himawari-8
%          09: Himawari-9
%        VER: algorithm version; and
%        FVER: file version;.
% H09_20240101_0000_1MSST201_FLDK.06001_06001.nc

    try    
    % CHANGE the year in H09_YYYY to the year that you want.
    files_to_download_date = ['H09_2024',MM{j},'01_0000']; 
    files_to_download_end = '_1MSST201_FLDK.06001_06001.nc';
    filename=[files_to_download_date,files_to_download_end];
    
    mget(ftpObj,filename,FullFile);

    catch
        fprintf('Error reading file %s\n', filename);
        continue;
    end


end



fprintf('Download Complete\n')
