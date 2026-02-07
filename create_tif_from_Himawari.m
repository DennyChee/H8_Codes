%% Reads Himawari-8/9 netcdf Sea Surface Temperature data and creates a tif file
% Download Himawari data using himawari_ftp_connect_download.m
% Created by Denny. Updated on 3rd Sep 2024.

%%
clear

% In your working directory, there should be this script and the netcdf
% files downloaded.
% ./ is a relative file path. the "dot" refers to the current folder you
% have opened in MatLab, which can be seen on the left (if you did not
% change your matlab layout.
FullFile = './SSTraw';

% this creates a struct variable that consists of the filenames constrained
% by 'H09*'.
% * are wildcards. meaning matlab will match and read all the files that
% only have "H09_XXX". This is useful as the filenames are
% different only in the dates. 
D = dir(fullfile(FullFile,'H09*.nc'));

% this loops through the struct to read through all the filenames
for i = 1:length(D)

inFile = D(i).name;     % indexes the filename
date = D(i).name(5:12); % indexes the dates from the filename
filetoread = ([FullFile,'/',inFile]);   % creates the filepath

% saves the variables from the nc file as matrices
% ncdisp("Filename") in command window to see all variables.
% -273.15 for Celsius
sst = ncread(filetoread,'sea_surface_temperature')-273.15; 
lat=ncread(filetoread,'lat');                              
lon=ncread(filetoread,'lon');

sst = sst(1:5001,:);  % crop out values beyond 180 deg lon.
sst = flipud(rot90(sst,1)); % Flip and rotate for geocoding

% Define the referencing object using georefcells for geographic data
% hardcoded the lon boundaries
R = georefcells([min(lat) max(lat)], [80 180], size(sst), ...
                'ColumnsStartFrom', 'north', ...
                'RowsStartFrom', 'west');

% Specify the CRS (Coordinate Reference System) for geographic coordinates
crsCode = 4326;

% Specify the filename
filename = (['sst_', date, '.tif']);
savedirectory = (['./',filename]);  % creates directory to save the file.


% Write the GeoTIFF file with geographic referencing
geotiffwrite(savedirectory, sst, R, 'CoordRefSysCode', crsCode);

% output dispplay
disp(['Tif file saved as ', filename]);

end

disp('Script finished running');