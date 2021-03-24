% Enables or disables buttons on the neighbor scan tab
function nbrScanButtonEnable(app)
    switch app.vd.typeASI
        case {'Square','Brickwork','Tetris'}
            if app.vd.cross1Width == 0 || app.vd.cross1Height == 0 || app.vd.cross2Height == 0 || app.vd.cross2Width == 0
                app.ButtonPreviewScan.Enable = 0;
                app.ButtonNeighborDetect.Enable = 0;
                app.next_nbrScan.Enable = 0;
            elseif app.vd.cross1Width ~= 0 && app.vd.cross1Height ~= 0 && app.vd.cross2Height ~= 0 && app.vd.cross2Width ~= 0
                app.ButtonPreviewScan.Enable = 1;
            end
        case 'Kagome'
            if app.vd.diameter == 0
                app.ButtonPreviewScan.Enable = 0;
                app.ButtonNeighborDetect.Enable = 0;
                app.next_nbrScan.Enable = 0;
            else
                app.ButtonPreviewScan.Enable = 1;
            end
    end
end