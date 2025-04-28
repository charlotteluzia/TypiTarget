% Oddball/Three Stimulus + Memory task Paradigm
% main script for testing 
% 

sca;
clear;
close all;

% participant number, e.g. 01
name = '';

%% ---------------------------------------------------------------------
% Add paths and initialize global variables. and test if logfile exists for this subject.
% ---------------------------------------------------------------------
addpath('./Functions');
% addpath('./Easy-TTL-trigger-master');
addpath('./stimuli');
global Info P


%% --------------------------------------------------------------------
% Initiate file names and load Parameters.
% ---------------------------------------------------------------------
[P] = Parameters(P);

Info                   = struct;
Info.name              = name;
Info.Logfilename       = ['Logfiles' filesep 'TypT' name '_logfile.mat'];
Info.DateTime          = {datestr(clock)};
Info.P                 = P;

%% --------------------------------------------------------------------
% Define parameters of block number 
% ---------------------------------------------------------------------
cat_num_block = 1;
rep_num = 1;

%% --------------------------------------------------------------------
% Define trials.
% ---------------------------------------------------------------------
% T struct for each room category, with info about filename and room
% category

for itrial = 1:length(Info.T)
    iImage = ImageIdx(Info.T(itrial).stimulus_idx);
    Info.T(itrial).filename       = strtrim(AvailImageNames(iImage,:));
    Info.T(itrial).category_name  = strtrim(AvailImageCategorNames(iImage,:));
    
end

%% ------------------------------------------------------------------------
% Open trigger port.
% Open display.
% ------------------------------------------------------------------------
if P.isEEG
    OpenTriggerPort;
    SendTrigger(P.TriggerStartRecording, P.TriggerDuration);
end

global window
Screen('Preference', 'SkipSyncTests', P.doSkipSyncTest);
Screen('Resolution', P.PresentScreen, P.myWidth, P.myHeight, P.myRate);
% oldRes=SetResolution(0,P.myWidth, P.myHeight, P.myRate);
window = Screen('OpenWindow', P.PresentScreen, P.BgColor);
Screen(window, 'TextSize', 24);

P.White        = WhiteIndex(P.PresentScreen);
P.Black        = BlackIndex(P.PresentScreen);
P.FrDuration   = (Screen( window, 'GetFlipInterval')); % in ms


%% ------------------------------------------------------------------------
% Define the default background of this experiment.
% ------------------------------------------------------------------------
global DefaultScreen
DefaultScreen = Screen( 'OpenOffscreenWindow', window, P.BgColor );
% tw = RectWidth(Screen('TextBounds',  window, P.cue_text{Info.P.ResponseMapping(1)}));
%th = RectHeight(Screen('TextBounds', window, P.cue_text{Info.P.ResponseMapping(1)}));
%Screen(DefaultScreen, 'DrawText', P.cue_text{Info.P.ResponseMapping(1)}, P.CenterX-P.cueXoffset-0.5*tw, P.myHeight-P.cueYoffset, [180, 180, 180]);
%Screen(DefaultScreen, 'DrawText', P.cue_text{Info.P.ResponseMapping(2)}, P.CenterX+P.cueXoffset-0.5*tw, P.myHeight-P.cueYoffset, [180, 180, 180]);
Screen(DefaultScreen,'DrawLine',[255 0 0], P.CenterX-10,P.CenterY,P.CenterX+10,P.CenterY,2);
Screen(DefaultScreen,'DrawLine',[255 0 0], P.CenterX,P.CenterY-10,P.CenterX,P.CenterY+10,2);
%my_fixationpoint(DefaultScreen, P.CenterX, P.CenterY, 5, [100 100 100]);


%% --------------------------------------------------------------------
% Run across trials.
%----------------------------------------------------------------------
% ShowStartScreen(window, P)

% fprintf('\nNow running %d trials:\n\n', length(Info.T));
Info.StartTime = GetSecs;
tic;


% ----- Loop over trials -----
% isQuit = false;

for t = 1:1%length(Info.T)
    
    % Run the trial.
    Priority(double(~P.doSkipSyncTest));
    [Info] = OneTrial(t);
    Priority(0);

end


%----------------------------------------------------------------------
% After last trial, close everything and exit.
%----------------------------------------------------------------------
WaitSecs(3);
CloseAndCleanup(P)

