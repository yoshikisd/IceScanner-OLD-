function correlationCalc(app,savePath)
    % Determines the alpha, beta, gamma, delta, spin-spin correlations
    
    % First approach: direct dot-product method
    % Private function correlationLoop
    % Performs the actual correlation function calculation
    if app.correlation_SpinDot.Value == 1
        nbrCoeff1 = spinCorrelation(app,app.vd.pairNbr1,'dot');   % alpha-beta
        nbrCoeff2 = spinCorrelation(app,app.vd.pairNbr2,'dot');   % alpha-gamma
        nbrCoeff3 = spinCorrelation(app,app.vd.pairNbr3,'dot');   % alpha-nu
        nbrCoeff4 = spinCorrelation(app,app.vd.pairNbr4,'dot');   % alpha-delta
        nbrCoeff5 = spinCorrelation(app,app.vd.pairNbr5,'dot');   % alpha-eta
        nbrCoeff6 = spinCorrelation(app,app.vd.pairNbr6,'dot');   % alpha-phi
        nbrCoeff7 = spinCorrelation(app,app.vd.pairNbr7,'dot');   % alpha-tau
        % Write coefficients to text file
        formatSpec = 'Alpha - neighbor %d coefficient: %f\n';    A1 = 1:7;
        A2 = [nbrCoeff1,nbrCoeff2,nbrCoeff3,nbrCoeff4,nbrCoeff5,nbrCoeff6,nbrCoeff7];
        A = [A1;A2];
        fileID = fopen(sprintf('%sCorrelation_dot.txt',savePath),'w');
        fprintf(fileID,formatSpec,A);
        fclose(fileID);
    end
    
    if app.correlation_DotBinary.Value == 1
        nbrCoeff1 = spinCorrelation(app,app.vd.pairNbr1,'dot binary');   % alpha-beta
        nbrCoeff2 = spinCorrelation(app,app.vd.pairNbr2,'dot binary');   % alpha-gamma
        nbrCoeff3 = spinCorrelation(app,app.vd.pairNbr3,'dot binary');   % alpha-nu
        nbrCoeff4 = spinCorrelation(app,app.vd.pairNbr4,'dot binary');   % alpha-delta
        nbrCoeff5 = spinCorrelation(app,app.vd.pairNbr5,'dot binary');   % alpha-eta
        nbrCoeff6 = spinCorrelation(app,app.vd.pairNbr6,'dot binary');   % alpha-phi
        nbrCoeff7 = spinCorrelation(app,app.vd.pairNbr7,'dot binary');   % alpha-tau
        % Write coefficients to text file
        formatSpec = 'Alpha - neighbor %d coefficient: %f\n';    A1 = 1:7;
        A2 = [nbrCoeff1,nbrCoeff2,nbrCoeff3,nbrCoeff4,nbrCoeff5,nbrCoeff6,nbrCoeff7];
        A = [A1;A2];
        fileID = fopen(sprintf('%sCorrelation_dotBinary.txt',savePath),'w');
        fprintf(fileID,formatSpec,A);
        fclose(fileID);
    end
    
    if app.correlation_Magnetostatic.Value == 1
        nbrCoeff1 = spinCorrelation(app,app.vd.pairNbr1,'magnetostatic');   % alpha-beta
        nbrCoeff2 = spinCorrelation(app,app.vd.pairNbr2,'magnetostatic');   % alpha-gamma
        nbrCoeff3 = spinCorrelation(app,app.vd.pairNbr3,'magnetostatic');   % alpha-nu
        nbrCoeff4 = spinCorrelation(app,app.vd.pairNbr4,'magnetostatic');   % alpha-delta
        nbrCoeff5 = spinCorrelation(app,app.vd.pairNbr5,'magnetostatic');   % alpha-eta
        nbrCoeff6 = spinCorrelation(app,app.vd.pairNbr6,'magnetostatic');   % alpha-phi
        nbrCoeff7 = spinCorrelation(app,app.vd.pairNbr7,'magnetostatic');   % alpha-tau
        % Write coefficients to text file
        formatSpec = 'Alpha - neighbor %d coefficient: %f\n';    A1 = 1:7;
        A2 = [nbrCoeff1,nbrCoeff2,nbrCoeff3,nbrCoeff4,nbrCoeff5,nbrCoeff6,nbrCoeff7];
        A = [A1;A2];
        fileID = fopen(sprintf('%sCorrelation_magnetostatic.txt',savePath),'w');
        fprintf(fileID,formatSpec,A);
        fclose(fileID);
    end
    
    function nbrCoeff = spinCorrelation(app,pairNbrList,definition)
        nbrCoeff = 0;
        % Calculate nbr coefficient
        % When we're taking the average spin-spin correlation, we need to make sure that 
        % we omit magnets that are flagged to be ignored. This is relevant for the case where
        % the program reports a non-magnet region as a magnet.
        switch definition
            case 'dot'
                for i = 1:length(pairNbrList)
                    mag1Idx = pairNbrList(i,1);
                    mag2Idx = pairNbrList(i,2);
                    spin1 = [app.vd.magnet(mag1Idx).xSpin, app.vd.magnet(mag1Idx).ySpin];
                    spin2 = [app.vd.magnet(mag2Idx).xSpin, app.vd.magnet(mag2Idx).ySpin];
                    nbrCoeff = dot(spin1,spin2)/length(pairNbrList) + nbrCoeff;
                end
            case 'dot binary'
                for i = 1:length(pairNbrList)
                    mag1Idx = pairNbrList(i,1);
                    mag2Idx = pairNbrList(i,2);
                    spin1 = [app.vd.magnet(mag1Idx).xSpin, app.vd.magnet(mag1Idx).ySpin];
                    spin2 = [app.vd.magnet(mag2Idx).xSpin, app.vd.magnet(mag2Idx).ySpin];
                    if dot(spin1,spin2) > 0
                        nbrCoeff = 1/length(pairNbrList) + nbrCoeff;
                    elseif dot(spin1,spin2) < 0
                        nbrCoeff = -1/length(pairNbrList) + nbrCoeff;
                    end
                end
            case 'magnetostatic'
                for i = 1:length(pairNbrList)
                    mag1Idx = pairNbrList(i,1);
                    mag2Idx = pairNbrList(i,2);
                    spin1 = [app.vd.magnet(mag1Idx).xSpin, app.vd.magnet(mag1Idx).ySpin];
                    spin2 = [app.vd.magnet(mag2Idx).xSpin, app.vd.magnet(mag2Idx).ySpin];
                    r_ij = [app.vd.magnet(mag1Idx).xR - app.vd.magnet(mag2Idx).xR,...
                        app.vd.magnet(mag1Idx).yR - app.vd.magnet(mag2Idx).yR];
                    E_init = 3*dot(spin1,r_ij)*dot(spin2,r_ij) - dot(spin1,spin2);
                    E_flip = 3*dot(-spin1,r_ij)*dot(spin2,r_ij) - dot(-spin1,spin2);
                    if E_init < E_flip
                        nbrCoeff = 1/length(pairNbrList) + nbrCoeff;
                    elseif E_init > E_flip
                        nbrCoeff = -1/length(pairNbrList) + nbrCoeff;
                    end
                end
        end
    end
end