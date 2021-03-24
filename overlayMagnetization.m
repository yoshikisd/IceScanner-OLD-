% Plots the magnetization vectors over an image
function overlayMagnetization(app,axisFrame)
    app.vd.whiteOffsetX = vertcat(app.vd.magnet(vertcat(app.vd.magnet.projection) == 1).spinPlotXOffset);
    app.vd.whiteOffsetY = vertcat(app.vd.magnet(vertcat(app.vd.magnet.projection) == 1).spinPlotYOffset);
    app.vd.whiteVectorX = 14*cosd(vertcat(app.vd.magnet(vertcat(app.vd.magnet.projection) == 1).spinAngle));
    app.vd.whiteVectorY = 14*sind(vertcat(app.vd.magnet(vertcat(app.vd.magnet.projection) == 1).spinAngle));
    app.vd.blackOffsetX = vertcat(app.vd.magnet(vertcat(app.vd.magnet.projection) == -1).spinPlotXOffset);
    app.vd.blackOffsetY = vertcat(app.vd.magnet(vertcat(app.vd.magnet.projection) == -1).spinPlotYOffset);
    app.vd.blackVectorX = 14*cosd(vertcat(app.vd.magnet(vertcat(app.vd.magnet.projection) == -1).spinAngle));
    app.vd.blackVectorY = 14*sind(vertcat(app.vd.magnet(vertcat(app.vd.magnet.projection) == -1).spinAngle));

    hold(axisFrame,'on');
    quiver(axisFrame,app.vd.whiteOffsetX,app.vd.whiteOffsetY,app.vd.whiteVectorX,app.vd.whiteVectorY,'b',...
        'AutoScale','off','LineWidth',1);
    quiver(axisFrame,app.vd.blackOffsetX,app.vd.blackOffsetY,app.vd.blackVectorX,app.vd.blackVectorY,'r',...
        'AutoScale','off','LineWidth',1);
    hold(axisFrame,'off');
end