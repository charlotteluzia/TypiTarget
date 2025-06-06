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
% Define trials.
% ---------------------------------------------------------------------
[Info.TO, Info.TM] = MakeTrialSequence(P);



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


%% --------------------------------------------------------------------
% Run across trials.
%----------------------------------------------------------------------
% ShowStartScreen(window, P)

% fprintf('\nNow running %d trials:\n\n', length(Info.T));
Info.StartTime = GetSecs;
tic;


% ----- Loop over trials -----
% isQuit = false;
Exp = Info.TO + Info.TM;
for itrial = 1:length(T_final)
    
    % Run the trial.
    [Info] = OneTrial(itrial);



    % Update Info structure.
    Info.T(itrial).TrialCompleted = 1;
    Info.T(itrial).ImgDur = P.ImgDuration;
    Info.ntrials = t;
    Info.tTotal  = toc;
    Info.tFinish = {datestr(clock)};
    
    save(Info.Logfilename, 'Info');

end


%----------------------------------------------------------------------
% After last trial, close everything and exit.
%----------------------------------------------------------------------
WaitSecs(3);
CloseAndCleanup(P)

