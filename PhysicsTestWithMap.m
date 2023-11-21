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
boxPart1=plot3(xr,yr1,zr,'k');
boxPart1.Color="none";%[0.7 0.7 0.7];
hold on


gameObj.slope=patch([-1000 1000 1000 -1000],[-5 -5 1205 1210],[0 0 0 0],[0.7 0.7 0.7]);
gameObj.skier=patch([0 10 6 4]-5,[5 5 5 5],[0 0 15 15],'k');


ax=gca;
ax.XLim=[1-myscreensize(3) myscreensize(3)];
ax.YLim=[0 myscreensize(4)];


ax.CameraPosition=[0 -5 10];
ax.CameraTarget=[0 5 5];
disp(ax.Projection)
ax.Projection='perspective';
grid off
axis off




%xVals=[30 10 30 30]-50;
%yVals=[10 10 20 20 ];
%zVals=[10 10 30 30 ];
%patch(xVals,yVals,zVals,'g');
gateSpeed=0;

Exp.gateNum=12;
Exp.gateDistance=75;%300;
deltaX=10;
gameObj.gate.X1=ones(1,4);
gameObj.gate.X2=gameObj.gate.X1+deltaX;
gameObj.gate.Y1=[1:Exp.gateNum]*Exp.gateDistance;
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


for i=1:Exp.gateNum%round(Exp.gateNum/2)
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
gateSpeed = 1;
Exp.terminalSpeed = 9.8; %tune later

%stopwatch message
xPos7 = myscreensize(3)*(0.1/5);
yPos7= myscreensize(4)*(0.1/5);
timeMessage = text(xPos7, yPos7, 20.153, '0', 'FontSize', 20);
speedMessage = text(xPos7+14, yPos7, 15.153, 'j', 'FontSize', 20);
gatesPassedMessage = text(xPos7+7, yPos7, 18.153, 'j', 'FontSize', 20);

%stopwatch begin
startTime = tic(); % Start the stopwatch
elapsedTime = 0;
Exp.gatesPassed=0;
speedString= "";
%outputStates = [elapsedTime,speedString,Exp.gatesPassed];

gatePos_old=gatePos;
Exp.SkiProtocolCase=0;

while(Exp.gatesPassed<=Exp.gateNum)
    currentTime = toc(startTime);
    elapsedTime = round(currentTime, 2); % Round to 2 decimal places
    update_Time(timeMessage, elapsedTime); %update function
    speedString = strcat("Speed: ",num2str(gateSpeed^2));
    outputStates = [elapsedTime,speedString,Exp.gatesPassed];
    set(speedMessage,'string',speedString);
    set(gatesPassedMessage,'string',strcat('Gates Passed: ',num2str(outputStates(3)),'/12'));
    %set(gatesPassedMessage,'string',strcat('Force: ',num2str(force)));
    Exp.counter=Exp.counter+1;
    gateSpeed = gateSpeed + (Exp.counter/20000);
    if (gateSpeed >= Exp.terminalSpeed)
        gateSpeed = Exp.terminalSpeed;
    end

    pause(0.01);
    for i=1:Exp.gateNum
        
        gateMovements();

        set(gameObj.gate.flag(i),'YData',get(gameObj.gate.flag(i),'YData')-gateSpeed/4);
        set(gameObj.gate.leftLeg(i),'YData',get(gameObj.gate.leftLeg(i),'YData')-gateSpeed/4);
        set(gameObj.gate.rightLeg(i),'YData',get(gameObj.gate.rightLeg(i),'YData')-gateSpeed/4);
        
        set(gameObj.gate.flag(i),'XData',get(gameObj.gate.flag(i),'XData')+gatePos);
        set(gameObj.gate.leftLeg(i),'XData',get(gameObj.gate.leftLeg(i),'XData')+gatePos);
        set(gameObj.gate.rightLeg(i),'XData',get(gameObj.gate.rightLeg(i),'XData')+gatePos);
        
  
        if mean(get(gameObj.gate.flag(i),'YData'))<=5
             if(mod(i,2) == 1 && mean(get(gameObj.gate.flag(i), 'XData')) <= mean(get(gameObj.skier, 'XData')))
                gateSpeed = gateSpeed * 0.25;
             end
             if(mod(i,2) == 0 && mean(get(gameObj.gate.flag(i), 'XData')) >= mean(get(gameObj.skier, 'XData')))        
                gateSpeed = gateSpeed * 0.25;
             end
         Exp.gatesPassed=Exp.gatesPassed+1;
            if(Exp.gatesPassed<Exp.gateNum)
                set(gameObj.gate.flag(i),'YData',zeros(1:4)+(Exp.gateNum*Exp.gateDistance));
                set(gameObj.gate.rightLeg(i),'YData',zeros(1:4)+(Exp.gateNum*Exp.gateDistance))
                set(gameObj.gate.leftLeg(i),'YData',zeros(1:4)+(Exp.gateNum*Exp.gateDistance))
            end 
        end
        
    end
    kinemats.speed=gateSpeed*(200/Exp.terminalSpeed);

end


gameObj.slope.FaceColor="none";
gameObj.slope.EdgeColor="none";
gameObj.skier.FaceColor="none";
gameObj.skier.EdgeColor="none";
for n=1:Exp.gateNum
gameObj.gate.flag(n).FaceColor="none";
gameObj.gate.flag(n).EdgeColor="none";
gameObj.gate.leftLeg(n).FaceColor="none";
gameObj.gate.leftLeg(n).EdgeColor="none";
gameObj.gate.rightLeg(n).FaceColor="none";
gameObj.gate.rightLeg(n).EdgeColor="none";
end
ax.Projection="orthographic";

timeMessage.Position=[-300 40 40];
speedMessage.Position=[-300 0 0];
gatesPassedMessage.Position=[-300 -40 -40];



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