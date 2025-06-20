function isQuit = WaitUntilBothButtonsArePressed(P)

stop = inf;% no time out, wait forever

while GetSecs < stop
    [keyIsDown,secs,keyCode] = KbCheck;
    if keyIsDown
        if keyCode(P.OldKey)==1 & keyCode(P.NewKey)==1
            isQuit = 0;
            return
        elseif keyCode(P.Quitkey)
            isQuit = 1;
            return;
        end;        
    end;
    WaitSecs(.01); %It is a good habit not to poll as fast as possible
end;