function [isQuit, thisRun, OldInfo] = TestIfLogfileExists(name, flavor)
% This function test if Logfiles exist for this subject. If yes, you can
% start a new run with new images or quit.

Info = [];
isQuit  = 0;
thisRun = 0;


%% If this is a test, continue with run 01 - because it does not matter.
if strcmp(name, 'test')
    thisRun = 1;
    return
    
    
else
    d = dir(['Logfiles\' name '_Run' '*']);
    nRuns = length(d);
    
    % Does this subject have any runs yet?
    if ~isempty(d)
        clc
        
        % Load the Info file of the first run.
        logfilename = ['Logfiles\' name '_Run01_Logfile.mat'];
        OldInfo = load(logfilename);
        OldInfo = OldInfo.Info;
        
        % What flavor is this? If we are running the final recognition
        % test, it is ok if the subject already has runs from the crt phase
        % (it is actually necessary that they do). But if this is still the
        % crt phase, we do not want to overwrite existing sessions.
        switch flavor
                        
            case 'rectest'
                thisRun = nRuns+1;
                fprintf('\nThis is the final recognition test. We will store this as run %02.f.\n', thisRun)
                
            case 'crt'                
                R = char([]);
                while isempty(R)
                    fprintf('Folgende Logfiles existieren für Proband %s:\n', name);
                    fprintf('%s\n', d.name)
                    fprintf('\nWas jetzt?\n')
                    fprintf('[A]bbruch.\n')
                    fprintf('[N]euer Run mit neuen Bildern.\n')
                    
                    R = input('?', 's');
                    
                    switch R
                        case 'a'
                            isQuit = 1;
                            return
                        case 'n'
                            thisRun = nRuns+1;
                            fprintf('Starte neuen Run Nr. %02d\n', thisRun)
                        otherwise % Keep asking.
                            R = [];
                    end
                end
        end
    else
        thisRun = 1;
    end
    
end