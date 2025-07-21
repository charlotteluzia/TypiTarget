function isQuit = TestIfLogfileExists(P)

global Info

isQuit = 0;

if exist(Info.Logfilename)
    disp('#######################################')
    disp('#######################################')
    asktext = ['File exists: ', Info.Logfilename, '! Overwrite [y/n]?\n'];

    
    answer = 0;
    
    while answer==0
        r = input(asktext, 's');
        if r=='y'
            decision = 1; % overwrite
            disp('OVERWRITING LOGFILES NOW.')
            answer = 1;
        elseif r=='n' % do not overwrite and quit
            disp('Will not overwrite. Exit programm.')
            answer = 1;
            isQuit = 1;
        end
    end
end
   