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
                E_init = dot(spin1,spin2) - 3*dot(spin1,r_ij)*dot(spin2,r_ij);
                E_flip = dot(-spin1,spin2) - 3*dot(-spin1,r_ij)*dot(spin2,r_ij);
                if E_init < E_flip
                    nbrCoeff = 1/length(pairNbrList) + nbrCoeff;
                elseif E_init > E_flip
                    nbrCoeff = -1/length(pairNbrList) + nbrCoeff;
                end
            end
    end
end
