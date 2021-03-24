% Plots the rough detection points from the EMD calculation    
function vertexDetect_roughDetection(app)
    % Reset the detection state
    app.xasGrid(:,:,2) = zeros(app.gridHeight,app.gridWidth); 
    app.xasGrid(:,:,3) = zeros(app.gridHeight,app.gridWidth);

    % Show the topography image
    %cla(app.AxesASITopography);
    imshow(app.xasGrid(:,:,1),'Parent',app.AxesASITopography,'InitialMagnification','fit');

    % Apply thresholds
    threshold1 = min(app.emdGlobalRef1(:,:,1),[],'all','omitnan') + app.thresholdFactor1*(std(app.emdGlobalRef1(:,:,1),0,'all','omitnan'));
    switch app.typeASI
        case {'Brickwork','Kagome'}
            threshold2 = min(app.emdGlobalRef2(:,:,1),[],'all','omitnan') + app.thresholdFactor2*(std(app.emdGlobalRef2(:,:,1),0,'all','omitnan'));
        case 'Tetris'
            threshold2 = min(app.emdGlobalRef2(:,:,1),[],'all','omitnan') + app.thresholdFactor2*(std(app.emdGlobalRef2(:,:,1),0,'all','omitnan'));
            threshold3 = min(app.emdGlobalRef3(:,:,1),[],'all','omitnan') + app.thresholdFactor3*(std(app.emdGlobalRef3(:,:,1),0,'all','omitnan'));
            threshold4 = min(app.emdGlobalRef4(:,:,1),[],'all','omitnan') + app.thresholdFactor4*(std(app.emdGlobalRef4(:,:,1),0,'all','omitnan'));
            threshold5 = min(app.emdGlobalRef5(:,:,1),[],'all','omitnan') + app.thresholdFactor5*(std(app.emdGlobalRef5(:,:,1),0,'all','omitnan'));
            threshold6 = min(app.emdGlobalRef6(:,:,1),[],'all','omitnan') + app.thresholdFactor6*(std(app.emdGlobalRef6(:,:,1),0,'all','omitnan'));
            threshold7 = min(app.emdGlobalRef7(:,:,1),[],'all','omitnan') + app.thresholdFactor7*(std(app.emdGlobalRef7(:,:,1),0,'all','omitnan'));
            threshold8 = min(app.emdGlobalRef8(:,:,1),[],'all','omitnan') + app.thresholdFactor8*(std(app.emdGlobalRef8(:,:,1),0,'all','omitnan'));
    end

    hold(app.AxesASITopography,'on');
    % Rough detection of minimas below a certain threshold in the reference 1 EMD
    switch app.typeASI
        case 'Square' % For the square ice case
            for j = 1:app.jRangeSize
                for i = 1:app.iRangeSize
                    if app.emdGlobalRef1(j,i,1) <= threshold1
                        app.xasGrid(app.emdGlobalRef1(j,i,3),app.emdGlobalRef1(j,i,2),2) = 1;                       % Indicate what frame detected this
                        app.xasGrid(app.emdGlobalRef1(j,i,3),app.emdGlobalRef1(j,i,2),3) = app.emdGlobalRef1(j,i,1);    % Store the detected intensity
                        plot(app.AxesASITopography,app.emdGlobalRef1(j,i,2),app.emdGlobalRef1(j,i,3),'r.','MarkerSize',10)
                    end
                end
            end
        case {'Brickwork','Kagome'} % For brickwork or kagome
            for j = 1:app.jRangeSize
                for i = 1:app.iRangeSize
                    if app.emdGlobalRef1(j,i,1) <= threshold1
                        app.xasGrid(app.emdGlobalRef1(j,i,3),app.emdGlobalRef1(j,i,2),2) = 1;                       % Indicate what frame detected this
                        app.xasGrid(app.emdGlobalRef1(j,i,3),app.emdGlobalRef1(j,i,2),3) = app.emdGlobalRef1(j,i,1);    % Store the detected intensity
                        plot(app.AxesASITopography,app.emdGlobalRef1(j,i,2),app.emdGlobalRef1(j,i,3),'r.','MarkerSize',10)
                    end
                    if app.emdGlobalRef2(j,i,1) <= threshold2
                        app.xasGrid(app.emdGlobalRef2(j,i,3),app.emdGlobalRef2(j,i,2),2) = 2;                       % Indicate what frame detected this
                        app.xasGrid(app.emdGlobalRef2(j,i,3),app.emdGlobalRef2(j,i,2),3) = app.emdGlobalRef2(j,i,1);    % Store the detected intensity
                        plot(app.AxesASITopography,app.emdGlobalRef2(j,i,2),app.emdGlobalRef2(j,i,3),'r.','MarkerSize',10)
                    end
                end
            end
        case 'Tetris'
            for j = 1:app.jRangeSize
                for i = 1:app.iRangeSize
                    if app.emdGlobalRef1(j,i,1) <= threshold1
                        app.xasGrid(app.emdGlobalRef1(j,i,3),app.emdGlobalRef1(j,i,2),2) = 1;                       % Indicate what frame detected this
                        app.xasGrid(app.emdGlobalRef1(j,i,3),app.emdGlobalRef1(j,i,2),3) = app.emdGlobalRef1(j,i,1);    % Store the detected intensity
                        plot(app.AxesASITopography,app.emdGlobalRef1(j,i,2),app.emdGlobalRef1(j,i,3),'r.','MarkerSize',10)
                    end
                    if app.emdGlobalRef2(j,i,1) <= threshold2
                        app.xasGrid(app.emdGlobalRef2(j,i,3),app.emdGlobalRef2(j,i,2),2) = 2;                       % Indicate what frame detected this
                        app.xasGrid(app.emdGlobalRef2(j,i,3),app.emdGlobalRef2(j,i,2),3) = app.emdGlobalRef2(j,i,1);    % Store the detected intensity
                        plot(app.AxesASITopography,app.emdGlobalRef2(j,i,2),app.emdGlobalRef2(j,i,3),'r.','MarkerSize',10)
                    end
                    if app.emdGlobalRef3(j,i,1) <= threshold3
                        app.xasGrid(app.emdGlobalRef3(j,i,3),app.emdGlobalRef3(j,i,2),2) = 3;                       % Indicate what frame detected this
                        app.xasGrid(app.emdGlobalRef3(j,i,3),app.emdGlobalRef3(j,i,2),3) = app.emdGlobalRef3(j,i,1);    % Store the detected intensity
                        plot(app.AxesASITopography,app.emdGlobalRef3(j,i,2),app.emdGlobalRef3(j,i,3),'r.','MarkerSize',10)
                    end
                    if app.emdGlobalRef4(j,i,1) <= threshold4
                        app.xasGrid(app.emdGlobalRef4(j,i,3),app.emdGlobalRef4(j,i,2),2) = 4;                       % Indicate what frame detected this
                        app.xasGrid(app.emdGlobalRef4(j,i,3),app.emdGlobalRef4(j,i,2),3) = app.emdGlobalRef4(j,i,1);    % Store the detected intensity
                        plot(app.AxesASITopography,app.emdGlobalRef4(j,i,2),app.emdGlobalRef4(j,i,3),'r.','MarkerSize',10)
                    end
                    if app.emdGlobalRef5(j,i,1) <= threshold5
                        app.xasGrid(app.emdGlobalRef5(j,i,3),app.emdGlobalRef5(j,i,2),2) = 5;                       % Indicate what frame detected this
                        app.xasGrid(app.emdGlobalRef5(j,i,3),app.emdGlobalRef5(j,i,2),3) = app.emdGlobalRef5(j,i,1);    % Store the detected intensity
                        plot(app.AxesASITopography,app.emdGlobalRef5(j,i,2),app.emdGlobalRef5(j,i,3),'r.','MarkerSize',10)
                    end
                    if app.emdGlobalRef6(j,i,1) <= threshold6
                        app.xasGrid(app.emdGlobalRef6(j,i,3),app.emdGlobalRef6(j,i,2),2) = 6;                       % Indicate what frame detected this
                        app.xasGrid(app.emdGlobalRef6(j,i,3),app.emdGlobalRef6(j,i,2),3) = app.emdGlobalRef6(j,i,1);    % Store the detected intensity
                        plot(app.AxesASITopography,app.emdGlobalRef6(j,i,2),app.emdGlobalRef6(j,i,3),'r.','MarkerSize',10)
                    end
                    if app.emdGlobalRef7(j,i,1) <= threshold7
                        app.xasGrid(app.emdGlobalRef7(j,i,3),app.emdGlobalRef7(j,i,2),2) = 7;                       % Indicate what frame detected this
                        app.xasGrid(app.emdGlobalRef7(j,i,3),app.emdGlobalRef7(j,i,2),3) = app.emdGlobalRef7(j,i,1);    % Store the detected intensity
                        plot(app.AxesASITopography,app.emdGlobalRef7(j,i,2),app.emdGlobalRef7(j,i,3),'r.','MarkerSize',10)
                    end
                    if app.emdGlobalRef8(j,i,1) <= threshold8
                        app.xasGrid(app.emdGlobalRef8(j,i,3),app.emdGlobalRef8(j,i,2),2) = 8;                       % Indicate what frame detected this
                        app.xasGrid(app.emdGlobalRef8(j,i,3),app.emdGlobalRef8(j,i,2),3) = app.emdGlobalRef8(j,i,1);    % Store the detected intensity
                        plot(app.AxesASITopography,app.emdGlobalRef8(j,i,2),app.emdGlobalRef8(j,i,3),'r.','MarkerSize',10)
                    end
                end
            end
    end
    app.AxesASITopography.XLim = [0 app.gridWidth];
    app.AxesASITopography.YLim = [0 app.gridHeight];
    hold(app.AxesASITopography,'off');
end