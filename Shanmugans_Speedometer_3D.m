close
clear;

b = 50;  %inner square of the hollow beam for casting
l = 100;
x = [0 b b 0 ]; %0 10 10 breadth-10 breadth-10 10];
y = [0 l];
z = [0 0 b b ]; %0 10 10 breadth-10 breadth-10 10];
m = length(x);
xr=[x x(1)];
yr1=y(1)*ones(m+1,1);
zr=[z z(1)];
plot3(xr,yr1,zr,'k');
hold on
yr2=y(2)*ones(m+1,1);
plot3(xr,yr2,zr,'k');
hold on
for i=1:1:m
plot3([x(i) x(i)],y,[z(i) z(i)],'k');    
end
hold on


%plot3([0 10], [0 10], [0 10], 'LineWidth',2);
%{
hfig = figure(1);
myscreensize =get(0, 'screensize'); 
set(hfig, 'Position', myscreensize);
hold on;

%Axes properties%
ax=gca;
ax.Position = [0 0 1 1]; 
ax.XLim=[1 myscreensize(3)];
ax.YLim=[1 myscreensize(4)];
hold on; %keep objects 

%position & radius/angle
x=350; myscreensize(3)*0.75;      
y=50; %myscreensize(4)*0.6;
r=300;
theta = linspace(pi, 0, 100);  % <-- left half of circle
xCirc = r * cos(theta) + x;
yCirc = r * sin(theta) + y;
%}



r1=1;
theta1=0:0.01:pi;
x1=r1*cos(theta1)*21;
y1=r1*sin(theta1)*21;
outerSemiCircle=plot3(x1,zeros(1,numel(x1)),y1,'k');
bottomLine=plot3([-21 21], [0 0], [0 0],'k');
y2=y1*0.7;
x2=x1*0.7;
innerSemiCircle=plot3(x2,zeros(1,numel(x2)),y2,'k');


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
ticker=plot3([0 0],[0 0],[0 20],'g','LineWidth',2);
while(speed<200)
    set(ticker,'XData',[0 -20*cos(pi*speed/200)]);
    set(ticker,'ZData',[0 20*sin(pi*speed/200)]);
    speed=speed+1;
    pause(0.1);
end

%{
% inner circle
innerCircOffset = 20; 
rad3 = rad2 -innerCircOffset;
xInCirc = rad3*  cos(theta) + x -10;
yInCirc = rad3 *sin(theta)+ y;
plot(xInCirc, yInCirc, 'k-', 'linewidth', 1)


%plot
plot(xCirc, yCirc, 'k-', 'linewidth', 2) % circle
plot([x-r x+r], [y y], 'k-', 'linewidth', 2) %semi circle line
plot3([x-r x+r], [y y], [0 y], 'k-', 'linewidth', 2) %semi circle line
hold on;


% ticker
theta2 = linspace(pi, 0, maxSpeed); %all speeds need to be rounded
currSpeed = 20; %adjust with program
ticker = plot([x x-rad3], [y y], 'g', 'linewidth', 2); %semi circle line
hold on; 


 k = 1;
%insert moving ticker in while loop
while true 
    placeHolderSpeed = k; %replace with legit speed 
    newxPos = rad3 *  cos(theta2(placeHolderSpeed)) + x -10;
    newyPos =  rad3 *  sin(theta2(placeHolderSpeed)) + y -10;
    set(ticker, 'XData', [x newxPos], 'YData', [y newyPos]);
    pause(0.1);
    k = k+1; 
    %temp
    if(k == maxSpeed)
        break
    end
end 
%}