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
    P.ImagePath     = 'C:\Dokumente und Einstellungen\matlab\Eigene Dateien\Charlotte\TypiBall\stimuli\';  
            
    
else        
    switch P.thismachine
        case 'DESKTOP-KPH292U'
            P.ImagePath     = 'C:\Users\User\MATLAB\TypiTarget\TypiBall\stimuli\';             
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
P.vdist = [55];                   % distance of oberver from monitor
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
P.cat_text = {'[Is this a ?]'};
P.cat_cues = {'[f]', '[j]'};
P.cat_responseText = {'[no]', '[yes]'};
% P.cat_responseText = {'[nein]', '[ja]'};

% present question above image, cues in lower corners
% P.cat_textLocation = ;
% P.cat_cuesLocation =

P.mem_cues = {'[d]', '[f]', '[j]', '[k]'};
P.mem_responseText = {'[certainly old]', '[rather old]', '[rather new]', '[certainly new]'};
% P.mem_responseText = {'[sicher alt]', '[eher alt]', '[eher neu]', '[sicher neu]'};


%% -----------------------------------------------------------------------
% Parameters of the procedure
%  -----------------------------------------------------------------------
P.BreakAfternTrials = 100;

% Timing parameters.
P.ImageDuration = 0.900;
P.minISI        = 1.000;
P.maxISI        = 2.000;

