function [Info, isQuit] = OneTrial(itrial)

global window Info P DefaultScreen;
% ----------------------------------------------------------------------
% Present pause a regular intervals and when a new block starts.
% ----------------------------------------------------------------------
switch P.Flavor
    case 'training'
        if(mod(itrial, P.BreakAfternTrials) == 1 || itrial == 1)
            PresentPause_Training(window, P, Info, itrial)
        end 
     
    case 'full'
        if(mod(itrial, P.BreakAfternTrials) == 1 || itrial == 1)
            PresentPause(window, P, Info, itrial)
        end
end


% ----------------------------------------------------------------------
% Display trial info on experimenter's screen.
% ----------------------------------------------------------------------
switch P.Flavor
    case 'training'
        fprintf('Training session. Trial %d of %d. \n', itrial, length(Info.T_fin));
        
    case 'full'     
        fprintf('Full experiment. Trial %d of %d. \n', itrial, length(Info.T_fin));
            
end


% ----------------------------------------------------------------------
% Fixation cross and random-length inter-stimulus interval 
% ----------------------------------------------------------------------
% if (strcmp(Info.T_fin(itrial).task,'oddball'))
%     Screen('DrawTexture', window, DefaultScreen);
%     [tISIon] = Screen('Flip', window);
% else 
%     Screen('DrawTexture', window, DefaultScreen);
%     [tISIon] = Screen('Flip', window);
% end

Screen('DrawTexture', window, DefaultScreen);
[tISIon] = Screen('Flip', window);

Info.T_fin(itrial).ISI = P.ISI_Dur;


% ----------------------------------------------------------------------
% Prepare images
% ----------------------------------------------------------------------
%Img = imread(fullfile(P.ImagePath, 'img_pbsj1.png'));
Img = imread(fullfile(P.ImagePath, Info.T_fin(itrial).filename));

ImgTex    = Screen('MakeTexture', window, Img);    
imageSize = size(Img);
Pos = [(P.myWidth-imageSize(2))/2 (P.myHeight-imageSize(1))/2 (P.myWidth+imageSize(2))/2 (P.myHeight+imageSize(1))/2];
% Pos       = CenterRectOnPoint(imageSize, P.CenterX, P.CenterY); 
% ImgRect   = CenterRectOnPoint(imageSize, P.CenterX, P.CenterY);


% ----------------------------------------------------------------------
% Present image after ISI is over 
% ----------------------------------------------------------------------
% Screen('DrawTexture', window, DefaultScreen);
% Screen('DrawTexture', window, ImgTex); % , [], ImgRect);
% [tImageOn] = Screen('Flip', window, tISIon+Info.T_fin(itrial).ISI);
rt_time = 0;
% Info.T_fin(itrial).tImageOn = tImageOn - Info.StartTime;
  if strcmp(Info.T_fin(itrial).task, 'oddball')
        Screen('DrawTexture', window, DefaultScreen);
        Screen('DrawTexture', window, ImgTex, [], Pos);
        % Screen('DrawTexture', window, ImgTex, [], ImgRect);
        [tImageOn] = Screen('Flip', window, tISIon + Info.T_fin(itrial).ISI - rt_time); % P.ISI_Dur);
    
        Info.T_fin(itrial).tImageOn = tImageOn - Info.StartTime;
    
        % Info.T_fin(itrial).img_dur = Info.T_fin(itrial).tImageOn + P.ImgDur;
    
        Screen('DrawTexture', window, DefaultScreen);
        Screen('Flip', window, tImageOn+P.ImgDur);
        [Info.T_fin(itrial).Report, rt_time] = GetResponse_Odd(P);
    
        Screen('Close', ImgTex);
    
        % Response time
        Info.T_fin(itrial).RT = rt_time - tImageOn;
        Info.T_fin(itrial).target_resp = NaN;
        % Oddball task
        % did the subject detect the target?
        if Info.T_fin(itrial).Report==99
            isQuit = true;
        
        elseif Info.T_fin(itrial).Report==1
            isQuit = false;
            Info.T_fin(itrial).target_resp = 1;
        elseif Info.T_fin(itrial).Report==0
            isQuit = false;
            Info.T_fin(itrial).target_resp = 0;
        
        end
    
    elseif strcmp(Info.T_fin(itrial).task, 'memory')
    
        Screen('DrawTexture', window, DefaultScreen);
        Screen('DrawTexture', window, ImgTex, [], Pos);
        % Screen('DrawTexture', window, ImgTex, [], ImgRect);
        [tImageOn] = Screen('Flip', window, tISIon+Info.T_fin(itrial).ISI);
    
        Info.T_fin(itrial).tImageOn = tImageOn - Info.StartTime;
    
        [Info.T_fin(itrial).Report, rt_time] = GetResponse_Mem(P);
        Screen('DrawTexture', window, DefaultScreen);
        Screen('Flip', window); % [VBLTimestamp, t_imageoffset] = 
    
        Screen('Close', ImgTex);
    
        % Response time
        Info.T_fin(itrial).RT = rt_time - tImageOn;
    
        % Memory task
        % did the subject say "(rather)/old" or "(rather)/new"?
        if Info.T_fin(itrial).Report==99
            isQuit = true;
        
        elseif Info.T_fin(itrial).Report == 1 || Info.T_fin(itrial).Report == 2 || ...
               Info.T_fin(itrial).Report == 3 || Info.T_fin(itrial).Report == 4
            isQuit = false;

            if Info.T_fin(itrial).Report == 1
                Info.T_fin(itrial).mem_response = 1;
            elseif Info.T_fin(itrial).Report == 2
                Info.T_fin(itrial).mem_response = 2;
            elseif Info.T_fin(itrial).Report == 3
                Info.T_fin(itrial).mem_response = 3;
            elseif Info.T_fin(itrial).Report == 4
                Info.T_fin(itrial).mem_response = 4;
            end
        
            if Info.T_fin(itrial).Report == 1 & strcmp(Info.T_fin(itrial).cond, 'old')
                Info.T_fin(itrial).mem_perform = 'hit';
                fprintf('Hit.\n');
            elseif Info.T_fin(itrial).Report == 2 & strcmp(Info.T_fin(itrial).cond, 'old')
                Info.T_fin(itrial).mem_perform = 'hit';
                fprintf('Hit.\n');
            elseif Info.T_fin(itrial).Report == 1 & strcmp(Info.T_fin(itrial).cond, 'new')
                Info.T_fin(itrial).mem_perform = 'fa';
                fprintf('False Alarm.\n');
            elseif Info.T_fin(itrial).Report == 2 & strcmp(Info.T_fin(itrial).cond, 'new')
                Info.T_fin(itrial).mem_perform = 'fa';
                fprintf('False Alarm.\n');
            elseif Info.T_fin(itrial).Report == 3 & strcmp(Info.T_fin(itrial).cond, 'old')
                Info.T_fin(itrial).mem_perform = 'miss';
                fprintf('Miss.\n');
            elseif Info.T_fin(itrial).Report == 4 & strcmp(Info.T_fin(itrial).cond, 'old')
                Info.T_fin(itrial).mem_perform = 'miss';
                fprintf('Miss.\n');
            elseif Info.T_fin(itrial).Report == 3 & strcmp(Info.T_fin(itrial).cond, 'new')
                Info.T_fin(itrial).mem_perform = 'cr';
                fprintf('Correct Rejection.\n');
            elseif Info.T_fin(itrial).Report == 4 & strcmp(Info.T_fin(itrial).cond, 'new')
                Info.T_fin(itrial).mem_perform = 'cr';
                fprintf('Correct Rejection.\n');
        
            end
           
        end

    % ----------------------------------------------------------------------
% Present Feedback. 
% ----------------------------------------------------------------------
if P.doFeedback
    Screen('DrawTexture', window, DefaultScreen);
    if strcmp(Info.T_fin(itrial).mem_perform, 'hit') || strcmp(Info.T_fin(itrial).mem_perform, 'cr')
        my_optimal_fixationpoint(window, P.CenterX, P.CenterY, 0.6, [0 200 0], [192 192 192], P.pixperdeg)
    elseif strcmp(Info.T_fin(itrial).mem_perform, 'miss') || strcmp(Info.T_fin(itrial).mem_perform, 'fa')
        my_optimal_fixationpoint(window, P.CenterX, P.CenterY, 0.6, [200 0 0], [192 192 192], P.pixperdeg)
    else
        my_optimal_fixationpoint(window, P.CenterX, P.CenterY, 1, [200 200 0], [192 192 192], P.pixperdeg)
        
    end
        
    [VBLTimestamp, t_imageoffset] = Screen('Flip', window);
    
    
    WaitSecs(P.FeedbackDuration);
    
 end



 end
