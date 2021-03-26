function correlationCalc(app)
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
    
    function nbrCoeff = correlationLoop(app,pairNbrList)
        nbrCoeff = 0;
        % Calculate nbr coefficient
        for i = 1:length(pairNbrList)
            mag1Idx = pairNbrList(i,1);
            mag2Idx = pairNbrList(i,2);
            spin1 = [app.vd.magnet(mag1Idx).xSpin, app.vd.magnet(mag1Idx).ySpin];
            spin2 = [app.vd.magnet(mag2Idx).xSpin, app.vd.magnet(mag2Idx).ySpin];
            nbrCoeff = dot(spin1,spin2)/length(pairNbrList) + nbrCoeff;
        end
    end
    
    % Second approach: parallel/antiparallel method (i.e., dot product truncation)



end