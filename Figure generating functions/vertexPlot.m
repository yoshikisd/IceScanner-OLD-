% Plots the detected vertices
function vertexPlot(app,axes)
    % Show the analysis window
    app.TabGroupAnalysis.SelectedTab = app.AnalysisTab;

    % Show topography image
    general_imageDisplay(app,axes,app.vd.xasGrid(:,:,1));
    hold(axes,'on');

    % Figure out the ASI type and plot vertices accordingly (if differentiation between the two reference images are required)
    switch app.vd.typeASI
        case {'Square' , 'Kagome','Tetris'}
            for i = 1:length(app.vd.minLoc)
                plot(axes,app.vd.minLoc(i,2),app.vd.minLoc(i,1),'b+','MarkerSize',14); 
            end
        case 'Brickwork'
            for i = 1:length(app.vd.minLoc)
                switch app.vd.minLoc(i,4)
                    case 1
                        plot(axes,app.vd.minLoc(i,2),app.vd.minLoc(i,1),'b+','MarkerSize',13);
                    case 2
                        plot(axes,app.vd.minLoc(i,2),app.vd.minLoc(i,1),'gx','MarkerSize',13);
                end
            end
        otherwise % If the ASI type has not been provided or is invalid
            uialert(app.IceScannerUI,'Please change the ASI type.');
    end
    hold(axes,'off');
end