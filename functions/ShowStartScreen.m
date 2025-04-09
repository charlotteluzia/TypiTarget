function ShowStartScreen(window, P)

% ----- Present the start screen and wait for keypress -----
Screen(window,'FillRect', [ P.Black ]);
Screen(window,'TextSize',24);

presenttext = 'Bei Tastendruck geht es weiter.';
tw = RectWidth(Screen('TextBounds', window, presenttext));
th = RectHeight(Screen('TextBounds', window, presenttext));
Screen(window,'DrawText', presenttext, P.CenterX-0.5*tw, P.CenterY, P.TextColor );


tw = RectWidth(Screen('TextBounds', window, P.cue_text1));
th = RectHeight(Screen('TextBounds', window, P.cue_text1));
Screen(window, 'DrawText', P.cue_text1, P.CenterX-P.cueXoffset-0.5*tw, P.myHeight-P.cueYoffset, [180, 180, 180]);
Screen(window, 'DrawText', P.cue_text2, P.CenterX+P.cueXoffset-0.5*tw, P.myHeight-P.cueYoffset, [180, 180, 180]);

% Screen(window,'DrawText','Neu',10,30, [180, 180, 180] );
Screen('Flip', window);
KbWait;
Screen(window,'FillRect', P.Black);
DrawFixationCross;
Screen('Flip', window);
WaitSecs(1.500);