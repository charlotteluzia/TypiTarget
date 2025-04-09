function CloseAndCleanup(P)
% Used for closing screens and ports after experiments finishes or crashes.

Screen('CloseAll');
%ListenChar;
ShowCursor;

if P.isEEG
    SendTrigger(P.TriggerStopRecording, P.TriggerDuration);
    CloseTriggerPort
end