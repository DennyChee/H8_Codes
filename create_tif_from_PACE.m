%% Read NASA PACE NetCDF data and saves the data as a tif file. 
% PACE OCI data downloaded from https://search.earthdata.nasa.gov/search?portal=obdaac
% account creation is needed. 
% Created by Denny. Updated on 3rd September.

%%
clear

% In your working directory, there should be this script, and a data
% folder. E.g. "WORKING DIRECTORY"/Chlorophyll_a
% This script should be saved inside WORKING DIRECTORY. 
% Your data should be inside Chlorophyl_a
% this is a relative file path. the "dot" refers to the current folder you
% have opened in MatLab, which can be seen on the left (if you did not
% change your matlab layout.

FullFile = './Chlorophyll-A';

% this creates a struct variable that consists of the filenames constrained
% by 'PACE*MO*'.
% * are wildcards. meaning matlab will match and read all the files that
% only have "PACE_XXXXX_MO_XXX". This is useful as the filenames are
% different only in the dates. 
D = dir(fullfile(FullFile,'PACE*MO*'));


% this loops through the struct to read through all the filenames
for i = 1:length(D)

inFile = D(i).name;                     % indexes the filename
filetoread = ([FullFile,'/',inFile]);   % creates the full filepath
date = D(i).name(10:15);                % indexes the dates of the file being read

chlor_a = ncread(filetoread,'chlor_a'); % saves the variables from the nc file as matrices
lat=ncread(filetoread,'lat');           % ncdisp("Filename") in command window to see all variables.
lon=ncread(filetoread,'lon');
palette=ncread(filetoread,'palette');

chlor_a = flipud(rot90(chlor_a,1));    % flips and rotates the matrices for geotiff writing

% Define the referencing object using georefcells for geographic data.
% Creates the geotiff.
R = georefcells([min(lat) max(lat)], [min(lon) max(lon)], size(chlor_a), ...
                'ColumnsStartFrom', 'north', ...
                'RowsStartFrom', 'west');

% Specify the CRS (Coordinate Reference System) for geographic coordinates
crsCode = 4326;

filename = (['Chl_a_',date,'.tif']);        % saves the tiff based on date indexed on line 32.
savedirectory = ([FullFile,'/',filename]);  % creates directory to save the file.

% Write the GeoTIFF file with geographic referencing
geotiffwrite(savedirectory, chlor_a, R, 'CoordRefSysCode', crsCode);
% if you are saving another variable, you will have to change chlor_a to
% the variable of your choice.

% output dispplay
disp(['Tif file saved as ', filename]);

end

disp('Script finished running');