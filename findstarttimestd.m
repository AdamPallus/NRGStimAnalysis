%Calculates start of movement based on 2x standard deviation thresholds
function t=findstarttimestd(head,eye)
   
if isfield(head,'hpstim') 
    meye=mean(eye.eagap');
    seye=std(eye.eagap');
    
    meye=meye(550:end)';
    seye=seye(550:end)';
    
    mhead=mean(head.hagap');
    shead=std(head.hagap');
    
    mhead=mhead(550:end)';
    shead=shead(550:end)';
    
    for i =1:size(eye.eastim,2)
        stiminds=find(eye.eastim(550:end,i)>meye+2*seye);
        estart(i)=stiminds(1);
        
        stiminds=find(head.hastim(550:end,i)>mhead+2*shead);
        hstart(i)=stiminds(1);
    end   
    rightward=head.hpstim(1800,:)>0;
    d=repmat('R',[length(hstart),1]);
    d(rightward)='R';
    d(~rightward)='L';
else
    
    for i =1:size(eye.eastim,2)
        meye=mean(eye.eastim(1:50,i));
        seye=std(eye.eastim(1:50,i));
        xx=find(eye.eastim(51:end,i)<(meye-2*seye) | eye.eastim(51:end,i)>(meye+2*seye));
        if isempty(xx)
            estart(i)=NaN;
        else
            estart(i)=xx(1);
        end
        mhead=mean(head.hastim(1:50,i));
        shead=std(head.hastim(1:50,i));
        xx=find(head.hastim(51:end,i)<(mhead-2*shead) | head.hastim(51:end,i)>(mhead+2*shead));
        if isempty(xx)
            hstart(i)=NaN;
        else
            hstart(i)=xx(1);
        end
    end
    d=repmat('S',[length(hstart),1]);
end

    t=table(estart',hstart',d,'variablenames',{'E','H','Dir'});
    
end



