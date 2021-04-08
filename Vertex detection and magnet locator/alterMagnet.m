function alterMagnet(app,alterMode)
    % Alters the magnetization state of a selected magnet
    
    % Generate the image figure
    selectionFigure = figure('Name','Select magnets to mask');
    selectionFigure.MenuBar = 'none';
    selectionFigure.ToolBar = 'none';
    selectionAxes = axes(selectionFigure);
    movegui(selectionFigure,'center');
    switch app.drop_inspectionImage.Value
        case '-'
            uialert(app.IceScannerUI,'Select an image to perform manual masking of nanomagnets.','Error');
            return;
        case 'XAS'
            backgroundImage = app.vd.xasGrid(:,:,1);
        case 'XMCD'
            backgroundImage = mat2gray(app.vd.xmcd);
        case 'XMCD (more contrast)'
            backgroundImage = mat2gray(app.vd.xmcdBoost);
        case 'Absolute value of XMCD'
            backgroundImage = mat2gray(abs(app.vd.xmcd));
        case 'ROI - Regular'
            backgroundImage = mat2gray(app.vd.xmcdOriginalSkeleton);
        case 'ROI - Averaged'
            backgroundImage = mat2gray(app.vd.magnetInterpretCombinedImg);
    end

    general_imageDisplay(app,selectionAxes,backgroundImage);
    overlayMagnetization(app,selectionAxes);

    % Notify the user to select points on the popup figure that will be initiated after activation of the dialog
    switch alterMode
        case 'zeroize' 
            informOperation = 'set the magnetization to zero.';
        case 'ignore'
            informOperation = 'remove from subsequent analysis.';
        case 'flip'
            informOperation = 'have the magnetization reversed.';
    end

    alterDialog = uiprogressdlg(app.IceScannerUI,'Title','Please view the pop-up figure window','Message',...
        sprintf('%s%s\n\n%s\n\n%s',...
        'In the pop-up window, select the centers of the nanomagnets you wish to ', informOperation,...
        'To undo the last selection, press the delete/backspace key. Once you are done, press the enter key.',...
        'For this to work, the last object you click must be somewhere within the analysis window.'),'Indeterminate','on');

    % Allow user to select points for alteration
    try
        [xSelect, ySelect] = getpts(selectionAxes);
        xSelect = floor(xSelect);
        ySelect = floor(ySelect);
    catch ME
        errorNotice(app,ME);
        close(alterDialog);
        return;
    end
    
    % Store magnet x and y values in vectors
    magnetRowYLoc = vertcat(app.vd.magnet.rowYPos);
    magnetColXLoc = vertcat(app.vd.magnet.colXPos);
    
    % Perform specified operation on selected magnets
    % In this case, I put the switch statement inside the for loop since I'm running under an assumption that
    % the number of points the user selects will result in a neglegible performance hit 
    for i = 1:length(xSelect)
        % Look for the corresponding magnet coordinates in iceMagnets within a +- 10 variance along x and y
        selectIdx = find((magnetRowYLoc <= ySelect(i) + 10 & magnetRowYLoc >= ySelect(i) - 10) &...
            magnetColXLoc <= xSelect(i) + 10 & magnetColXLoc >= xSelect(i) - 10);
        % Preindex neighboring vertices for vertex calculation correction
        vtx1 = app.vd.magnet(selectIdx).nbrVertexInd(1);
        vtx2 = app.vd.magnet(selectIdx).nbrVertexInd(2);
        
        % Perform specified operation on selected magnet
        switch alterMode
            case 'zeroize' 
                % Set the magnetization equal to zero (background/ambiguous)
                app.vd.magnet(selectIdx).projection = 0;
                % Zeroize the spin vector
                app.vd.magnet(selectIdx).xSpin = 0;
                app.vd.magnet(selectIdx).ySpin = 0;
                % Set corresponding vertex types to NaN
                app.vd.vertex(vtx1).type = NaN;
                app.vd.vertex(vtx2).type = NaN;
            case 'ignore'
                % Set a flag to ignore this magnet in all subsequent analysis
                app.vd.magnet(selectIdx).ignoreFlag = true;
                % Set the magnetization equal to zero (background/ambiguous)
                app.vd.magnet(selectIdx).projection = NaN;
                % NaN spin vector
                app.vd.magnet(selectIdx).xSpin = NaN;
                app.vd.magnet(selectIdx).ySpin = NaN;
                % Set corresponding vertex types to NaN
                app.vd.vertex(vtx1).type = NaN;
                app.vd.vertex(vtx2).type = NaN;
            case 'flip'
                % Flip the projection of the magnetization
                % Here it is assumed that the user is not trying to define a null/NaN magnet
                app.vd.magnet(selectIdx).projection = app.vd.magnet(selectIdx).projection * -1;
                % Change the orientation of the spin vector
                app.vd.magnet(selectIdx).xSpin = -app.vd.magnet(selectIdx).xSpin;
                app.vd.magnet(selectIdx).ySpin = -app.vd.magnet(selectIdx).ySpin;
                % Change the corresponding spin angle
                if app.vd.magnet(selectIdx).projection ~= 0
                    app.vd.magnet(selectIdx).spinAngle = app.vd.magnet(selectIdx).spinAngle + 180;
                end
                % Recalculate vertex types
                vertexTypeAssignment(app,vtx1);
                vertexTypeAssignment(app,vtx2);
                % Redetermine the X and Y offsets when plotting the Ising macrospins
                app.vd.magnet(selectIdx).spinPlotXOffset = app.vd.magnet(selectIdx).colXPos -...
                    7*cosd(app.vd.magnet(selectIdx).spinAngle);
                app.vd.magnet(selectIdx).spinPlotYOffset = app.vd.magnet(selectIdx).rowYPos -...
                    7*sind(app.vd.magnet(selectIdx).spinAngle);
        end
    end
    
    close(selectionFigure);
    % Update the analysis window with the new magnetization based on whatever the chosen inspection image was
    app.TabGroupAnalysis.SelectedTab = app.AnalysisTab;
    general_imageDisplay(app,app.AxesAnalysis,backgroundImage);
    overlayMagnetization(app,app.AxesAnalysis);
    overlayVertexType(app,app.AxesAnalysis);
    close(alterDialog);
end