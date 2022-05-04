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
    % We make an assumption that the domain state is Ising-like. This can be corrected manually in later steps
    app.vd.magnet(magInd).domainState = "Ising";
    %% Extract magnetization from magnetic contrast image (XMCD for this case)
    % Create a rectangular bounding box on which to perform the grayscale scan
    magnetLength = app.magnetHeight.Value;
    magnetWidth = app.magnetWidth.Value;
    % Determine what quadrant the ray casted from currIndVtx-TO-nbrIndVtx vector lies in
    dx = nbrXPos - currXPos;
    dy = nbrYPos - currYPos;
    angle = atan2d(dy,dx);
    % This comes into play when we're extracting the ROIs which read the magnetizations
    nanImage = NaN(app.vd.gridHeight,app.vd.gridWidth);
    
    % Magnetization interpretation will depend on the contrast mechanism (XMCD or MFM)
    switch app.contrastMode.Value
        case 'XMCD-PEEM'
            % Create perimeter for performing ROI scan of the magnetic contrast
            magnetPerX = magnetLength/2 * [-1:0.02:1,ones(1,length(-1:0.02:1)),1:-0.02:-1,-ones(1,length(-1:0.02:1))];
            magnetPerY = magnetWidth/2 * [ones(1,length(-1:0.02:1)),1:-0.02:-1,-ones(1,length(-1:0.02:1)),-1:0.02:1];
            
            % Initialize scan area for reading magnetization
            magnetAreaScanX = cosd(angle)*magnetPerX - sind(angle)*magnetPerY + xMidpoint;
            magnetAreaScanY = sind(angle)*magnetPerX + cosd(angle)*magnetPerY + yMidpoint;
            magnetLocalArea = [magnetAreaScanX',magnetAreaScanY'];

            % Remove any portions of the ROI scan that would exceed the edge
            magnetLocalArea(magnetLocalArea(:,1) < 1 | magnetLocalArea(:,1) > app.vd.gridWidth) = NaN;
            magnetLocalArea(magnetLocalArea(:,2) < 1 | magnetLocalArea(:,2) > app.vd.gridHeight) = NaN;
            magnetLocalArea(any(isnan(magnetLocalArea),2) == 1,:) = []; 
            roiScan = poly2mask(magnetLocalArea(:,1),magnetLocalArea(:,2),app.vd.gridHeight,app.vd.gridWidth);%

            % Find out the matrix indices corresponding with the nearest neighboring vertices, but exclude background
            scanRegion = app.vd.xmcd(roiScan == 1);
            nanImage(roiScan == 1) = app.vd.xmcdBinary(roiScan == 1);

            % Determine the average XMCD contrast balue of all the pixels in the ROI
            app.vd.magnet(magInd).xmcdAvg = mean(scanRegion,'all');
            
            
            % Determine and save XMCD contrast values
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
            app.vd.magnet(magInd).xmcdBinary = mean(app.vd.xmcdBinary(roiScan == 1),'all');

            % XMCD entropy 
            app.vd.magnet(magInd).xmcdEntropy = entropy(nanImage(~isnan(nanImage)));
            
            % Determine the standard deviation of the trinary XMCD image, to be used in providing Ising detection
            % confidence level
            app.vd.magnet(magInd).xmcdSTD = std(app.vd.xmcdBinary(roiScan == 1),0,'all','omitnan');
            
            % List all unique trinary intensities identified in ROI scan
            app.vd.magnet(magInd).uniqueTrinaryInt = unique(app.vd.xmcdBinary(roiScan == 1));
            app.vd.magnet(magInd).uniqueTrinaryInt_num = length(app.vd.magnet(magInd).uniqueTrinaryInt);
            app.vd.magnet(magInd).uniqueTrinaryInt_absSum = sum(abs(app.vd.magnet(magInd).uniqueTrinaryInt));
            
            % Adjust magnetMask, magnetInterpretReg, and magnetInterpretCombined
            app.vd.magnetMask(roiScan == 1) = 1;
            app.vd.magnetInterpretReg(roiScan == 1) = app.vd.magnet(magInd).xmcdAvg;
            app.vd.magnetInterpretCombined(roiScan == 1) = app.vd.magnet(magInd).xmcdWeighted;
            app.vd.magnetEntropy(roiScan == 1) = app.vd.magnet(magInd).xmcdEntropy;
            
        case 'MFM' 
            % MFM interpretation mode is based on XMCD-reading mode. The way this will work is that the value of the left-end of
            % the nanoisland (either positive or negative) will cause the nanoisland magnetization to be read as if it was
            % a "white" or "black" island in an XMCD-PEEM image.
            
            % The primary caveat to this is that if the program detects that the nanoisland ends are both positive/negative, then it will
            % ignore the nanoisland from further analysis (assuming the island moment flipped)
            
            % We're assuming here that the nanoislands are tilted. This will not work for perfectly vertical nanoislands
            % Create two circles that sit at the ends of the nanoislands
            % First, identify where the centers of these circles reside at. For now we will set the positions to reside a distance of half 
            % the nanoisland width away from the ends 
            xOffset = cosd(angle)*(magnetLength-magnetWidth)/2;
            yOffset = sind(angle)*(magnetLength-magnetWidth)/2;
            
            % Define the left and right magnet end locations
            if xOffset < 0
                leftEnd_XPos = xMidpoint + xOffset;
                leftEnd_YPos = yMidpoint + yOffset;
                rightEnd_XPos = xMidpoint - xOffset;
                rightEnd_YPos = yMidpoint - yOffset;
            elseif xOffset > 0
                leftEnd_XPos = xMidpoint - xOffset;
                leftEnd_YPos = yMidpoint - yOffset;
                rightEnd_XPos = xMidpoint + xOffset;
                rightEnd_YPos = yMidpoint + yOffset;
            end
            
            % Create circle ROIs that will be used to read the MFM magnetizations
            MFMPerX = magnetWidth/2 * cosd(0:15:360);
            MFMPerY = magnetWidth/2 * sind(0:15:360);
            
            leftMFM = [MFMPerX' + leftEnd_XPos,MFMPerY' + leftEnd_YPos];
            rightMFM = [MFMPerX' + rightEnd_XPos,MFMPerY' + rightEnd_YPos];
            
            % Remove any portions of the left MFM ROI scan that would exceed the edge
            leftMFM(leftMFM(:,1) < 1 | leftMFM(:,1) > app.vd.gridWidth) = NaN;
            leftMFM(leftMFM(:,2) < 1 | leftMFM(:,2) > app.vd.gridHeight) = NaN;
            leftMFM(any(isnan(leftMFM),2) == 1,:) = [];
            leftMFMScan = poly2mask(leftMFM(:,1),leftMFM(:,2),app.vd.gridHeight,app.vd.gridWidth);
            
            rightMFM(rightMFM(:,1) < 1 | rightMFM(:,1) > app.vd.gridWidth) = NaN;
            rightMFM(rightMFM(:,2) < 1 | rightMFM(:,2) > app.vd.gridHeight) = NaN;
            rightMFM(any(isnan(rightMFM),2) == 1,:) = [];
            rightMFMScan = poly2mask(rightMFM(:,1),rightMFM(:,2),app.vd.gridHeight,app.vd.gridWidth);
            
            % Read the magnetizations in the regions and save the ROIs in an image form
            leftScanRegion = app.vd.xmcd(leftMFMScan);
            rightScanRegion = app.vd.xmcd(rightMFMScan);
            nanImage(leftMFMScan) = app.vd.xmcdBinary(leftMFMScan);
            nanImage(rightMFMScan) = app.vd.xmcdBinary(rightMFMScan);
            
            % Average the intensity within the scanned ROIs
            leftMean = sum(leftScanRegion,'all')/numel(leftScanRegion);
            rightMean = sum(rightScanRegion,'all')/numel(rightScanRegion);
            
            % Read the left MFM poles as the black/white XMCD contrast, depending on the MFM tip magnetization
            % First, check if both ends are the same "color" or not. Easiest way to do this is to multiply the left
            % and right mean: if both ends are different "colors" (i.e. positive and negative), then their product
            % will always be negative
            if leftMean * rightMean < 0 % Both ends are different colors
                % If the tip is "North", then white contrast (repulsive) is "North" and black contrast (attractive) is "South"
                % If the tip is "South", then the above statement is reversed (North is black and South is white)
                % Following the existing XMCD convention for this program, "White is right, Black is left"
                
                % Create a variable tipFactor to flip the convention of leftMean, depending on the tip magnetization
                tipFactor = 1;
                switch app.tipPole.Value
                    case 'N'
                        tipFactor = 1;
                    case 'S'
                        tipFactor = -1;
                end
                
                if leftMean*tipFactor > 0 
                    % If the left end is white (+1) and the tip is North (+1), then the nanoisland will point to the left (north pole)
                    % Or, if the left is black (-1) and the tip is South (-1), then the nanoisland will point to the left (north pole)
                    app.vd.magnet(magInd).xmcdAvg = -1;
                    
                elseif leftMean*tipFactor < 0
                    % If the left end is white (+1) and the tip is South (-1), then the nanoisland will point to the right (south pole)
                    % Or, if the left is black (-1) and the tip is North (+1), then the nanoisland will point to the right (south pole)
                    app.vd.magnet(magInd).xmcdAvg = 1;
                end
                
            else % Both ends are same color; probably switched. Treat as a unidentifiable magnet (gray)
                app.vd.magnet(magInd).xmcdAvg = 0;
            end
            
            app.vd.magnet(magInd).xmcdWeighted = app.vd.magnet(magInd).xmcdAvg;
            app.vd.magnet(magInd).xmcdBinary = app.vd.magnet(magInd).xmcdAvg;
            
            % Due to the way the magnetization is being re-mapped here, xmcdSTD and xmcdEntropy are not really relevant
            app.vd.magnet(magInd).xmcdSTD = 0;
            app.vd.magnet(magInd).xmcdEntropy = 0;
            
            % Adjust magnetMask, magnetInterpretReg, and magnetInterpretCombined
            app.vd.magnetMask(leftMFMScan | rightMFMScan) = 1;
            app.vd.magnetInterpretReg(leftMFMScan) = app.vd.magnet(magInd).xmcdAvg;
            app.vd.magnetInterpretReg(rightMFMScan) = -app.vd.magnet(magInd).xmcdAvg;
            app.vd.magnetInterpretCombined(leftMFMScan) = leftMean;
            app.vd.magnetInterpretCombined(rightMFMScan) = rightMean;
            app.vd.magnetEntropy(leftMFMScan | rightMFMScan) = 0;
            
    end
    
    % Change ignore flag to zero
    app.vd.magnet(magInd).ignoreFlag = false;

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
    % Store the magnet index
    app.vd.vertex(currIndVtx).nbrMagnetInd(end+1) = magInd;
end