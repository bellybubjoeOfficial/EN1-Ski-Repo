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
plot3(xr,yr1,zr,'k');
hold on
yr2=y(2)*ones(m+1,1);
plot3(xr,yr2,zr,'k');
hold on
for i=1:1:m
plot3([x(i) x(i)],y,[z(i) z(i)],'k');    
end
hold on

deltaX=10;
gate.X1=ones(1,12);
gate.X2=gate.X1+deltaX;
gate.Y=[1:12]*100+5;
deltaZ=10;
gate.Z1=25;
gate.Z2=gate.Z1+deltaZ;
deltaLeg=deltaZ*2;  

slope=patch([-100 100 100 -100 -100],[0 0 605 605 0],[15 15 15 15 15],[0.7 0.7 0.7]);

for i=1:12
    gate.X1(i)=50*(-1)^i;
    gate.X2=gate.X1+deltaX;
    flagXPoints=[gate.X1(i) gate.X2(i) gate.X2(i) gate.X1(i) gate.X1(i)];
    legXPoints=[gate.X1(i) gate.X1(i)+2 gate.X1(i)+2 gate.X1(i) gate.X1(i)];
    flagYPoints=[gate.Y(i) gate.Y(i) gate.Y(i) gate.Y(i) gate.Y(i)];
    flagZPoints=[gate.Z1 gate.Z1 gate.Z2 gate.Z2 gate.Z1];
    gate.flag(i)=patch(flagXPoints,flagYPoints,flagZPoints,[1 0.33 0.33]);
    gate.leftLeg(i)=patch(legXPoints,flagYPoints,(flagZPoints-deltaZ),[1 0.33 0.33]);
    gate.rightLeg(i)=patch(legXPoints+(deltaX-2),flagYPoints,(flagZPoints-deltaZ),[1 0.33 0.33]);
    if(mod(i,2)==1)
        set(gate.flag(i),'FaceColor',[0.33 0.33 1]);
        set(gate.leftLeg(i),'FaceColor',[0.33 0.33 1]);
        set(gate.rightLeg(i),'FaceColor',[0.33 0.33 1]);
    end
end

skier=patch([0 10 10 0 0],[5 5 5 5 5],[15 15 25 25 15],'k');

axis=gca;

disp('axis.CameraPosition');
disp(axis.CameraPosition);
disp('axis.CameraTarget');
disp(axis.CameraTarget);
disp('axis.CameraViewAngle');
disp(axis.CameraViewAngle);

%axis.CameraPosition=[10 -645 100];
%axis.CameraTarget=[0,100,60];
%axis.CameraViewAngle=8;
%axis.Projection='perspective';

patch(flagXPoints,[605 605 605 605 605],flagZPoints);

counter=0;
while(counter<1000)
    counter=counter+1;
    pause(0.01)
    for i=1:12
        set(gate.flag(i),'YData',get(gate.flag(i),'YData')-1);
        set(gate.leftLeg(i),'YData',get(gate.leftLeg(i),'YData')-1);
        set(gate.rightLeg(i),'YData',get(gate.rightLeg(i),'YData')-1);
        if get(gate.flag(i),'YData')<0
           set(gate.flag(i),'YData',[605 605 605 605 605])
           set(gate.rightLeg(i),'YData',[605 605 605 605 605]) 
           set(gate.leftLeg(i),'YData',[605 605 605 605 605]) 
        end
    end
end

    

hold on
