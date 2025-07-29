% function Info = RunTypiTarget(name, flavor)
% Oddball/Three Stimulus + Memory task Paradigm
% main script for testing 
% 

sca;
clear;
close all;

% participant number, e.g. 01
name = 'test_RT3';
% choose training for a practice run, choose full to run the full experiment
flavor = 'full';
% which version do you want to run? (image presentation time differs in oddball task)
% version sevenh: 700ms, version fiveh: 500ms 
version = 'sevenh';

%% ---------------------------------------------------------------------
% Add paths and initialize global variables. and test if logfile exists for this subject.
% ---------------------------------------------------------------------
addpath('./Functions');
% addpath('./Easy-TTL-trigger-master');
addpath('./stimuli');
global Info P

%  provides control over random number generation, creating a seed based on the current time
rng("shuffle");

% if experiment crashed/interrupted,
% set this variable to true
crash_restart = false;

% crash_restart allows the experiment to                                  
% continue from the last incomplete trial
% based on the logfile
if crash_restart == true
    new_name = append(name, '_B');
end


%% --------------------------------------------------------------------
% Initiate file names and load Parameters.
% ---------------------------------------------------------------------
P.Flavor = flavor;
P.Version = version;

[P] = Parameters(P);

Info                   = struct;
Info.name              = name;
Info.Logfilename       = ['Logfiles' filesep 'TypT_' flavor '_' name '_logfile.mat'];
Info.DateTime          = {datestr(clock)};
Info.P                 = P;

%% --------------------------------------------------------------------
% Test if logfile exists for this subject, then decide what to do
% ---------------------------------------------------------------------
if crash_restart == false
    isQuit = TestIfLogfileExists(P);

     if isQuit
         CloseAndCleanup(P)
         return
     end

end    
%% --------------------------------------------------------------------
% Run either test or full experiment by determining flavour
% ---------------------------------------------------------------------

% switch flavor
%     case 'training'
%         Info.T_fin = MakeTrainingSequence(P);
% 
%     case 'full'
%         Info.T_fin = MakeTrialSequence(P);
% end

%% --------------------------------------------------------------------
% Define trials
% ---------------------------------------------------------------------
if crash_restart == true
    load(Info.Logfilename);
else
    switch flavor
        case 'training'
            [Info.T_fin] = MakeTrainingSequence(P);
        case 'full'
            [Info.T_fin] = MakeTrialSequence(P);
    end
end


%% ------------------------------------------------------------------------
% Open display
% ------------------------------------------------------------------------

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
% Define the background for the memory task of this experiment
% ------------------------------------------------------------------------
global DefaultScreen
DefaultScreen = Screen('OpenOffscreenWindow', window, P.BgColor);
my_optimal_fixationpoint(DefaultScreen, P.CenterX, P.CenterY, 0.6, [100 100 100], [192 192 192], P.pixperdeg);

global MemScreen
MemScreen = Screen('OpenOffscreenWindow', window, P.BgColor);
tw = RectWidth(Screen('TextBounds',  window, P.mem_responseText));
th = RectHeight(Screen('TextBounds', window, P.mem_responseText));
Screen(MemScreen, 'DrawText', P.mem_responseOld, P.CenterX-P.cueXoffset-0.5*tw, P.myHeight-P.cueYoffset, P.mem_cueColor);
% Screen(DefaultMemScreen, 'DrawText', P.cue_text{Info.P.mem_cueOld}, P.CenterX-P.cueXoffset-0.5*tw, P.myHeight-P.cueYoffset, P.mem_cueColor);
Screen(MemScreen, 'DrawText', P.mem_responseNew, P.CenterX+P.cueXoffset-0.5*tw, P.myHeight-P.cueYoffset, P.mem_cueColor);
% Screen(DefaultMemScreen, 'DrawText', P.cue_text{Info.P.mem_cueNew}, P.CenterX+P.cueXoffset-0.5*tw, P.myHeight-P.cueYoffset ,P.mem_cueColor);
my_optimal_fixationpoint(DefaultScreen, P.CenterX, P.CenterY, 0.6, [100 100 100], [192 192 192], P.pixperdeg);

%% --------------------------------------------------------------------
% Run across trials.
%----------------------------------------------------------------------
% ShowStartScreen(window, P)

% fprintf('\nNow running %d trials:\n\n', length(Info.T));
Info.StartTime = GetSecs;
tic;


% ----- Loop over trials -----
isQuit = false;

if crash_restart == true
    for itrial = (find([Info.T_fin.TrialCompleted], 1, 'last') + 1):length(Info.T_fin)
        % Run the trial
        [Info, isQuit] = OneTrial(itrial);

        if isQuit
            disp('Quit.')
            break
        end

    % Update Info structure.
    Info.T_fin(itrial).TrialCompleted = 1;
    Info.T_fin(itrial).ImgDur = P.ImgDur;
    % Info.T_fin(itrial).participant = name;
    Info.ntrials = itrial;
    Info.tTotal  = toc;
    Info.tFinish = {datestr(clock)};
    Info.T_fin(itrial).participant = name;
    
    save(Info.Logfilename, 'Info');

    end

else
    % Info.file_list_iso_target = {};
    % Info.file_list_iso_nontarget = {};
    Info.files_iso_spread = struct([]);

    for itrial = 1:length(Info.T_fin)
    
        % Run the trial.
        % Priority(double(~P.doSkipSyncTest));
        [Info, isQuit] = OneTrial(itrial);
        % Priority(0);

        if isQuit
            disp('Quit.')
            break
        end

    % Update Info structure.
    Info.T_fin(itrial).TrialCompleted = 1;
    Info.T_fin(itrial).ImgDur = P.ImgDur;
    % Info.T_fin(itrial).participant = name;
    Info.ntrials = itrial;
    Info.tTotal  = toc;
    Info.tFinish = {datestr(clock)};
    Info.T_fin(itrial).participant = name;
    
    save(Info.Logfilename, 'Info');

    end

end


%----------------------------------------------------------------------
% After last trial, close everything and exit.
%----------------------------------------------------------------------
WaitSecs(3);
CloseAndCleanup(P)

%----------------------------------------------------------------------
% Write mat file to csv file
%----------------------------------------------------------------------
filename = ['TypT_', flavor, '_', name, '.csv'];
writetable(struct2table(Info.T_fin), filename);