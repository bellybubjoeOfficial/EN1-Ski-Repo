hfig = figure(1);
myscreensize =get(0, 'screensize'); 
set(hfig, 'Position', myscreensize);
hold on;


%make stopwatch message message;
xPos = myscreensize*0.2;
yPos= myscreensize*0.8;
mymessage = text(xPos, yPos, '0', 'FontSize', 20);

%random code
x=2
startTime = tic(); % Start the stopwatch
elapsedTime = 0;

%while loop
while (true)
    currentTime = toc(startTime);
    elapsedTime = round(currentTime, 2); % Round to 2 decimal places
    updateTime(mymessage, elapsedTime); %update function
    x= 1;
    y = 2*x;
    z = y*3; 
    x=z*y;
    pause(0.01);
end
