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

%%
switch P.Flavor
    case 'training'
        P.doFeedback = 1;
        P.FeedbackDuration = 0.2;
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
P.mem_cueColor = [180 180 180];

% Present instructional cues in the lower corners.
P.cueXoffset = 300;
P.cueYoffset = 100;
P.mem_cueCertainOld = {'[sicher alt]'};
P.mem_cueOld        = {'[eher alt]'};
P.mem_cueNew        = {'[eher neu]'};
P.mem_cueCertainNew = {'[sicher neu]'};


%% -----------------------------------------------------------------------
% Response keys
%  -----------------------------------------------------------------------
KbName('UnifyKeyNames');    
P.Quitkey = KbName('ESCAPE');

P.YesKey  = KbName('j');

P.CertainOldKey = KbName('d');
P.OldKey = KbName('f');
P.NewKey = KbName('j');
P.CertainNewKey = KbName('k');
P.ResponseKeys = {KbName('d'); KbName('f'); KbName('j'); KbName('k')};


%% -----------------------------------------------------------------------
% Parameters of categorization and memory task
%  -----------------------------------------------------------------------
% P.cat_text = {'[Press j if the image shows a supermarket]'}; % count occurences of supermarkets by pressing button
% P.cat_cues = {'[f]', '[j]'};
% P.cat_responseText = {'[no]', '[yes]'};
% P.cat_responseText = {'[nein]', '[ja]'};


P.mem_cues = {'[d]', '[f]', '[j]', '[k]'};
P.mem_responseText = {'[sicher alt]', '[eher alt]', '[eher neu]', '[sicher neu]'};
% P.mem_responseText = {'[certainly old]', '[rather old]', '[rather new]', '[certainly new]'};

%P.mem_location

%% -----------------------------------------------------------------------
% Parameters of the procedure
%  -----------------------------------------------------------------------
P.BreakAfternTrials = (P.n_typ + P.n_untyp + P.n_target + P.n_nontarget)*2 - (P.n_target + P.n_nontarget);


% Timing parameters.
P.ImgDur  = 0.700;
P.ISI_Dur = 1.500;

%% -----------------------------------------------------------------------
% Images
%  -----------------------------------------------------------------------
P.prop_typ = 0.6;  % proportion of typical images of 100 trials
P.prop_untyp = 0.2;
P.prop_target = 0.1;
P.prop_nontarget = 0.1;

switch P.Flavor
    case 'training'
        P.scene_categories = {''};
        P.nblocks_per_category = 1;
        P.n_trials_per_block = 20;

        P.stim_140       = 'stimuli_training.xlsx';
        P.stim_target    = 'stimuli_training_target.xlsx';
        P.stim_nontarget = 'stimuli_training_nontarget.xlsx';

        P.n_standard  = ceil((P.prop_typ + P.prop_untyp) * P.ntrial_per_block);
        P.n_target    = ceil(P.prop_target    * P.n_trials_per_block);
        P.n_nontarget = ceil(P.prop_nontarget * P.n_trials_per_block);


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


end










