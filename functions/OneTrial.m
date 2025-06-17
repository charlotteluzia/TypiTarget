function [Info] = OneTrial(itrial)

global window Info P DefaultScreen;
% ----------------------------------------------------------------------
% Present pause a regular intervals and when a new block starts.
% ----------------------------------------------------------------------
if(mod(itrial, P.BreakAfternTrials) == 1 || itrial == 1)
    PresentPause(window, P, Info, itrial)
end 

% ----------------------------------------------------------------------
% Fixation cross and random-length inter-stimulus interval 
% ----------------------------------------------------------------------
if (strcmp(Info.T_fin(itrial).task,'oddball'))
    Screen('DrawTexture', window, DefaultScreen);
    [tISIon] = Screen('Flip', window);
else 
    Screen('DrawTexture', window, MemScreen);
    [tISIon] = Screen('Flip', window);
end


Info.T_fin(itrial).ISI = P.ISI_Dur;


% ----------------------------------------------------------------------
% Prepare images
% ----------------------------------------------------------------------
%Img = imread(fullfile(P.ImagePath, 'img_pbsj1.png'));
Img = imread(fullfile(P.ImagePath, Info.T_fin(itrial).filename));

ImgTex     = Screen('MakeTexture', window, Img);    
%ImgRect    = Screen('Rect', ImgTex); 
%scaledrect = ScaleRect(ImgRect);
%ImgRect    = CenterRectOnPoint(scaledrect, P.CenterX, P.CenterY);   


% ----------------------------------------------------------------------
% Present image after ISI is over 
% ----------------------------------------------------------------------
Screen('DrawTexture', window, DefaultScreen);
Screen('DrawTexture', window, ImgTex); % , [], ImgRect);
[tImageOn] = Screen('Flip', window, tISIon+Info.T_fin(itrial).ISI);

Info.T_fin(itrial).tImageOn = tImageOn - Info.StartTime;
if strcmp(Info.T_fin(itrial).task, 'oddball')
    Info.T_fin(itrial).img_dur = Info.T_fin(itrial).tImageOn + P.ImgDur;
end



% ----------------------------------------------------------------------
% Evaluate response. 
% ----------------------------------------------------------------------
if strcmp(Info.T_fin(itrial).task,'oddball')
    [Info.T_fin(itrial).Report, rt_time, isInvalidResponse] = GetKeyRelease(Info.T_fin(itrial).img_dur, Info.T_fin(itrial).category)
elseif strcmp(Info.T_fin(itrial).task, 'memory')
    [Info.T_fin(itrial).Report, rt_time] = GetResponse_Mem(P)
    Screen('Close', ImgTex); 
end

% Response time
Info.T_fin(itrial).RT = rt_time - tImageOn;

% Oddball task
%if/while
% did the subject detect the target?
if Info.T_fin(itrial).Report==99
    isQuit = true;

elseif Info.T_fin(itrial).Report==1
    isQuit = false;
    Info.T_fin(itrial).odd_resp = 1;
elseif Info.T_fin(itrial).Report==0
    Info.T_fin(itrial).odd_resp = 0;

end
% 


% Memory task
% did the subject say "(rather)/old" or "(rather)/new"?
if Info.T_fin(itrial).Report==99
    isQuit = true;

elseif Info.T_fin(itrial).Report == 1 | Info.T_fin(itrial).Report == 2 | ...
       Info.T_fin(itrial).Report == 3 | Info.T_fin(itrial).Report == 4
    isQuit = false;

    if Info.T_fin(itrial).Report == 1 & strcmp(Info.T_fin(itrial).cond, 'old')
        Info.T_fin(itrial).mem_resp = 1;
    elseif Info.T_fin(itrial).Report == 2 & strcmp(Info.T_fin(itrial).cond, 'old')
        Info.T_fin(itrial).mem_resp = 1;
    elseif Info.T_fin(itrial).Report == 1 & strcmp(Info.T_fin(itrial).cond, 'new')
        Info.T_fin(itrial).mem_resp = 0;
    elseif Info.T_fin(itrial).Report == 2 & strcmp(Info.T_fin(itrial).cond, 'new')
        Info.T_fin(itrial).mem_resp = 0;
    elseif Info.T_fin(itrial).Report == 3 & strcmp(Info.T_fin(itrial).cond, 'old')
        Info.T_fin(itrial).mem_resp = 0;
    elseif Info.T_fin(itrial).Report == 4 & strcmp(Info.T_fin(itrial).cond, 'old')
        Info.T_fin(itrial).mem_resp = 0;
    elseif Info.T_fin(itrial).Report == 3 & strcmp(Info.T_fin(itrial).cond, 'new')
        Info.T_fin(itrial).mem_resp = 1;
    elseif Info.T_fin(itrial).Report == 4 & strcmp(Info.T_fin(itrial).cond, 'new')
        Info.T_fin(itrial).mem_resp = 1;

    end
   

end

% And was this correct or wrong?
isOld = strcmp(Info.T(itrial).cond, 'old');

if isOld & Info.T(t).ReportOld==1
    Info.T(t).mem_response = 1;
    fprintf('Correct.\n');
elseif isOld & Info.T(t).ReportOld==0
    Info.T(t).mem_response = 0;
    fprintf('Error.\n');
elseif ~isOld & Info.T(t).ReportOld==1
    Info.T(t).mem_response = 0;
    fprintf('Error.\n');
elseif ~isOld & Info.T(t).ReportOld==0
    Info.T(t).mem_response = 1;
    fprintf('Correct.\n');
end

% ----------------------------------------------------------------------
% Present Feedback. 
% ----------------------------------------------------------------------
if P.doFeedback
    Screen('DrawTexture', window, DefaultScreen);
    if Info.T(t).mem_response==1
        my_fixationpoint(window, P.CenterX, P.CenterY, 5, [0 200 0])
    elseif Info.T(t).mem_response==0
        my_fixationpoint(window, P.CenterX, P.CenterY, 5, [200 0 0])
    else
        my_fixationpoint(window, P.CenterX, P.CenterY, 15, [200 200 0])
    end
        
    [VBLTimestamp, t_imageoffset] = Screen('Flip', window);
    
    
    WaitSecs(P.FeedbackDuration);

end
