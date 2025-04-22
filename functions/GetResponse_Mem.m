function [ Report, secs ] = GetResponse(P, timeout)

% timeout determines when to stop polling for responses. 
% timeout gives a value in seconds from NOW.
% if timeout == 0, then function waits until button is pressed.

secs = 0;
Report = [];

now = GetSecs;

if timeout==0
    stop = inf;% no time out, wait forever
else
    stop = now + timeout;
end


while GetSecs < stop
% while Report==0
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown
        if keyCode(P.OldKey)
            Report = 1;
            return
        elseif keyCode(P.NewKey)
            Report = 0;
            return
        elseif keyCode(P.Quitkey)
            Report = 99;
            return;
        end;
        
    end;
    WaitSecs(.01); %It is a good habit not to poll as fast as possible
end;
