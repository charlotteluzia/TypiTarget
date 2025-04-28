function [P] = Parameters(P)
%% -----------------------------------------------------------------------
% Are we running on the computer in the testing room?
% If yes, set desired display parameters.
% If not, use current display settings.
% ------------------------------------------------------------------------
P.isEEG          = 0; % if==1: send EEG triggers
P.doSkipSyncTest = 1; % if==1: no synctest and normal priority (this is for testing) 


%% -----------------------------------------------------------------------
% Make system-specific adjustments
%  -----------------------------------------------------------------------
P.thismachine = get_machine;

if strcmpi(P.thismachine, '') % EEG testing room
    P.PresentScreen = 2;
    P.myWidth       = 1280;
    P.myHeight      = 1024;
    P.myRate        = 100;
    P.ImagePath     = 'C:\Dokumente und Einstellungen\matlab\Eigene Dateien\Charlotte\TypiTarget\stimuli\';  
            
    
else        
    switch P.thismachine
        case 'DESKTOP-KPH292U'
            P.ImagePath     = 'C:\Users\User\MATLAB\TypiTarget\stimuli\';             
            P.PresentScreen = 2;
            P.myWidth       = 1920;
            P.myHeight      = 1080;
            P.myRate        = 60;

    end
       
end


%% -----------------------------------------------------------------------
% Parameters of the display.
% Calculate size of a pixel in visual angles.
% ------------------------------------------------------------------------
P.CenterX      = P.myWidth/2;
P.CenterY      = P.myHeight/2;

P.res   = [P.myWidth P.myHeight]; % monitor resolution
P.sz    = [36 27];                % monitor size in cm
P.vdist = [55];                   % distance of observer from monitor
[P.pixperdeg, P.degperpix] = VisAng(P);
P.pixperdeg = mean(P.pixperdeg);
P.degperpix = mean(P.degperpix);

P.BgColor    = [192 192 192]; % 0 * 255;
P.TextColor  = [100 100 100];
P.StuffColor = [50 50 50]; % Color for everything on the display except targets, e.g. fixation mark.

% Present instructional cues in the lower corners.
P.cueXoffset = 300;
P.cueYoffset = 100;
P.cue_text   = {'[Alt]', '[Neu]'};


%% -----------------------------------------------------------------------
% Response keys
%  -----------------------------------------------------------------------
KbName('UnifyKeyNames');    
P.Quitkey = KbName('ESCAPE');

P.NoKey   = KbName('f');
P.YesKey  = KbName('j');

P.CertainOldKey = KbName('d');
P.OldKey = KbName('f');
P.NewKey = KbName('j');
P.CertainNewKey = KbName('k');
P.ResponseKeys = {KbName('d'); KbName('f'); KbName('j'); KbName('k')};


%% -----------------------------------------------------------------------
% Parameters of categorization and memory task
%  -----------------------------------------------------------------------
P.cat_text = {'[Press j if the image shows a supermarket]'}; % count occurences of supermarkets by pressing button
P.cat_cues = {'[f]', '[j]'};
% P.cat_responseText = {'[no]', '[yes]'};
% P.cat_responseText = {'[nein]', '[ja]'};

% present question above image, cues in lower corners
% P.cat_textLocation = ;
% P.cat_cuesLocation =

P.mem_cues = {'[d]', '[f]', '[j]', '[k]'};
P.mem_responseText = {'[certainly old]', '[rather old]', '[rather new]', '[certainly new]'};
% P.mem_responseText = {'[sicher alt]', '[eher alt]', '[eher neu]', '[sicher neu]'};

%P.mem_location

%% -----------------------------------------------------------------------
% Parameters of the procedure
%  -----------------------------------------------------------------------
P.nTrials = 100;

% Timing parameters.
P.ImageDuration = 0.900;
P.setISI        = 1.500;
P.minISI        = 1.000;
P.maxISI        = 2.000;

%% -----------------------------------------------------------------------
% Images
%  -----------------------------------------------------------------------
P.prop_typ = 0.6;  % proportion of typical images of 100 trials
P.prop_untyp = 0.2;
P.prop_target = 0.1;
P.prop_nontarget = 0.1;



%% -----------------------------------------------------------------------
% Load table with struct specifications: image name, typicality, category
%  -----------------------------------------------------------------------
table_img        = readtable('stimuli_info_140.xlsx');
images_bedroom    = table_img(strcmp(table_img.category, 'bedrooms'),:);
images_kitchen    = table_img(strcmp(table_img.category, 'kitchens'),:);
images_livingroom = table_img(strcmp(table_img.category, 'living rooms'),:);
%table_target     = readtable('stimuli_info_target.xlsx');
%table_nontarget  = readtable('stimuli_info_nontarget.xlsx');
%match = wildcardPattern + '/';
%table_bedroom.stimulus = erase(table_bedroom.stimulus, match);



