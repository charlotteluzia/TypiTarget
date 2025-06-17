function [ Report, secs ] = GetResponse_Cat(P, timeout)

% timeout determines when to stop polling for responses. 
% timeout gives a value in seconds from NOW.
% if timeout == 0, then function waits until button is pressed.

secs = 0;
now = GetSecs;
Report = 0;
isQuit = 0;

if timeout==0
    stop = 2000;
else
    stop = now + timeout;
end

while GetSecs < stop
% while Report==0
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown
        if keyCode(P.NewKey)
            Report = 1;
            return
        elseif keyCode(P.Quitkey)
            Report = 99;
            return;
        end;
    else 
        Report = 0; % no behavioural response if nontarget or standard is shown
    end;
    WaitSecs(.01); %It is a good habit not to poll as fast as possible
end;
