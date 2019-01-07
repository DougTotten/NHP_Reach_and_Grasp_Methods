function [store_path]=R2G_Initialize_Storage(monk_name)

% Get directory this function is in
fullpath=mfilename('fullpath');
path_indx=strfind(fullpath,'Matlab_Functions');
root_path=fullpath(1:path_indx-1);

% Make a folder that is Saved Session\Monkeys Name\matlab_CO\date and time
parent_folder=strcat(root_path,'Saved_Sessions\',monk_name,'\matlab_R2G');
right_now=clock;

folder_name=sprintf('%s_%s_%s Time %s_%s', num2str(right_now(1)),num2str(right_now(2)),num2str(right_now(3)),num2str(right_now(4)),num2str(right_now(5)));
mkdir(parent_folder,folder_name);
store_path=strcat(parent_folder,'\',folder_name);