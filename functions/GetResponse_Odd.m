function [ Report, secs ] = GetResponse_Odd(toffset)

% timeout determines when to stop polling for responses. 
% timeout gives a value in seconds from NOW.
% if timeout == 0, then function waits until button is pressed.

global window Info P DefaultScreen;

secs = 0;
now = GetSecs;
Report = NaN;
isQuit = 0;

timeout=3.000;
stop = now + timeout;


while GetSecs < stop
% while Report==0
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown
        if keyCode(P.YesKey)
            Report = 1;
            StimulusOffset(toffset);
            return
        elseif keyCode(P.Quitkey)
            Report = 99;
            StimulusOffset(toffset);
            return;
        end
    else 
        Report = 0; % no behavioural response if nontarget or standard image is shown
    end;


    if GetSecs >= toffset
        StimulusOffset(0);
    end

    WaitSecs(.01); %It is a good habit not to poll as fast as possible
end;

function StimulusOffset(t)
global window DefaultScreen;
Screen('DrawTexture', window, DefaultScreen);
[VBLTimestamp, t_imageoffset] = Screen('Flip', window, t);
