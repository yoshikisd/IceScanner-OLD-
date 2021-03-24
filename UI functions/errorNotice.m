% Notifies the user of an error
function errorNotice(app,ME)
    uialert(app.IceScannerUI,sprintf('MATLAB has reported the following error:\n\n%s\n\nCheck for any zero/undefined parameters',...
           ME.message),'Error','Icon','error');
end