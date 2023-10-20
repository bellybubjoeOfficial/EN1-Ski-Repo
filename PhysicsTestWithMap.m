close

global SystemParams force gatePos

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
boxPart1.Color=[0.7 0.7 0.7];
hold on


slope=patch([-1000 1000 1000 -1000],[-5 -5 1205 1210],[0 0 0 0],[0.7 0.7 0.7]);
skier=patch([0 10 4 6]-5,[5 5 5 5],[0 0 15 15],'k');


ax=gca;

disp('axis.CameraPosition');
disp(ax.CameraPosition);
disp('axis.CameraTarget');
disp(ax.CameraTarget);
disp('axis.CameraViewAngle');
disp(ax.CameraViewAngle);

ax.CameraPosition=[0 -5 10];
ax.CameraTarget=[0 5 5];
%ax.Projection='perspective';
grid off
axis off



r1=1;
theta1=0:0.01:pi;
x1=r1*cos(theta1)*21;
y1=r1*sin(theta1)*21;
outerSemiCircle=plot3(1.5*x1-100,y1+150,(y1)/2+10,'k');
bottomLine=plot3([-131.5 -68.5], [150 150], [10 10],'k');
y2=y1*0.7;
x2=x1*0.7;
innerSemiCircle=plot3(x2-100,y2+150,y2/2+10,'k');
ticker=plot3([-100 -100],[150 150],[0 20],'g','LineWidth',2);


%numerical information
minSpeed = 0;
maxSpeed = 200;
numOfPoints = 11;
numbersUnRound = linspace(minSpeed, maxSpeed, numOfPoints);
numbers = round(numbersUnRound);
positionOfSpeed = linspace(pi, 0, numOfPoints);
rad2 = r1 - 70;
%play around with offset values
xOffset = x -20;
yOffset = y+20; 
xPos = rad2 * cos(positionOfSpeed)/4; + xOffset;
yPos = -rad2 * sin(positionOfSpeed)/4; +yOffset;

for kk = 1:numOfPoints
    s = strcat(num2str(numbers(numOfPoints-kk+1)));
    disp(numbers(kk))
    mymessage = text(xPos(kk)-1.5, 0, yPos(kk)+1, s, 'FontSize', 10);
end

startSpeed=1;
speed=startSpeed;
maxSpeed=200;


xVals=[0 10 10 0 ];
yVals=[0 0 20 20 ];
zVals=[0 0 30 30 ];
%patch(xVals,yVals,zVals,'g');

gateNum=2;
deltaX=10;
gate.X1=ones(1,4);
gate.X2=gate.X1+deltaX;
gate.Y1=[1:gateNum]*300;
deltaY=-5;
gate.Y2=gate.Y1+deltaY;
deltaZ=10;
gate.Z1=10;
gate.Z2=gate.Z1+deltaZ;
deltaLeg=deltaZ*2;  

%ode params
timer02.Period=0.01;
tspan = [0, timer02.Period];
time_force = tspan;
SystemParams.tspan = tspan;
SystemParams.time_force = time_force;
SystemParams.Inertia = 1.0;
SystemParams.Damping = 5;
SystemParams.y0 = [0 0];
force = 0;


for i=1:gateNum
    gate.X1(i)=50*(-1)^i;
    gate.X2=gate.X1+deltaX;
    legXPoints=[gate.X1(i) gate.X1(i)+2 gate.X1(i)+2 gate.X1(i)];

    flagXPoints=[gate.X1(i) gate.X2(i) gate.X2(i) gate.X1(i)];
    flagYPoints=[gate.Y1(i) gate.Y1(i) gate.Y2(i) gate.Y2(i)];
    flagZPoints=[gate.Z1 gate.Z1 gate.Z2 gate.Z2];
    gate.flag(i)=patch(flagXPoints,flagYPoints,flagZPoints,[1 0.33 0.33]);
    gate.leftLeg(i)=patch(legXPoints,flagYPoints-deltaY,(flagZPoints-deltaZ),[1 0.33 0.33]);
    gate.rightLeg(i)=patch(legXPoints+(deltaX-2),flagYPoints-deltaY,(flagZPoints-deltaZ),[1 0.33 0.33]);

    if(mod(i,2)==1)
        set(gate.flag(i),'FaceColor',[0.33 0.33 1]);
        set(gate.leftLeg(i),'FaceColor',[0.33 0.33 1]);
        set(gate.rightLeg(i),'FaceColor',[0.33 0.33 1]);
    end
end



counter=0;
gateSpeed = 1;
terminalSpeed = 5; %tune later

while(counter<5000)
    counter=counter+1;
    gateSpeed = 1 + (counter/20);
    if (gateSpeed >= terminalSpeed)
        gateSpeed = terminalSpeed;
    end

    pause(0.01)
    for i=1:gateNum
        set(gate.flag(i),'YData',get(gate.flag(i),'YData')-gateSpeed);
        set(gate.leftLeg(i),'YData',get(gate.leftLeg(i),'YData')-gateSpeed);
        set(gate.rightLeg(i),'YData',get(gate.rightLeg(i),'YData')-gateSpeed);

        gateMovements();
        
        set(gate.flag(i),'XData',get(gate.flag(i),'XData')+gatePos);
        set(gate.leftLeg(i),'XData',get(gate.leftLeg(i),'XData')+gatePos);
        set(gate.rightLeg(i),'XData',get(gate.rightLeg(i),'XData')+gatePos);

        if get(gate.flag(i),'YData')<0
           set(gate.flag(i),'YData',zeros(1:4)+900);
           set(gate.rightLeg(i),'YData',zeros(1:4)+900) 
           set(gate.leftLeg(i),'YData',zeros(1:4)+900) 
        elseif abs(get(gate.flag(i), 'XData')) <= myscreensize(3)/2
            gateSpeed = gateSpeed - 0.4;
        end
    end
    %set(ticker,'XData',[0 -20*cos(pi*speed/200)]);
    %set(ticker,'ZData',[0 20*sin(pi*speed/200)]);
    speed=gateSpeed*(200/terminalSpeed);
    
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