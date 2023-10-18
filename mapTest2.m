close
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


slope=patch([-100 100 100 -100],[-5 -5 1205 1210],[0 0 0 0],[0.7 0.7 0.7]);
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
%axis.CameraViewAngle=8;
ax.Projection='perspective';
grid off
axis off

%patch(flagXPoints,[605 605 605 605],flagZPoints);


xVals=[0 10 10 0 ];
yVals=[0 0 20 20 ];
zVals=[0 0 30 30 ];
%patch(xVals,yVals,zVals,'g');


deltaX=10;
gate.X1=ones(1,12);
gate.X2=gate.X1+deltaX;
gate.Y1=[1,2,3,4,5,6,7,8,9,10,11,12]*100+5;
deltaY=-5;
gate.Y2=gate.Y1+deltaY;
deltaZ=10;
gate.Z1=10;
gate.Z2=gate.Z1+deltaZ;
deltaLeg=deltaZ*2;  


for i=1:12
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
while(counter<1000)
    counter=counter+1;
    pause(0.01)
    for i=1:12
        set(gate.flag(i),'YData',get(gate.flag(i),'YData')-1);
        set(gate.leftLeg(i),'YData',get(gate.leftLeg(i),'YData')-1);
        set(gate.rightLeg(i),'YData',get(gate.rightLeg(i),'YData')-1);
        if get(gate.flag(i),'YData')<0
           set(gate.flag(i),'YData',get(gate.flag(i),'YData')+1205);
           set(gate.rightLeg(i),'YData',get(gate.rightLeg(i),'YData')+1205) 
           set(gate.leftLeg(i),'YData',get(gate.leftLeg(i),'YData')+1205) 
        end
    end
end



hold on
