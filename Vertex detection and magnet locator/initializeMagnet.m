% Initialize the structure magnet
function initializeMagnet(app)
    % First figure out if magnet already exists. If it does, clear it.
    if isfield(app.vd, 'magnet') == 1
        app.vd = rmfield(app.vd,'magnet');
    end
    
    % Initialize iceMagnets as a structure
    % IceMagnets is now magnet
    app.vd.magnet(1).rowYPos = [];                          % (1) Magnet row/y location
    app.vd.magnet(1).colXPos = [];                          % (2) Magnet column/x location
    app.vd.magnet(1).nbrVertexInd = [];                     % (3-4) Index associated with one of two vertices flanking the magnet
    app.vd.magnet(1).rowYTilt = [];                         % (5) Row/y component of the magnet tilt
    app.vd.magnet(1).colXTilt = [];                         % (6) Col/x component of the magnet tilt
    app.vd.magnet(1).xmcdAvg = [];                          % (7) Average ROI XMCD intensity
    app.vd.magnet(1).projection = [];                       % (8) Lateral projection of the magnetization vector on x-axis (+-1)
    app.vd.magnet(1).xmcdWeighted = [];                     % (9) Weighted average of the ROI XMCD intensity
    app.vd.magnet(1).xmcdBinary = [];                       % (10) Binary XMCD intensity
    app.vd.magnet(1).xmcdEntropy = [];                      % (11) Entropy of XMCD in ROI
    app.vd.magnet(1).nbr1 = [];                             % (12-15) Indices of the beta neighbors (see correlation length)
    app.vd.magnet(1).nbr2 = [];                             % (16-19) Indices of the gamma neighbors
    app.vd.magnet(1).nbr3 = [];                             % (20-23) Indices of the nu neighbors
    app.vd.magnet(1).nbr4 = [];                             % (24-25) Indices of the delta neighbors
    app.vd.magnet(1).nbr5 = [];                             % (26-33) Indices of the tau neighbors
    app.vd.magnet(1).nbr6 = [];                             % (34-37) Indices of the eta neighbors
    app.vd.magnet(1).nbr7 = [];                             % (38-39) Indices of the phi neighbors
    app.vd.magnet(1).aInd = [];                             % (40) Lattice position along the a-direction (see notebook)
    app.vd.magnet(1).bInd = [];                             % (41) Lattice position along the b-direction
    app.vd.magnet(1).orient = [];                           % (42) Magnet orientation, (1 == -, 2 == /, 3 == \)
    app.vd.magnet(1).forkType = [];                         % (43) Fork-direction for the Kagome vertex (+1 == -<, -1 == >-)
    app.vd.magnet(1).indexFlag = 0;                         % (44) Indicate whether to observe for indexing 
                                                            %      (0 = not indexed yet, 1 = look into indexing this next, 2 = done)
    app.vd.magnet(1).startVertex = [];                      % (45) Index of the "start" vertex
    app.vd.magnet(1).xSpin = [];                            % (46) X-component of macrospin vector
    app.vd.magnet(1).ySpin = [];                            % (47) Y-component of macrospin vector
    app.vd.magnet(1).xR = [];                               % (48) X-component of the spin position vector r
    app.vd.magnet(1).yR = [];                               % (49) Y-component of the spin position vector r
    app.vd.magnet(1).spinAngle = [];                        % (50) Angle formed between magnetization and positive x-direction
    app.vd.magnet(1).xmcdSTD = [];                          % (51) Standard deviation of the XMCD intensity over the ROI scan
    app.vd.magnet(1).numROIElements = [];                   % (52) Number of elements in ROI scan
    app.vd.magnet(1).spinPlotXOffset = [];                  % X offset when plotting the Ising vector using a quiver plot
    app.vd.magnet(1).spinPlotYOffset = [];                  % Y offset when plotting the Ising vector using a quiver plot
    app.vd.magnet(1).ignoreFlag = false;                    % Indicate whether the analysis should ignore this magnet
end