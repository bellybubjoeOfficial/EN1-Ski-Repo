function updateTime(mymessage, elapsedTime)
    % elapsedTime = elapsedTime + 1; % Increment elapsed time by 1 second
    minutes = floor(elapsedTime / 60);
    remainingSeconds = mod(elapsedTime, 60);

    % Format the time as "mm:ss"
    formattedTime = sprintf('%02d:%05.2f', minutes, remainingSeconds);
    timerWord = "Time: "
    messageWord = append(timerWord, formattedTime);
    %update message
    set(mymessage,'string', messageWord)
    disp(['Elapsed Time: ' num2str(elapsedTime) ' seconds']);
end











% clear
% close all force
% 
% %keep code below min main func
% % Define elapsedTime as a global variable
% global elapsedTime;
% global mymessage
% global k; 
% 
% 
% k=0;
% 
% % Initialize the global variable
% elapsedTime = 0;
% 
% %create figure, delete in real code
% hfig = figure(1);
% myscreensize =get(0, 'screensize'); 
% set(hfig, 'Position', myscreensize);
% hold on;
% 
% %stopwatch message object
% 
% %check to see if while loop can run while timer does -- does not work
% % while(true)
% %     timer01.TimerFcn = @(~,~)updateTime();
% %     k=k+1
% %     disp(k);
% %     pause(1);
% % end
% 
% 
% % Create a timer object
% timer01 = timer;
% timer01.StartDelay = 0;
% timer01.ExecutionMode = 'fixedRate';
% timer01.TimerFcn = @(~,~)updateTime();
% timer01.Period = 1; % Timer period in seconds
% timer01.TasksToExecute = 1000;
% timer01.StopFcn = @(~,~)EndGameFcn();
% 
% %mke message;
% xPos = myscreensize*0.2;
% yPos= myscreensize*0.8;
% mymessage = text(xPos, yPos, '0', 'FontSize', 20);
% 
% %check if two timers work 
% timer02 = timer;
% timer02.StartDelay = 0;
% timer02.ExecutionMode = 'fixedRate';
% timer02.TimerFcn = @(~,~)runK();
% timer02.Period = 1; % Timer period in seconds
% timer02.TasksToExecute = 1000;
% timer02.StopFcn = @(~,~)disp('Timer 2 stopped.')
% 
% 
% 
% start(timer01);
% 
% 
% 
% 
% % Function to update the elapsed time


% % Function to handle the end of the game
% function EndGameFcn()
%     disp('Game Over!');
%     % Additional end game logic can be added here
% end
% 
% function runK()
% %     global k;
%     k=k+1
%     disp(k);
%     pause(1);
% end