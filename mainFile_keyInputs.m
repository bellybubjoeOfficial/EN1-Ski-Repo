close

global SystemParams force gatePos gateSpeed

myscreensize = get(0, 'ScreenSize');
screenObj = figure(1);
screenObj.Position = myscreensize;
screenObj.MenuBar = 'none';
screenObj.ToolBar = 'none';
set(screenObj, 'KeyPressFcn', @keyInput);

b = 500;  %inner square of the hollow beam for casting
l = 500;
x = [-b b b -b]; %0 10 10 breadth-10 breadth-10 10];
y = [0 l];
z = [0 0 b b ]; %0 10 10 breadth-10 breadth-10 10];
m = length(x);
xr=[x x(1)];
yr1=y(1)*ones(m+1,1);
zr=[z z(1)];
boxPart1=plot3(xr,yr1,zr,'w');
boxPart1.Color="none";%;
hold on


gameObj.slope=patch([-1000 1000 1000 -1000],[-5 -5 1205 1210],[0 0 0 0],[0.7 0.7 0.7]);
gameObj.skier=patch([0 10 6 4]-5,[5 5 5 5],[0 0 15 15],'k');


ax=gca;
ax.XLim=[1-myscreensize(3) myscreensize(3)];
ax.YLim=[0 myscreensize(4)];


ax.CameraPosition=[0 -5 10];
ax.CameraTarget=[0 5 5];
%disp(ax.Projection)
%ax.Projection='perspective';
grid off
axis off

%disp(ax.CameraPosition);
idealTrajPatch = patch([ax.CameraPosition(1) ax.CameraPosition(1)+25 100 100+25],[ax.CameraPosition(2) ax.CameraPosition(2)+25 100 100+25],[ax.CameraPosition(3) ax.CameraPosition(3)+25 100 100+25],[0,0,0]);
set(idealTrajPatch,'FaceColor',[0.7 0.7 0.7]);
set(idealTrajPatch,'EdgeColor','none');
            
gateSpeed=-1;

Exp.totalGates=12;
Exp.gateDistance=75;%300;
deltaX=10;
gameObj.gate.X1=ones(1,4);
gameObj.gate.X2=gameObj.gate.X1+deltaX;
gameObj.gate.Y1=[1:Exp.totalGates+2]*Exp.gateDistance;
deltaY=-5;
gameObj.gate.Y2=gameObj.gate.Y1+deltaY;
deltaZ=10;
gameObj.gate.Z1=10;
gameObj.gate.Z2=gameObj.gate.Z1+deltaZ;
deltaLeg=deltaZ*2;

%ode params
tspan = [0, 0.01];
time_force = tspan;
SystemParams.tspan = tspan;
SystemParams.time_force = time_force;
SystemParams.Inertia = 1.0;
SystemParams.Damping = 50;
SystemParams.y0 = [0 0];
force = 0;

speedData=zeros(1,15);
timeData=zeros(1,15);
errorData=zeros(1,15);

for i=1:Exp.totalGates+2
    gameObj.gate.X1(i)=50*(-1)^i;
    gameObj.gate.X2=gameObj.gate.X1+deltaX;
    gameObj.legXPoints=[gameObj.gate.X1(i) gameObj.gate.X1(i)+2 gameObj.gate.X1(i)+2 gameObj.gate.X1(i)];

    gameObj.flagXPoints=[gameObj.gate.X1(i) gameObj.gate.X2(i) gameObj.gate.X2(i) gameObj.gate.X1(i)];
    gameObj.flagYPoints=[gameObj.gate.Y1(i) gameObj.gate.Y1(i) gameObj.gate.Y2(i) gameObj.gate.Y2(i)];
    gameObj.flagZPoints=[gameObj.gate.Z1 gameObj.gate.Z1 gameObj.gate.Z2 gameObj.gate.Z2];
    gameObj.gate.flag(i)=patch(gameObj.flagXPoints,gameObj.flagYPoints,gameObj.flagZPoints,[1 0.33 0.33]);
    gameObj.gate.leftLeg(i)=patch(gameObj.legXPoints,gameObj.flagYPoints-deltaY,(gameObj.flagZPoints-deltaZ),[1 0.33 0.33]);
    gameObj.gate.rightLeg(i)=patch(gameObj.legXPoints+(deltaX-2),gameObj.flagYPoints-deltaY,(gameObj.flagZPoints-deltaZ),[1 0.33 0.33]);

    if(mod(i,2)==1)
        set(gameObj.gate.flag(i),'FaceColor',[0.33 0.33 1]);
        set(gameObj.gate.leftLeg(i),'FaceColor',[0.33 0.33 1]);
        set(gameObj.gate.rightLeg(i),'FaceColor',[0.33 0.33 1]);
    end
end


Exp.counter=0;
%gateSpeed=1;
Exp.terminalSpeed = 9.8; %tune later

%stopwatch message
xPos = myscreensize(3)*(0.1/5);
yPos= myscreensize(4)*(0.1/5);
timeMessage = text(xPos, yPos, 20.153, '0', 'FontSize', 20,'color','none');
speedMessage = text(xPos+14, yPos, 15.153, 'j', 'FontSize', 20,'color','none');
gatesPassedMessage = text(xPos+7, yPos, 18.153, 'j', 'FontSize', 20,'color','none');

instructions1 = text(-200, 40, -80, 'How to Play:', 'FontSize', 20);
instructions2 = text(-1480, 40, -130, 'Point the light on the Arduino towards the computer screen, tilt it left and right (like a steering', 'FontSize', 20);
instructions3 =text(-1450, 40, -180, 'wheel) to turn in those directions. Tilt the Arduino forward to speed up, backwards to slow ', 'FontSize', 20);
instructions4 =text(-1300, 40, -230, 'Stay to the left of the blue gates and the right of the red gates for the best time.', 'FontSize', 20);
instructions5 =text(-700, 40, -280, ' Press "SPACE" to start and go as fast a you can!', 'FontSize', 20);
instructions = [instructions1, instructions2, instructions3, instructions4, instructions5];

%stopwatch begin
startTime = tic(); % Start the stopwatch
elapsedTime = 0;
Exp.nextGate=0;
speedString= "";
%outputStates = [elapsedTime,speedString,Exp.gatesPassed];

gatePos_old=gatePos;
Exp.SkiProtocolCase=0;
Exp.done=false;

while(Exp.done == false)
    gateMovements();
    pause(1.000000e-11110100000);

    switch Exp.SkiProtocolCase

        %base case start game
        case 0
            if (Exp.nextGate<Exp.totalGates)
                Exp.nextGate = Exp.nextGate + 1;
                Exp.SkiProtocolCase = 1;
            else
                Exp.SkiProtocolCase = 5;

            end
        case 1 %updates onscreen text
            currentTime = toc(startTime);
            elapsedTime = round(currentTime, 2); % Round to 2 decimal places
            update_Time(timeMessage, elapsedTime); %update function
            speedString = strcat("Speed: ",num2str(gateSpeed));
            %outputStates = [elapsedTime,speedString,Exp.nextGate-1];
            set(speedMessage,'string',speedString);
            set(gatesPassedMessage,'string',strcat("Gates Passed: ",num2str(Exp.nextGate-1),'/12'));
            if(gateSpeed>0)
                if(mod(Exp.nextGate,2)==1 && max(get(gameObj.gate.rightLeg(Exp.nextGate),'XData')) > 0)         %left of blue (good)
                    set(idealTrajPatch,'FaceColor','green')
                    set(idealTrajPatch,'XData',[min(get(gameObj.skier, 'XData')) max(get(gameObj.gate.rightLeg(Exp.nextGate),'XData')) max(get(gameObj.gate.rightLeg(Exp.nextGate),'XData')) min(get(gameObj.gate.leftLeg(Exp.nextGate),'XData'))]);
                elseif  (mod(Exp.nextGate,2)==0 && min(get(gameObj.gate.leftLeg(Exp.nextGate),'XData')) < 0)    %right of red (good)
                    set(idealTrajPatch,'FaceColor','green')
                    set(idealTrajPatch,'XData',[max(get(gameObj.skier, 'XData')) min(get(gameObj.gate.leftLeg(Exp.nextGate),'XData')) min(get(gameObj.gate.leftLeg(Exp.nextGate),'XData')) max(get(gameObj.gate.rightLeg(Exp.nextGate),'XData'))]);
                elseif mod(Exp.nextGate,2)==1       %right of blue (bad)
                    set(idealTrajPatch,'XData',[max(get(gameObj.skier, 'XData')) min(get(gameObj.gate.leftLeg(Exp.nextGate),'XData')) min(get(gameObj.gate.leftLeg(Exp.nextGate),'XData')) max(get(gameObj.gate.rightLeg(Exp.nextGate),'XData'))]);
                    set(idealTrajPatch,'FaceColor',[1 0.5 0.5]);
                else                                %left of red (bad)
                    set(idealTrajPatch,'XData',[min(get(gameObj.skier, 'XData')) max(get(gameObj.gate.rightLeg(Exp.nextGate),'XData')) max(get(gameObj.gate.rightLeg(Exp.nextGate),'XData')) min(get(gameObj.gate.leftLeg(Exp.nextGate),'XData'))]);
                    set(idealTrajPatch,'FaceColor',[1 0.5 0.5]);
                end
            end

            if (Exp.nextGate < Exp.totalGates+1)
                Exp.SkiProtocolCase = 2;
            else
                Exp.SkiProtocolCase = 0;
            end
        
        case 2
            if(gateSpeed<Exp.terminalSpeed)&&(gateSpeed>0)
                gateSpeed=gateSpeed+(1/200);
            end
            gateMovements()
            
            if(gateSpeed>0)
                ax.Projection="perspective";
                timeMessage.Color='k';
                speedMessage.Color='k';
                gatesPassedMessage.Color='k';
                for a=1:5
                    instructions(a).Color=[240/255 240/255 240/255];
                end
           
                for i=1:Exp.totalGates                
                    set(gameObj.gate.flag(i),'YData',get(gameObj.gate.flag(i),'YData')-gateSpeed/4);
                    set(gameObj.gate.leftLeg(i),'YData',get(gameObj.gate.leftLeg(i),'YData')-gateSpeed/4);
                    set(gameObj.gate.rightLeg(i),'YData',get(gameObj.gate.rightLeg(i),'YData')-gateSpeed/4);
                    
                    set(gameObj.gate.flag(i),'XData',get(gameObj.gate.flag(i),'XData')+gatePos);
                    set(gameObj.gate.leftLeg(i),'XData',get(gameObj.gate.leftLeg(i),'XData')+gatePos);
                    set(gameObj.gate.rightLeg(i),'XData',get(gameObj.gate.rightLeg(i),'XData')+gatePos);
                end
            end

            set(idealTrajPatch,'YData',[min(get(gameObj.skier, 'YData')) min(get(gameObj.skier, 'YData')) max(get(gameObj.gate.leftLeg(Exp.nextGate),'YData')) max(get(gameObj.gate.leftLeg(Exp.nextGate),'YData'))]);
            set(idealTrajPatch,'ZData',[min(get(gameObj.skier, 'ZData')) min(get(gameObj.skier, 'ZData')) min(get(gameObj.gate.leftLeg(Exp.nextGate),'ZData')) min(get(gameObj.gate.leftLeg(Exp.nextGate),'ZData'))]);
           
            
            if max(get(gameObj.gate.leftLeg(Exp.nextGate),'YData'))<=5
                Exp.SkiProtocolCase = 3;
                disp("breach breach BREACH")
            else
                Exp.SkiProtocolCase = 1;
            end



        case 3
            oldGateSpeed=gateSpeed;
            error=mean(get(gameObj.gate.flag(Exp.nextGate),'XData'));
            if mod(Exp.nextGate,2)==0 && error>0
                error=-abs(error);
            elseif mod(Exp.nextGate,2)==0
                error=abs(error); 

            end
            
            %potentially move to after data is collected, will ask others - Tommy
            if(error<0)
                gateSpeed=gateSpeed*0.9; %change back to *0.25 when done with testing;
                disp("oops")
            end

            speedData(Exp.nextGate)=gateSpeed;
            timeData(Exp.nextGate)=currentTime;
            errorData(Exp.nextGate)=error;
            disp("data please "+Exp.nextGate );
            if(Exp.nextGate<Exp.totalGates)
                Exp.nextGate=Exp.nextGate+1;
                Exp.SkiProtocolCase=2;
            else
                disp("snipers on roof");
                Exp.SkiProtocolCase=4;
            end
        case 4
            Exp.nextGate=12;
            set(gatesPassedMessage,'string',strcat("Gates Passed: ",num2str(Exp.nextGate),'/12'));
            gateSpeed=0;
            idealTrajPatch.FaceColor='none';
            gameObj.slope.FaceColor="none";
            gameObj.slope.EdgeColor="none";
            gameObj.skier.FaceColor="none";
            gameObj.skier.EdgeColor="none";
            for n=1:Exp.totalGates
                gameObj.gate.flag(n).FaceColor="none";
                gameObj.gate.flag(n).EdgeColor="none";
                gameObj.gate.leftLeg(n).FaceColor="none";
                gameObj.gate.leftLeg(n).EdgeColor="none";
                gameObj.gate.rightLeg(n).FaceColor="none";
                gameObj.gate.rightLeg(n).EdgeColor="none";
            end
            ax.Projection="orthographic";
                    
            timeMessage.Position=[-300 40 40];
            gatesPassedMessage.Position=[-300 0 0];
            speedMessage.Position=[-300 -40 -40];
            disp(speedData);
            Exp.done=true;
            
            figure(200)
            hold on
            bar(speedData);
            ylabel('Downhill Speed')
            xlabel('Baseline                                            Eval');
            %plot(errorData);
            plot((errorData/10));
    end
    
end




hold on


function gateMovements(~)

global SystemParams force gatePos
XScale = 200;

%move vehicle according to ode45
tspan = SystemParams.tspan;
time_force = SystemParams.time_force;
force_array = [0; 0] + force;

[tt,yy] = ode45(@(t,y)odefun_slidingblock_skiing(t,y, time_force, force_array, SystemParams), SystemParams.tspan, SystemParams.y0);
SystemParams.y0 = yy(end,:);

gatePos = round(XScale * yy(1,1));
%gatePos =1;
%disp('test');
end

function [xdot] = odefun_slidingblock_skiing(time, statevec,time_force0, force0, SystemParams)
x1=statevec(1);
x2=statevec(2);

Inert1= SystemParams.Inertia;
bb= SystemParams.Damping;
force = interp1(time_force0,force0,time); % Interpolate the data set (ft,f) at time t

%Express equation of motion as n first order differential equations
x1dot=x2;

x2dot=(1/Inert1)*(force-bb*x2);

xdot=[x1dot; x2dot];
end