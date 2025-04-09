function Info = RunCRT(name)
% Continuous Recognition Test.
% Use RunCRT('test') for testing. Running "test" multiple times will NOT
% start new runs each time, it will always start with a first run. All
% other names will, when run more than once, present only images that have
% not been used on that name before.
%
% flavor: determines what to use the experiment for. Options:
%   -training: runs CRT with a different set of scenes. No logfile is generated.
%   -crt: crt paradigm/main experiment
%   -rectest: delayed recognition test with old and entirely new scenes.


%  name = 'testb';


%% ---------------------------------------------------------------------
% Add paths and initialize global variables. and test if logfile exists for this subject.
% ---------------------------------------------------------------------
addpath('./Functions');
% addpath('./TriggerPorts');
global Info P

% Reset the seed of the random number generator.
RandStream('mcg16807','Seed',0); % works with old matlab %rng('shuffle'); %Requires new matlab

%% --------------------------------------------------------------------
% Initiate file names and load Parameters.
% ---------------------------------------------------------------------
[P] = Parameters(P);

Info                   = struct;
Info.P                 = P;


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

