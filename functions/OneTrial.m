function [Info, isQuit] = OneTrial(itrial)

global window Info P DefaultScreen MemScreen;
% ----------------------------------------------------------------------
% Present pause when a new block starts.
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
% Fixation cross and inter-stimulus interval 
% ----------------------------------------------------------------------
if strcmp(Info.T_fin(itrial).task,'oddball')
    Screen('DrawTexture', window, DefaultScreen);
    [tISIon] = Screen('Flip', window);
    % Info.T_fin(itrial).ISI = P.ISI_Dur;
    mean_isi = mean([0 P.maxISI]);
    Info.T_fin(itrial).ISI = P.minISI + -log(1-rand.*(1-exp(-P.maxISI./mean_isi))).*mean_isi;
elseif strcmp(Info.T_fin(itrial).task,'memory')
    Screen('DrawTexture', window, MemScreen);
    [tISIon] = Screen('Flip', window);
    % Info.T_fin(itrial).ISI = P.ISI_Dur;
    mean_isi = mean([0 P.maxISI]);
    Info.T_fin(itrial).ISI = P.minISI + -log(1-rand.*(1-exp(-P.maxISI./mean_isi))).*mean_isi;
end

% Screen('DrawTexture', window, DefaultScreen);
% [tISIon] = Screen('Flip', window);
% 
% Info.T_fin(itrial).ISI = P.ISI_Dur;


% ----------------------------------------------------------------------
% Prepare images
% ----------------------------------------------------------------------
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
% rt_time = 0;
% Info.T_fin(itrial).tImageOn = tImageOn - Info.StartTime;
  if strcmp(Info.T_fin(itrial).task, 'oddball')
        Screen('DrawTexture', window, DefaultScreen);
        Screen('DrawTexture', window, ImgTex, [], Pos);
        % Screen('DrawTexture', window, ImgTex, [], ImgRect);
        if(mod(itrial, P.BreakAfternTrials) == 1 || itrial == 1)
            [tImageOn] = Screen('Flip', window, tISIon + Info.T_fin(itrial).ISI); % P.ISI_Dur);
        else
            if Info.T_fin(itrial-1).Report == 0
            [tImageOn] = Screen('Flip', window, tISIon);
            else
            [tImageOn] = Screen('Flip', window, tISIon + (Info.T_fin(itrial).ISI + P.ImgDur)); % - Info.T_fin(itrial-1).RT));
            end
        end
    
        % [tImageOn] = Screen('Flip', window, tISIon + Info.T_fin(itrial).ISI);
        Info.T_fin(itrial).tImageOn = tImageOn - Info.StartTime;

        % Send trigger
        if P.isEEG
                Trigger = P.UseTriggers(1, Info.T_fin(itrial).task, Info.T_fin(itrial).category);
                SendTrigger(Trigger, P.TriggerDuration)
        end
    
        % Info.T_fin(itrial).img_dur = Info.T_fin(itrial).tImageOn + P.ImgDur;
    
        % Screen('DrawTexture', window, DefaultScreen);
        % Screen('Flip', window, tImageOn+P.ImgDur);
        [Info.T_fin(itrial).Report, rt_time] = GetResponse_Odd(tImageOn, (tImageOn+P.ImgDur), Info.T_fin(itrial).ISI);
        
        % secs = 0;
        % now = GetSecs;
        % % Report = NaN;
        % Info.T_fin(itrial).Report = 0;
        % isQuit = 0;
        % 
        % 
        % timeout = 1.5;
        % stop = now + timeout + P.ImgDur;
        % imageonScreen = 1;
        % 
        % while GetSecs < stop
        %     keyIsDown = 0;
        %     if (imageonScreen == 1) && (GetSecs > (secs+toffset))
        %         Screen('DrawTexture', window, DefaultScreen);
        %         Screen('Flip', window);
        %         imageonScreen = 0;
        %     end
        %     [keyIsDown,secs,keyCode] = KbCheck;
        %     if keyIsDown
        %         if keyCode(P.YesKey)
        %             Info.T_fin(itrial).Report = 1;
        %             % StimulusOffset(toffset);
        %             % if P.isEEG
        %             %     Trigger = P.UseTriggers(2, Info.T_fin(itrial).task, Info.T_fin(itrial).category);
        %             %     SendTrigger(Trigger, P.TriggerDuration)
        %             % end
        %             break
        %         elseif keyCode(P.Quitkey)
        %             Info.T_fin(itrial).Report = 99;
        %             isQuit = 1;
        %             % StimulusOffset(toffset);
        %             break
        %         end
        %     end
        % end

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


        % calculate position of image for isolation spread effect
        % images presented before or behind a target or nontarget
        % keep track of filenames of images with isolation spread effect to
        % mark then in memory task
        % iso_spread = 1 -> before target, iso_spread = 2 -> before nontarget
        % iso_spread = 3 -> after target, iso_spread = 4 -> after nontarget

        if(mod(itrial, P.BreakAfternTrials) == 1 || itrial == 1)
            if ~contains(Info.T_fin(itrial).category, 'target') & strcmp(Info.T_fin(itrial+1).category, 'target')
                Info.T_fin(itrial).iso_spread = 1;
                Info.files_iso_spread(end + 1).filename = Info.T_fin(itrial).filename;
                Info.files_iso_spread(end).iso_spread = 1;
            elseif ~contains(Info.T_fin(itrial).category, 'nontarget') & strcmp(Info.T_fin(itrial+1).category, 'nontarget')
                Info.T_fin(itrial).iso_spread = 2;
                Info.files_iso_spread(end + 1).filename = Info.T_fin(itrial).filename;
                Info.files_iso_spread(end).iso_spread = 2;
            else
                Info.T_fin(itrial).iso_spread = 0;
            end

        elseif strcmp(Info.T_fin(itrial+1).task, 'memory')
            if ~contains(Info.T_fin(itrial).category, 'target') & strcmp(Info.T_fin(itrial-1).category, 'target')
                Info.T_fin(itrial).iso_spread = 3;
                Info.files_iso_spread(end + 1).filename = Info.T_fin(itrial).filename;
                Info.files_iso_spread(end).iso_spread = 3;
            elseif ~contains(Info.T_fin(itrial).category, 'nontarget') & strcmp(Info.T_fin(itrial-1).category, 'nontarget')
                Info.T_fin(itrial).iso_spread = 4;
                Info.files_iso_spread(end + 1).filename = Info.T_fin(itrial).filename;
                Info.files_iso_spread(end).iso_spread = 4;
            else
                Info.T_fin(itrial).iso_spread = 0;
            end

        else
            if ~contains(Info.T_fin(itrial-1).category, 'target') & strcmp(Info.T_fin(itrial+1).category, 'target')...
                    & ~contains(Info.T_fin(itrial).category, 'target')
                Info.T_fin(itrial).iso_spread = 1;
                Info.files_iso_spread(end + 1).filename = Info.T_fin(itrial).filename;
                Info.files_iso_spread(end).iso_spread = 1;
            elseif strcmp(Info.T_fin(itrial-1).category, 'target') & ~contains(Info.T_fin(itrial+1).category, 'target')...
                    & ~contains(Info.T_fin(itrial).category, 'target')
                Info.T_fin(itrial).iso_spread = 3;
                Info.files_iso_spread(end + 1).filename = Info.T_fin(itrial).filename;
                Info.files_iso_spread(end).iso_spread = 3;
            elseif ~contains(Info.T_fin(itrial-1).category, 'target') & strcmp(Info.T_fin(itrial+1).category, 'nontarget')...
                    & ~contains(Info.T_fin(itrial).category, 'target')
                Info.T_fin(itrial).iso_spread = 2;
                Info.files_iso_spread(end + 1).filename = Info.T_fin(itrial).filename;
                Info.files_iso_spread(end).iso_spread = 2;
            elseif strcmp(Info.T_fin(itrial-1).category, 'nontarget') & ~contains(Info.T_fin(itrial+1).category, 'target')...
                    & ~contains(Info.T_fin(itrial).category, 'target')
                Info.T_fin(itrial).iso_spread = 4;
                Info.files_iso_spread(end + 1).filename = Info.T_fin(itrial).filename;
                Info.files_iso_spread(end).iso_spread = 4;
            else
                Info.T_fin(itrial).iso_spread = 0;
            end

        end



 
    elseif strcmp(Info.T_fin(itrial).task, 'memory')
    
        Screen('DrawTexture', window, MemScreen);
        Screen('DrawTexture', window, ImgTex, [], Pos);
        % Screen('DrawTexture', window, ImgTex, [], ImgRect);
        [tImageOn] = Screen('Flip', window, tISIon+Info.T_fin(itrial).ISI);
    
        Info.T_fin(itrial).tImageOn = tImageOn - Info.StartTime;

        % Send trigger
        if P.isEEG
                Trigger = P.UseTriggers(1, Info.T_fin(itrial).task, Info.T_fin(itrial).category);
                SendTrigger(Trigger, P.TriggerDuration)
        end
    
        [Info.T_fin(itrial).Report, rt_time] = GetResponse_Mem(P);
        Screen('DrawTexture', window, MemScreen);
        Screen('Flip', window); % [VBLTimestamp, t_imageoffset] = 
    
        Screen('Close', ImgTex);
    
        % Response time
        Info.T_fin(itrial).RT = rt_time - tImageOn;

        
        if strcmp(Info.T_fin(itrial).cond, 'old')
            for f = 1:length(Info.files_iso_spread)
                if strcmp(Info.T_fin(itrial).filename, Info.files_iso_spread(f).filename) & Info.files_iso_spread(f).iso_spread == 1
                    Info.T_fin(itrial).iso_spread = 1;
                    break
                elseif strcmp(Info.T_fin(itrial).filename, Info.files_iso_spread(f).filename) & Info.files_iso_spread(f).iso_spread == 2
                    Info.T_fin(itrial).iso_spread = 2;
                    break
                elseif strcmp(Info.T_fin(itrial).filename, Info.files_iso_spread(f).filename) & Info.files_iso_spread(f).iso_spread == 3
                    Info.T_fin(itrial).iso_spread = 3;
                    break
                elseif strcmp(Info.T_fin(itrial).filename, Info.files_iso_spread(f).filename) & Info.files_iso_spread(f).iso_spread == 4
                    Info.T_fin(itrial).iso_spread = 4;
                    break
                else
                    Info.T_fin(itrial).iso_spread = 0;
                end
            end
            
        elseif strcmp(Info.T_fin(itrial).cond, 'new')
            Info.T_fin(itrial).iso_spread = 0;
        end
    
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
