% This searches for magnets and stores information regarding their approximate locations in terms of a rectangular ROI
function magnetLocator(app,currIndVtx,nbrIndVtx)
    % In order to run this thing, we need to look at variables associated with the currently observed vertex index "currIndVtx"
    % and the neighboring vertex index "nbrIndVtx" within the structure app.vd.vertex.

    % X and Y position of vertex nbrIndVtx
    nbrXPos = app.vd.vertex(nbrIndVtx).colXPos;    % Formerly neighborInfo(j,1)
    nbrYPos = app.vd.vertex(nbrIndVtx).rowYPos;    % Formerly neighborInfo(j,2)

    % X and Y position of current vertex currIndVtx
    currXPos = app.vd.vertex(currIndVtx).colXPos;  % Formerly trueMinLoc(i,1);
    currYPos = app.vd.vertex(currIndVtx).rowYPos;  % Formerly trueMinLoc(i,2);

    % Calculate the midpoints between these two positions to determine the approximate magnet location
    xMidpoint = floor((nbrXPos+currXPos)/2);
    yMidpoint = floor((nbrYPos+currYPos)/2);

    % First thing: Figure out if a magnet with this position has already been discovered
    [~,fieldSize] = size(app.vd.magnet);


    if isempty(app.vd.magnet(1).rowYPos) == 1       % For the first magnet entry, record the information at index 1 
        magInd = 1;
    else
        % Create vectors to store variables associated with the x and y positions of all saved magnet indices
        storedXMidpoint = vertcat(app.vd.magnet.colXPos);
        storedYMidpoint = vertcat(app.vd.magnet.rowYPos);

        % Search all elements within app.vd.magnet to see if there are already exists a magnet with the calculated positions
        existingMagInd = find(storedXMidpoint == xMidpoint & storedYMidpoint == yMidpoint); 

        % Apply switch statement for cases where an existing magnet has been found or not
        magnetExists = ~isempty(existingMagInd);

        switch magnetExists
            case 1 % Magnet already exists. Archive position
                app.vd.vertex(currIndVtx).nbrMagnetInd(end+1) = existingMagInd;
                return;
            case 0 % Magnet does not exist. Create new entry at fieldSize+1 (new entry at end)
                magInd = fieldSize + 1;
        end
    end

    app.vd.magnet(magInd).rowYPos = yMidpoint;
    app.vd.magnet(magInd).colXPos = xMidpoint;
    app.vd.magnet(magInd).nbrVertexInd(1) = currIndVtx;
    app.vd.magnet(magInd).nbrVertexInd(2) = nbrIndVtx;

    %% Extract magnetization from magnetic contrast image (XMCD for this case)

    % Create a rectangular bounding box on which to perform the grayscale scan
    magnetLength = 22;
    magnetWidth = 8;

    % Create perimeter for performing ROI scan of the magnetic contrast
    magnetPerX = magnetLength/2 * [-1:0.02:1,ones(1,length(-1:0.02:1)),1:-0.02:-1,-ones(1,length(-1:0.02:1))];
    magnetPerY = magnetWidth/2 * [ones(1,length(-1:0.02:1)),1:-0.02:-1,-ones(1,length(-1:0.02:1)),-1:0.02:1];

    % Determine what quadrant the ray casted from currIndVtx-TO-nbrIndVtx vector lies in
    dx = nbrXPos - currXPos;
    dy = nbrYPos - currYPos;

    angle = atan2d(dy,dx);

    % Initialize scan area for reading magnetization
    magnetAreaScanX = cosd(angle)*magnetPerX - sind(angle)*magnetPerY + xMidpoint;
    magnetAreaScanY = sind(angle)*magnetPerX + cosd(angle)*magnetPerY + yMidpoint;
    magnetLocalArea = [magnetAreaScanX',magnetAreaScanY'];

    % Remove any portions of the ROI scan that would exceed the edge
    magnetLocalArea(magnetLocalArea(:,1) < 1 | magnetLocalArea(:,1) > app.vd.gridWidth) = NaN;
    magnetLocalArea(magnetLocalArea(:,2) < 1 | magnetLocalArea(:,2) > app.vd.gridHeight) = NaN;
    magnetLocalArea(any(isnan(magnetLocalArea),2) == 1,:) = []; 
    roiScan = poly2mask(magnetLocalArea(:,1),magnetLocalArea(:,2),app.vd.gridHeight,app.vd.gridWidth);

    % Find out the matrix indices corresponding with the nearest neighboring vertices, but exclude background
    scanRegion = app.vd.xmcd(roiScan == 1);
    nanImage = NaN(app.vd.gridHeight,app.vd.gridWidth);
    nanImage(roiScan == 1) = app.vd.xmcdBinary(roiScan == 1);

    % Determine the average XMCD contrast balue of all the pixels in the ROI
    app.vd.magnet(magInd).xmcdAvg = sum(scanRegion,'all')/numel(scanRegion);
    % Determine the associated standard deviation of iceMagnets(k,7) (Average XMCD over the ROI)
    app.vd.magnet(magInd).xmcdSTD = std(scanRegion,0,'all','omitnan');

    %  Determine and save XMCD contrast values

    % First, determine the weights associated with black/white pixel population
    whiteMean = sum(scanRegion(scanRegion > 0))/numel(scanRegion);
    blackMean = sum(scanRegion(scanRegion < 0))/numel(scanRegion);
    grayMean = sum(scanRegion(scanRegion == 0))/numel(scanRegion);
    whitePop = sum(scanRegion > 0);
    blackPop = sum(scanRegion < 0);
    grayPop = sum(scanRegion == 0);

    % Combined average
    app.vd.magnet(magInd).xmcdWeighted = (whiteMean*whitePop + blackMean*blackPop + grayMean*grayPop)/(whitePop + blackPop + grayPop);

    % Binary average
    app.vd.magnet(magInd).xmcdBinary = sum(app.vd.xmcdBinary(roiScan == 1))/numel(app.vd.xmcdBinary(roiScan == 1)) - 0.5;

    % XMCD entropy
    app.vd.magnet(magInd).xmcdEntropy = entropy(nanImage(~isnan(nanImage)));

    %  Assign magnetization Ising-states

    % Assign the lateral orientation (black is -1/left, white is +1/right)
    if app.vd.magnet(magInd).xmcdWeighted > 0      % Right (White)
        app.vd.magnet(magInd).projection = 1;

        % Define how the magnetization is oriented on the unit circle
        % If the vector associated with the variable angle is oriented towards the second or third quadrant
        % (angle = [90 270]), then flip it.
        if angle >= 90 && angle <= 270
            if angle >= 180
                app.vd.magnet(magInd).spinAngle = angle-180;
            elseif angle < 180
                app.vd.magnet(magInd).spinAngle = angle+180;
            end
        else
            app.vd.magnet(magInd).spinAngle = angle;
        end

        % Determine the X and Y offsets when plotting the Ising macrospins
        app.vd.magnet(magInd).spinPlotXOffset = app.vd.magnet(magInd).colXPos - 7*cosd(angle);
        app.vd.magnet(magInd).spinPlotYOffset = app.vd.magnet(magInd).rowYPos - 7*sind(angle);

    elseif app.vd.magnet(magInd).xmcdWeighted < -0     % Left (Black)
        app.vd.magnet(magInd).projection = -1;

        % Define how the magnetization is oriented on the unit circle
        % If the vector associated with the variable angle is oriented towards the second or third quadrant
        % (angle = [90 270]), then keep it. Otherwise flip it.
        if angle >= 90 && angle <= 270
            app.vd.magnet(magInd).spinAngle = angle;
        else
            if angle >= 180
                app.vd.magnet(magInd).spinAngle = angle-180;
            elseif angle < 180
                app.vd.magnet(magInd).spinAngle = angle+180;
            end
        end

        % Determine the X and Y offsets when plotting the Ising macrospins
        app.vd.magnet(magInd).spinPlotXOffset = app.vd.magnet(magInd).colXPos + 7*cosd(angle);
        app.vd.magnet(magInd).spinPlotYOffset = app.vd.magnet(magInd).rowYPos + 7*sind(angle);
    end

    % Adjust magnetMask, magnetInterpretReg, and magnetInterpretCombined
    app.vd.magnetMask(roiScan == 1) = 1;
    app.vd.magnetInterpretReg(roiScan == 1) = app.vd.magnet(magInd).xmcdAvg;
    app.vd.magnetInterpretCombined(roiScan == 1) = app.vd.magnet(magInd).xmcdWeighted;
    app.vd.magnetEntropy(roiScan == 1) = app.vd.magnet(magInd).xmcdEntropy;

    % Store the magnet index
    app.vd.vertex(currIndVtx).nbrMagnetInd(end+1) = magInd;
end