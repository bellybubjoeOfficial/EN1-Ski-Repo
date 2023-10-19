function [xdot] = odefun_slidingblock_ski(time, statevec,time_force0, force0, SystemParams)
x1=statevec(1);
x2=statevec(2);

Inert1= SystemParams.Inertia;
bb= SystemParams.Damping;
force = interp1(time_force0,force0,time); % Interpolate the data set (ft,f) at time t

%Express equation of motion as n first order differential equations
x1dot=x2;

x2dot=(1/Inert1)*(force-bb*x2);

xdot=[x1dot; x2dot];