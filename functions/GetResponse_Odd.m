function [Report, reactionTime] = GetResponse_Odd(imageOnset, toffset, ISI)
% function [Report, secs] = GetResponse_Odd(imageOnset, toffset)

% timeout determines when to stop polling for responses. 
% timeout gives a value in seconds from NOW.
% if timeout == 0, then function waits until button is pressed.

global Info P window DefaultScreen;


secs = 0;
now = GetSecs;
Report = 0;
reactionTime = NaN;
isQuit = 0;

KbQueueCreate();
KbQueueStart();

% timeout = P.ISI_Dur;
timeout = ISI;
stop = timeout + toffset;

while GetSecs < toffset
    % nothing, just wait
end

Screen('DrawTexture', window, DefaultScreen);
Screen('Flip', window); 

while GetSecs < stop

    [pressed, firstPress] = KbQueueCheck;
    
    if pressed
        keyIdx = find(firstPress);
        keyName = KbName(keyIdx(1));
        rt = firstPress(keyIdx(1));
        
         % Check key
            if iscell(keyName) % in case multiple keys
                keyName = keyName{1};
            end

            if strcmpi(keyName, 'space')
                Report = 1;
                reactionTime = rt;
                if P.isEEG
                Trigger = P.UseTriggers(2, 2, Info.T_fin(itrial).cond_idx, Info.T_fin(itrial).category_idx);
                SendTrigger(Trigger, P.TriggerDuration)
                end
                return;
            elseif strcmpi(keyName, 'ESCAPE')
                Report = 99;
                reactionTime = rt;
                return;
            end
    elseif ~pressed
        reactionTime = GetSecs;
    end
end
WaitSecs(.01); %It is a good habit not to poll as fast as possible
% Clean up
KbQueueRelease();
end

    
% end
%     if keyIsDown
% 
%         if keyCode == P.YesKey %keyCode(P.YesKey)
%             Report = 1;
%             secs = keyTime;
%             StimulusOffset(toffset);
%             if P.isEEG
%                 Trigger = P.UseTriggers(2, Info.T_fin(itrial).task, Info.T_fin(itrial).category);
%                 SendTrigger(Trigger, P.TriggerDuration)
%             end
%             return
%             break;
%         elseif keyCode == P.Quitkey %keyCode(P.Quitkey)
%             Report = 99;
%             secs = keyTime;
%             StimulusOffset(toffset);
%             break;
%             return
%         end
%     end
%  end
%     elseif ~keyIsDown
%         Report = 0; % no behavioural response if nontarget or standard image is shown
%         if P.isEEG
%                 Trigger = P.UseTriggers(2, Info.T_fin(itrial).cond, Info.T_fin(itrial).category);
%                 SendTrigger(Trigger, P.TriggerDuration)
% 
% 
%         StimulusOffset(toffset);
% 
% 
%     if GetSecs >= toffset
%     if ((secs - now) > timeout)
%         timedout = true;
%         StimulusOffset(0);
% 
%     end
% 
%     KbQueueRelease();
%     WaitSecs(.01); %It is a good habit not to poll as fast as possible
% 
% 
% if isnan(Report)
%     Report = 0;
% end
% 
% end
% 
% return
% end


% function StimulusOffset(t)
% global window DefaultScreen;
% Screen('DrawTexture', window, DefaultScreen);
% [VBLTimestamp, t_imageoffset] = Screen('Flip', window, t);
