function gateMovement(~)

global SystemParams force gatePos
XScale = 200;

%move vehicle according to ode45
tspan = SystemParams.tspan;
time_force = SystemParams.time_force;
force_array = [0; 0] + force;

[tt,yy] = ode45(@(t,y)odefun_slidingblock_ski(t,y, time_force, force_array, SystemParams), SystemParams.tspan, SystemParams.y0);
SystemParams.y0 = yy(end,:);

%gatePos = round(XScale * yy(1,1));
gatePos = 1;
disp('test');
