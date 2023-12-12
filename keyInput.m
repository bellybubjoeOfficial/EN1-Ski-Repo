function keyInput(src,event)
    global force SystemParams gateSpeed gameMode
    switch event.Key
        case 'leftarrow'
            force=abs(force);    
            if(force<=1 && force < gateSpeed)
               force=force+0.01; 
            end
            
        case 'rightarrow'
            force = -abs(force);
            if(force>=-1 && force < gateSpeed)
               force=force-0.01; 
            end
        case 'uparrow'
        %    gateSpeed=gateSpeed*1.001;
        case 'downarrow'
        %    gateSpeed=gateSpeed/1.1;
        case 'k'
            gateSpeed=-1;
            close
        case 'space'
            disp('funcional')
            if(gateSpeed<=0)
                gateSpeed=1;
                gameMode="trial";
            end
        otherwise
            SystemParams.Damping = 2.5;
    end
end
