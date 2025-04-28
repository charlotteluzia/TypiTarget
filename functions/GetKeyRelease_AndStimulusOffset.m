function [Report, secs, isInvalidResponse] = GetKeyRelease_AndStimulusOffset(toffset)

global window Info P DefaultScreen;

secs              = NaN;
Report            = NaN;
isInvalidResponse = 0;
isQuit            = 0;


%% At the beginning, make sure that both buttons are currently pressed. If
% not, wait for stimulus offset and return.
[keyIsDown,secs,keyCode] = KbCheck;
if keyCode(P.LeftKey)==0 || keyCode(P.RightKey)==0
    isInvalidResponse = 1;
    display('Invalid')
    StimulusOffset(toffset)
    return    
end

%% If both buttons are pressed, start monitoring for button releases. Turn
% off the image when the time comes.
while 2+2==4
    [keyIsDown,secs,keyCode] = KbCheck;
    
    if ~keyCode(P.LeftKey) && keyCode(P.RightKey)
        Report = 1;% Send trigger.
        
        if P.isEEG
            Trigger = P.UseTriggers(Info.T(t).presentation_no, Info.T(t).category_index, 3);
            SendTrigger(Trigger, P.TriggerDuration);
        end
        
        StimulusOffset(toffset)
        return
    elseif  keyCode(P.LeftKey) && ~keyCode(P.RightKey)
        Report = 2;
        
        if P.isEEG
            Trigger = P.UseTriggers(Info.T(t).presentation_no, Info.T(t).category_index, 3);
            SendTrigger(Trigger, P.TriggerDuration);
        end
        
        StimulusOffset(toffset)
        return
    elseif keyCode(P.Quitkey)
        Report = 99;
        return;
    end;
    
    if GetSecs >= toffset
        StimulusOffset(0)
    end
    
    WaitSecs(.005); %It is a good habit not to poll as fast as possible
end;
    
    
function StimulusOffset(t)
global window DefaultScreen;
Screen('DrawTexture', window, DefaultScreen);
[VBLTimestamp, t_imageoffset] = Screen('Flip', window, t);
