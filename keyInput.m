function keyInput(src,event)
    global force SystemParams
    DeltaForce=0.10;
    switch event.Key
        case 'rightarrow'
            force=force-DeltaForce;
            SystemParams.Damping = 4;
        case 'leftarrow'
            force=force+DeltaForce;
            SystemParams.Damping = 4;
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
