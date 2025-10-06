function [Report, secs] = GetResponse_Mem(P)


global Info

secs = 0;
now = GetSecs;
Report = 0;
isQuit = 0;

% wait until response is given which is necessary otherwise code does not
% continue
while Report == 0
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown
        if keyCode(P.CertainOldKey)
            Report = 1;
            if P.isEEG
                Trigger = P.UseTriggers(2, Info.T_fin(itrial).task, Info.T_fin(itrial).category);
                SendTrigger(Trigger, P.TriggerDuration)
            end
            return
            
        elseif keyCode (P.OldKey)
            Report = 2;
            if P.isEEG
                Trigger = P.UseTriggers(2, Info.T_fin(itrial).task, Info.T_fin(itrial).category);
                SendTrigger(Trigger, P.TriggerDuration)
            end
            return

        elseif keyCode (P.NewKey)
            Report = 3;
            if P.isEEG
                Trigger = P.UseTriggers(2, Info.T_fin(itrial).task, Info.T_fin(itrial).category);
                SendTrigger(Trigger, P.TriggerDuration)
            end
            return

        elseif keyCode(P.CertainNewKey)
            Report = 4;
            if P.isEEG
                Trigger = P.UseTriggers(2, Info.T_fin(itrial).task, Info.T_fin(itrial).category);
                SendTrigger(Trigger, P.TriggerDuration)
            end
            return

        elseif keyCode(P.Quitkey)
            Report = 99;
            return;
        end
        
    end
    WaitSecs(.01); %It is a good habit not to poll as fast as possible
end
