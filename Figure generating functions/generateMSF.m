% Generates and plots the magnetic structure factor
function generateMSF(app,savePath,saveOption,tableOption)
    try
        steps = app.MSFSteps.Value;
        qMax = app.MSFStart.Value;
        qMin = app.MSFEnd.Value;
        range_qx = linspace(qMin*pi,qMax*pi,steps+1);
        rangeQxSize = length(range_qx);
        range_qy = range_qx;
        intensityMatrix = zeros(length(range_qx));
        xSpin = vertcat(app.vd.magnet.xSpin);
        ySpin = vertcat(app.vd.magnet.ySpin);
        xR = vertcat(app.vd.magnet.xR);
        yR = vertcat(app.vd.magnet.yR);

        % Remove all NaN magnets
        xR = xR(~isnan(xSpin));
        yR = yR(~isnan(xSpin));
        ySpin = ySpin(~isnan(xSpin));
        xSpin = xSpin(~isnan(xSpin));
        % Start up the parallel pool
        parPoolStatus = uiprogressdlg(app.IceScannerUI,'Title','Starting parallel pool','Message',...
            'Hang on a bit. MATLAB is initializing multiple CPU cores to accelerate the magnetic structure factor calculation.',...
            'Indeterminate','on');
        parpool;
        close(parPoolStatus);
        parDataQ = parallel.pool.DataQueue;
        msfDialog = uiprogressdlg(app.IceScannerUI,'Title','Magnetic structure factor','Message',...
            'Generating the magnetic structure factor. This may take several minutes.');
        afterEach(parDataQ, @nUpdateWaitbarMSF);
        p = 1;

        parfor x = 1:rangeQxSize
            qx = range_qx(x);
            iSub = zeros(1,rangeQxSize);
            for y = 1:length(range_qy)
                % Determine the propagation vector (aka scattering vector)
                qy = range_qy(y);
                q = [qx,qy];
                qHat = q/norm(q);
                A = 0;
                B = 0;
                % Determine A and B (see Ostman's paper: https://doi.org/10.1038/s41567-017-0027-2)
                for i = 1:length(xSpin)
                    % Calculate perpendicular spin component
                    spin = [xSpin(i),ySpin(i)];
                    spinPerp = spin - (qHat*spin.')*qHat;
                    % Here, I'm dividing by 2 since the island-to-island spacing based on my coordinate system is
                    % 2 times the unit vector. This odd coordinate system was used to also include vertices in
                    % the matrix space I defined. This way the calculated q is representative of the true calculated range
                    ri = [xR(i),yR(i)]/2;
                    A = A + spinPerp*cos(q*ri.');
                    B = B + spinPerp*sin(q*ri.');
                end
                iSub(1,y) = 1/length(xSpin) * ((A*A.') + (B*B.'));
            end
            intensityMatrix(x,:) = iSub(1,:);
            send(parDataQ,x);
        end
        app.vd.postProcess.MSF.map = intensityMatrix;
        delete(gcp('nocreate'));
        close(msfDialog);

        % Generate MSF figure
        imageStatus = uiprogressdlg(app.IceScannerUI,'Title','Generating image','Message',...
            'Generating MSF image for previewing.','Indeterminate','on');
        msfFigure = figure('visible','off','Name','Magnetic Structure Factor', 'Position', [100,100,2000,1600]);
        ax1 = axes(msfFigure,'Visible','off');
        imagesc(ax1,intensityMatrix);
        pbaspect(ax1,[1,1,1]);
        xticks([1:steps/6:steps+1])
        yticks([1:steps/6:steps+1])
        colormap(parula);
        colorbar;
        app.vd.postProcess.MSF.image = frame2im(getframe(msfFigure));
        set(ax1,'FontSize',20)
        set(ax1,'colorscale','linear')
        caxis('auto')
        switch saveOption
            case 'on'
                print(msfFigure,sprintf('%sMSF.tif',savePath),'-dtiffn');
        end
        close(msfFigure);
        close(imageStatus);

        switch tableOption
            case 'on'
                % Converts 2D MSF matrix into n*3 matrix, where each column represents qx, qy, and I, respectively
                exportMatrix = zeros(length(intensityMatrix)^2,3);
                convertStatus = uiprogressdlg(app.IceScannerUI,'Title','Generating text file','Message',...
                    'Exporting MSF text file.','Indeterminate','on');
                for i = 1:length(intensityMatrix)
                    convertStatus.Value = i/length(intensityMatrix);
                    for j = 1:length(intensityMatrix)
                        % Store qx
                        exportMatrix(j + length(intensityMatrix)*(i-1),1) = range_qx(i)/(pi);
                        exportMatrix(j + length(intensityMatrix)*(i-1),2) = range_qy(j)/(pi);
                        exportMatrix(j + length(intensityMatrix)*(i-1),3) = intensityMatrix(i,j);
                    end
                end
                app.vd.postProcess.MSF.mapExport = exportMatrix;
                switch saveOption
                    case 'on'
                        dlmwrite(sprintf('%sMSF.txt',savePath),exportMatrix);
                end
                close(convertStatus);
        end

    catch ME
        delete(gcp('nocreate'));
        if exist('msfDialog','var')
            close(msfDialog);
        end
        errorNotice(app,ME);
        return;
    end

    % Function for the waitbar
    function nUpdateWaitbarMSF(~)
        msfDialog.Value = p/rangeQxSize;
            p = p+1;
    end
end