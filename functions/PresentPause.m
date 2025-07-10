function PresentPause(window, P, Info, t)
% Does exactly what the name says.

global DefaultScreen

disp('Pause')
WaitSecs(0.5);

%% Present the pause.
Screen('DrawTexture', window, DefaultScreen);

pausetext = ['Drücken Sie die Leertaste, um \n mit Durchgang ' num2str(t) ' von ' num2str(length(Info.T_fin)) ' fortzufahren\n'...
    '\nNächster Block:\n' ...
    'Zielreiz Supermarkt: Leertaste drücken\n' ...
    'Distraktor Badezimmer\n' ...
    'Standard Küche/Schlafzimmer/Wohnzimmer'];
Screen(window,'TextSize',24);
tw = RectWidth(Screen('TextBounds', window, pausetext));
th = RectHeight(Screen('TextBounds', window, pausetext));
[nx, ny, textbounds] = DrawFormattedText(window, pausetext, P.CenterX-0.25*tw, P.CenterY-100);
Screen('Flip', window);


%% Wait for button press and exit.
[secs, keyCode, deltaSecs] = KbWait;
if keyCode(P.Quitkey)
    CloseAndCleanup(P)
end;     
       
fprintf('\n');

WaitSecs(1.5);