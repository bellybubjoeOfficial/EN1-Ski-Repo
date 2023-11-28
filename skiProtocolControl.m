function skiProtocolControl(Exp, gameObj, time)

global gatePos gateSpeed

switch Exp.SkiProtocolCase
    case 0
        disp("case 0");
        if (Exp.gatesPassed<Exp.gateNum-1)
            Exp.gateCounter = Exp.gateCounter + 1;
            Exp.SkiProtocolCase = 1;
            disp("bugs");
            disp(Exp.SkiProtocolCase);
        else
            Exp.SkiProtocolCase = 5;
            disp("bugs 2");
        end

    case 1
        disp("case 1");
        currentTime = toc(time.startTime);
        elapsedTime = round(currentTime, 2); % Round to 2 decimal places
        updateTime(time.timeMessage, elapsedTime); %update function
        speedString = strcat("Speed: ",num2str(gateSpeed^2));
        outputStates = [elapsedTime,speedString,Exp.gatesPassed];
        set(time.speedMessage,'string',speedString);
        set(time.gatesPassedMessage,'string',strcat('Gates Passed: ',num2str(outputStates(3)),'/12'));
        %set(gatesPassedMessage,'string',strcat('Force: ',num2str(force)));

        Exp.counter=Exp.counter+1;
        gateSpeed = gateSpeed + (Exp.counter/20000);
        if (gateSpeed >= Exp.terminalSpeed)
            gateSpeed = Exp.terminalSpeed;
        end

        pause(0.01);

        if Exp.gateCounter < Exp.gateNum
            Exp.SkiProtocolCase = 2;
            disp("test 2");
        else
            Exp.SkiProtocolCase = 0;
        end

    case 2
        disp("case 2");

        gateMovements();

        set(gameObj.gate.flag(Exp.gateCounter),'YData',get(gameObj.gate.flag(Exp.gateCounter),'YData')-gateSpeed/4);
        set(gameObj.gate.leftLeg(Exp.gateCounter),'YData',get(gameObj.gate.leftLeg(Exp.gateCounter),'YData')-gateSpeed/4);
        set(gameObj.gate.rightLeg(Exp.gateCounter),'YData',get(gameObj.gate.rightLeg(Exp.gateCounter),'YData')-gateSpeed/4);

        set(gameObj.gate.flag(Exp.gateCounter),'XData',get(gameObj.gate.flag(Exp.gateCounter),'XData')+gatePos);
        set(gameObj.gate.leftLeg(Exp.gateCounter),'XData',get(gameObj.gate.leftLeg(Exp.gateCounter),'XData')+gatePos);
        set(gameObj.gate.rightLeg(Exp.gateCounter),'XData',get(gameObj.gate.rightLeg(Exp.gateCounter),'XData')+gatePos);


        if mean(get(gameObj.gate.flag(Exp.gateCounter),'YData'))<=5
            Exp.gatesPassed=Exp.gatesPassed+1;
            Exp.SkiProtocolCase = 3;
        else
            Exp.SkiProtocolCase = 1;
        end

    case 3
        disp("case 3");
        if(mod(Exp.gateCounter,2) == 1 && mean(get(gameObj.gate.flag(Exp.gateCounter), 'XData')) <= mean(get(gameObj.skier, 'XData')))
            gateSpeed = gateSpeed * 0.25;
        end
        if(mod(Exp.gateCounter,2) == 0 && mean(get(gameObj.gate.flag(Exp.gateCounter), 'XData')) >= mean(get(gameObj.skier, 'XData')))
            gateSpeed = gateSpeed * 0.25;
        end



        if(Exp.gatesPassed<Exp.gateNum)
            Exp.SkiProtocolCase = 4;
        else
            Exp.SkiProtocolCase = 2;
        end

    case 4
        disp("case 4");
        set(gameObj.gate.flag(Exp.gateCounter),'YData',zeros(1:4)+(Exp.gateNum*Exp.gateDistance));
        set(gameObj.gate.rightLeg(Exp.gateCounter),'YData',zeros(1:4)+(Exp.gateNum*Exp.gateDistance));
        set(gameObj.gate.leftLeg(Exp.gateCounter),'YData',zeros(1:4)+(Exp.gateNum*Exp.gateDistance));

        Exp.SkiProtocolCase = 0;

    case 5
        disp("case 5");
        kinemats.speed=gateSpeed*(200/Exp.terminalSpeed);
        Exp.done = 1;
end