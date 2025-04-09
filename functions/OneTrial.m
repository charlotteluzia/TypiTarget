function [Info] = OneTrial(t)

global window Info P DefaultScreen;

% ----------------------------------------------------------------------
% Fixation cross and random-length inter-stimulus interval 
% ----------------------------------------------------------------------
Screen('DrawTexture', window, DefaultScreen);
[tISIon] = Screen('Flip', window); 


% Send trigger.
if P.isEEG
        Trigger = P.UseTriggers(Info.T(t).presentation_no, Info.T(t).category_index, 1);
    SendTrigger(Trigger, P.TriggerDuration);
end

mean_isi = mean([0 P.maxISI]);
Info.T(t).ISI = P.minISI + -log(1-rand.*(1-exp(-P.maxISI./mean_isi))).*mean_isi;
% Info.T(t).ISI = P.minISI + (P.maxISI-P.minISI).*rand(1);


% ----------------------------------------------------------------------
% Prepare images
% ----------------------------------------------------------------------
%ImageFolder = 'images';
%imgList = dir(fullfile(P.ImagePath,['*.' imageFormat]));
%imgList = {imgList(:).name};
Img = imread(fullfile(P.ImagePath, 'img_pbsj1.png'));

ImgTex     = Screen('MakeTexture', window, Img);    
%ImgRect    = Screen('Rect', ImgTex); 
%scaledrect = ScaleRect(ImgRect);
%ImgRect    = CenterRectOnPoint(scaledrect, P.CenterX, P.CenterY);   


% ----------------------------------------------------------------------
% Present image after ISI is over 
% ----------------------------------------------------------------------
Screen('DrawTexture', window, DefaultScreen);
Screen('DrawTexture', window, ImgTex); % , [], ImgRect);
[tImageOn] = Screen('Flip', window, tISIon+Info.T(t).ISI);

Info.T(t).tImageOn = tImageOn - Info.StartTime;

% Send trigger.
if P.isEEG
        Trigger = P.UseTriggers(Info.T(t).presentation_no, Info.T(t).category_index, 2);
    SendTrigger(Trigger, P.TriggerDuration);
end

Screen('Close', ImgTex); 

end
