function [Report, secs] = GetResponse_Mem(P)

% timeout determines when to stop polling for responses. 
% timeout gives a value in seconds from NOW.
% if timeout == 0, then function waits until button is pressed.

secs = 0;
now = GetSecs;
Report = 0;
isQuit = 0;


% if timeout==0
%     stop = inf;% no time out, wait forever
% else
%     stop = now + timeout;
% end


while Report == 0  % GetSecs < stop
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown
        if keyCode(P.CertainOldKey)
            Report = 1;
            return
        elseif keyCode (P.OldKey)
            Report = 2;
            return
        elseif keyCode (P.NewKey)
            Report = 3;
            return
        elseif keyCode(P.CertainNewKey)
            Report = 4;
            return
        elseif keyCode(P.Quitkey)
            Report = 99;
            return;
        end
        
    end
    WaitSecs(.01); %It is a good habit not to poll as fast as possible
end
