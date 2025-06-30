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

if strcmpi(P.thismachine, '') % behavioral lab
    P.PresentScreen = 2;
    P.myWidth       = 1280;
    P.myHeight      = 1024;
    P.myRate        = 100;
    P.ImagePath     = 'C:\Users\User\MATLAB\TypiTarget\stimuli\';
            
    
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

%%
switch P.Flavor
    case 'training'
        P.doFeedback = 1;
        P.FeedbackDuration = 0.3;
    otherwise
        P.doFeedback = 0;
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
% P.screen.viewdist = 86; % used to be 55? why?
[P.pixperdeg, P.degperpix] = VisAng(P);
P.pixperdeg = mean(P.pixperdeg);
P.degperpix = mean(P.degperpix);

P.BgColor    = [192 192 192]; % 0 * 255;
P.TextColor  = [100 100 100];
P.StuffColor = [50 50 50]; % Color for everything on the display except targets, e.g. fixation mark.
P.mem_cueColor = [98 101 103]; %[180 180 180];

% Present instructional cues in the lower corners.
P.cueXoffset = 300;
P.cueYoffset = 100;
P.mem_cueCertainOld = ['sicher alt'];
P.mem_cueOld        = ['eher alt'];
P.mem_cueNew        = ['eher neu'];
P.mem_cueCertainNew = ['sicher neu'];


%% -----------------------------------------------------------------------
% Response keys
%  -----------------------------------------------------------------------
KbName('UnifyKeyNames');    
P.Quitkey = KbName('ESCAPE');

P.YesKey  = KbName('space');

P.CertainOldKey = KbName('d');
P.OldKey = KbName('f');
P.NewKey = KbName('j');
P.CertainNewKey = KbName('k');
P.ResponseKeys = {KbName('d'); KbName('f'); KbName('j'); KbName('k')};


%% -----------------------------------------------------------------------
% Parameters of categorization and memory task
%  -----------------------------------------------------------------------

P.mem_cues = {'[d]', '[f]', '[j]', '[k]'};
P.mem_responseText = ['[sicher alt]', '[sicher neu]']; % , '[eher alt]', '[eher neu]'
% P.mem_responseText = {'[certainly old]', '[rather old]', '[rather new]', '[certainly new]'};

%P.mem_location


%% -----------------------------------------------------------------------
% Images
%  -----------------------------------------------------------------------
P.prop_typ       = 0.4;  % proportion of typical images
P.prop_untyp     = 0.2;  % proportion of untypical images
P.prop_target    = 0.2;  % proportion of target images
P.prop_nontarget = 0.2;  % proportion of nontarget images

switch P.Flavor
    case 'training'
        P.scene_categories = {'standard'};
        P.nblocks_per_category = 1;
        P.n_trials_per_block = 20;

        P.stim_140       = 'stimuli_training_standard.xlsx';
        P.stim_target    = 'stimuli_training_target.xlsx';
        P.stim_nontarget = 'stimuli_training_nontarget.xlsx';

        P.n_standard  = ceil((P.prop_typ + P.prop_untyp) * P.n_trials_per_block);
        P.n_target    = ceil(P.prop_target    * P.n_trials_per_block);
        P.n_nontarget = ceil(P.prop_nontarget * P.n_trials_per_block);

        P.BreakAfternTrials = (P.n_standard)*2 + (P.n_target + P.n_nontarget);



    otherwise
        P.scene_categories = {'kitchens', 'bedrooms', 'living_rooms'};
        P.nblocks_per_category = 2;
        P.n_trials_per_block = 20;

        P.stim_140       = 'stimuli_info_140.xlsx';
        P.stim_target    = 'stimuli_info_target.xlsx';
        P.stim_nontarget = 'stimuli_info_nontarget.xlsx';

        P.n_typ       = ceil(P.prop_typ       * P.n_trials_per_block);
        P.n_untyp     = ceil(P.prop_untyp     * P.n_trials_per_block);
        P.n_target    = ceil(P.prop_target    * P.n_trials_per_block);
        P.n_nontarget = ceil(P.prop_nontarget * P.n_trials_per_block);

        P.BreakAfternTrials = (P.n_typ + P.n_untyp)*3 + (P.n_target + P.n_nontarget);


end

%% -----------------------------------------------------------------------
% Parameters of the procedure
%  -----------------------------------------------------------------------
% Timing parameters. Two different versions, one with higher and one with
% lower presentation time of image
switch P.version
    case 'sevenh'
        P.ImgDur  = 0.7;
    case 'fiveh'
        P.ImgDur  = 0.5;
end

P.ISI_Dur = 1.5;










