function correlationCalc(app,savePath)
    % Determines the alpha, beta, gamma, delta, spin-spin correlations
    
    % First approach: direct dot-product method
    % Private function correlationLoop
    % Performs the actual correlation function calculation
    nbrCoeff1 = correlationLoop(app,app.vd.pairNbr1);   % alpha-beta
    nbrCoeff2 = correlationLoop(app,app.vd.pairNbr2);   % alpha-gamma
    nbrCoeff3 = correlationLoop(app,app.vd.pairNbr3);   % alpha-nu
    nbrCoeff4 = correlationLoop(app,app.vd.pairNbr4);   % alpha-delta
    nbrCoeff5 = correlationLoop(app,app.vd.pairNbr5);   % alpha-eta
    nbrCoeff6 = correlationLoop(app,app.vd.pairNbr6);   % alpha-phi
    nbrCoeff7 = correlationLoop(app,app.vd.pairNbr7);   % alpha-tau
    
    % Write coefficients to text file
    formatSpec = 'Alpha - neighbor %d coefficient: %f\n';
    A1 = 1:7;
    A2 = [nbrCoeff1,nbrCoeff2,nbrCoeff3,nbrCoeff4,nbrCoeff5,nbrCoeff6,nbrCoeff7];
    A = [A1;A2];
    fileID = fopen(sprintf('%sCorrelation.txt',savePath),'w');
    fprintf(fileID,formatSpec,A);
    fclose(fileID);
    
    function nbrCoeff = correlationLoop(app,pairNbrList)
        nbrCoeff = 0;
        % Calculate nbr coefficient
        % When we're taking the average spin-spin correlation, we need to make sure that 
        % we omit magnets that are flagged to be ignored. This is relevant for the case where
        % the program reports a non-magnet region as a magnet.
        for i = 1:length(pairNbrList)
            mag1Idx = pairNbrList(i,1);
            mag2Idx = pairNbrList(i,2);
            spin1 = [app.vd.magnet(mag1Idx).xSpin, app.vd.magnet(mag1Idx).ySpin];
            spin2 = [app.vd.magnet(mag2Idx).xSpin, app.vd.magnet(mag2Idx).ySpin];
            nbrCoeff = dot(spin1,spin2)/length(pairNbrList) + nbrCoeff;
        end
    end
end