function keyInput(src,event)
    global force SystemParams gateSpeed
    DeltaForce=0.001;
    maxForce=1;
    minForce=-1;
    switch event.Key
        case 'rightarrow'
            if(force>minForce)
                force=force-DeltaForce;
            end
            if(force>0)
                force=-force;
            end
            SystemParams.Damping = 4;
            gateSpeed=gateSpeed-0.01;
        case 'leftarrow'
            if(force<maxForce)
                force=force+DeltaForce;
            end
            if(force<0)
                force=abs(force);
            end
            SystemParams.Damping = 4;
            gateSpeed=gateSpeed-0.01;
        case 'uparrow'
            force=force-0;
        case 'downarrow'
            force=force-0;
        case 'escape'
            close
        otherwise
            SystemParams.Damping = 2.5;
    end
end
