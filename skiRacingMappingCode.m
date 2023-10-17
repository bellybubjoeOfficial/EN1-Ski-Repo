%drawing conditions
clear; %clearsvariables
close all; %deletefigures
myscreensize=get(0,'Screensize'); %0 is the base object in Matlab
hfig=figure('Pointer','crosshair','KeyPressFcn',@keyInput); %give figure a handle

set(hfig,"MenuBar","none")
set(hfig,"ToolBar","auto")
set(hfig,'Position',myscreensize);
set(gca,'Position',[0 0 1 1])
hold on
xlim([1 myscreensize(3)])
ylim([1 myscreensize(4)])

global skier SystemParams force

force=0.1;
%2D Map

gates.xVals=zeros(1,12);
gates.yVals= (myscreensize(4)-100)-([1:12]* 65);
skier=rectangle('Position',[myscreensize(3)/2 650 15 20],'FaceColor','k');


for i=1:1:12
    gates.xVals(i)=myscreensize(3)/2+sin(pi*gates.yVals(i)+pi/2)*50;    
end


%gates=ones(10);
%rightLeg=ones(10);
%leftLeg=ones(10);

gates.flag=ones(12);
gates.rightLeg=ones(12);
gates.leftLeg=ones(12);


for i=1:1:12
    if(mod(i,2)==0)
        gates.xVals(i)=round(gates.xVals(i)+(0.1*(i)^2)-10);
        gates.flag(i)=plot(gates.xVals(i),gates.yVals(i),'s','markersize',20,'MarkerFaceColor',[0.5 0.5 0.8],'MarkerEdgeColor','b','LineWidth',(i/10));
        gates.leftLeg(i)=rectangle('Position',[gates.xVals(i)-10 gates.yVals(i)-29,3,20],'FaceColor',[0.5 0.5 0.8],'EdgeColor','none');
        gates.rightLeg(i)=rectangle('Position',[gates.xVals(i)+7 gates.yVals(i)-29,3,20],'FaceColor',[0.5 0.5 0.8],'EdgeColor','none');
        
    else
        gates.xVals(i)=round(gates.xVals(i)-(0.1*(i)^2)+10);
        gates.leftLeg(i)=rectangle('Position',[gates.xVals(i)-10 gates.yVals(i)-29,3,20],'FaceColor',[0.9 0.5 0.5],'EdgeColor','none');%[0.4 0.25 0.25]);
        gates.rightLeg(i)=rectangle('Position',[gates.xVals(i)+7 gates.yVals(i)-29,3,20],'FaceColor',[0.9 0.5 0.5],'EdgeColor','none');%[0.4 0.25 0.25]);
        gates.flag(i)=plot(gates.xVals(i),gates.yVals(i),'s','markersize',20,'MarkerFaceColor',[0.9 0.5 0.5],'MarkerEdgeColor','none');
    end
end

counter=0;
while(counter<1000)
    gates=gateMvmt(gates,counter,myscreensize);
    counter=counter+1;
    pause(0.01)
end



function [gates] = gateMvmt(gates,counter,myscreensize)
    global force
    for i=1:12
      gates.xVals(i)=gates.xVals(i)+force;
      set(gates.flag(i),'XData',gates.xVals(i));
      gates.yVals(i)=gates.yVals(i)+1;
      %gates.xVals(i)=gates.xVals(i)+1
      set(gates.flag(i),'YData',gates.yVals(i));
      set(gates.leftLeg(i),'Position',[gates.xVals(i)-10 gates.yVals(i)-29,3,20]);
      set(gates.rightLeg(i),'Position',[gates.xVals(i)+7 gates.yVals(i)-29,3,20]);
      if(gates.yVals(i)>myscreensize(4))
          gates.yVals(i)=gates.yVals(i)-65*12;
      end
    end
 
    return 
end


%{
%Settings for simulation
dt = 0.01;
tSpan = 0:dt:30;
y0 = [0 0]; %initial conditions for position and velocity
pulseVal = 10;
errorX=1;

forces=zeros(length(tSpan),1)+0;
forces(1:10) = pulseVal;
force_array=[];
SystemParams.force_array=force_array;

SystemParams.inertia=10.0;
SystemParams.damping=-5.0;



%{
[t,y] = ode45 (@(t,y) odefun_slidingblock (t,y,tSpan, forces, SystemParams), tSpan, y0);

disp((hfig.Position(4)-720)*10);
for i=1:length(y)
        Ynow=round(100*y(i,1)+50);%*sin((hfig.Position(4)-720)*10);
        pause(0.01)
        skier.Position(2)=650-Ynow;
end
%}

time=0;

timer01=timer;
timer01.StartDelay=0;
timer01.ExecutionMode='fixedRate';
timer01.TimerFcn=@(~,~)skierPositionUpdate;
timer01.Period=0.01;
timer01.TasksToExecute=1000;

%System parameters
timeSpan=[0 timer01.period];
time_force=timeSpan;
force0=zeros(length(timeSpan),1);
SystemParams.timeSpan=timeSpan;
SystemParams.inertia=100;
SystemParams.damping=2.5;
SystemParams.y0=[0 0];
force=5;

start(timer01);

function skierPositionUpdate()
    global skier SystemParams force
    skier.FaceColor='g';
    force_array=zeros(length(SystemParams.timeSpan),1)+force;
    y0= [1] * force;
    if(isempty(force_array))
        force_array=[0;0]+force;
    else
        force_array=force_array+force;
    end
    [t,y] = ode45 (@(t,y)odefun_slidingblock (t,y,SystemParams.timeSpan, force_array, SystemParams), SystemParams.timeSpan, y0);
    %SystemParams.y0=y(end,:);

    %skier.Position(2)=(round(100*yy(1,1)+650));
    %SystemParams.force_array=force_array;
end
%}



function keyInput(src,event)
    global force
    DeltaForce=0.10;
    switch event.Key
        case 'rightarrow'
            force=force+DeltaForce;
        case 'leftarrow'
            force=force-DeltaForce;
        case 'uparrow'
            force=force-0;
        case 'downarrow'
            force=force-0;
        case 'escape'
            close
        otherwise
    end
end