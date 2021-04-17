function correlationCalcGlobal(app,savePath)
    % Determines the system-averaged spin-spin correlations
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
        switch app.vd.typeASI
            case 'Brickwork'
                nbrCoeff4b = spinCorrelation(app,app.vd.pairNbr4b,'dot');   % alpha-delta
                nbrCoeff5b = spinCorrelation(app,app.vd.pairNbr5b,'dot');   % alpha-eta
                nbrCoeff6b = spinCorrelation(app,app.vd.pairNbr6b,'dot');   % alpha-phi
                nbrCoeff7b = spinCorrelation(app,app.vd.pairNbr7b,'dot');   % alpha-tau
                A2 = [nbrCoeff1,nbrCoeff2,nbrCoeff3,nbrCoeff4,nbrCoeff5,nbrCoeff6,nbrCoeff7,...
                    nbrCoeff4b,nbrCoeff5b,nbrCoeff6b,nbrCoeff7b];
            otherwise
                A2 = [nbrCoeff1,nbrCoeff2,nbrCoeff3,nbrCoeff4,nbrCoeff5,nbrCoeff6,nbrCoeff7];
        end
        % Write coefficients to text file
        formatSpec = 'Alpha - neighbor %d coefficient: %f\n';    
        A1 = 1:length(A2);
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
        switch app.vd.typeASI
            case 'Brickwork'
                nbrCoeff4b = spinCorrelation(app,app.vd.pairNbr4b,'dot binary');   % alpha-delta
                nbrCoeff5b = spinCorrelation(app,app.vd.pairNbr5b,'dot binary');   % alpha-eta
                nbrCoeff6b = spinCorrelation(app,app.vd.pairNbr6b,'dot binary');   % alpha-phi
                nbrCoeff7b = spinCorrelation(app,app.vd.pairNbr7b,'dot binary');   % alpha-tau
                A2 = [nbrCoeff1,nbrCoeff2,nbrCoeff3,nbrCoeff4,nbrCoeff5,nbrCoeff6,nbrCoeff7,...
                    nbrCoeff4b,nbrCoeff5b,nbrCoeff6b,nbrCoeff7b];
            otherwise
                A2 = [nbrCoeff1,nbrCoeff2,nbrCoeff3,nbrCoeff4,nbrCoeff5,nbrCoeff6,nbrCoeff7];
        end
        % Write coefficients to text file
        formatSpec = 'Alpha - neighbor %d coefficient: %f\n';    
        A1 = 1:length(A2);
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
        switch app.vd.typeASI
            case 'Brickwork'
                nbrCoeff4b = spinCorrelation(app,app.vd.pairNbr4b,'magnetostatic');   % alpha-delta
                nbrCoeff5b = spinCorrelation(app,app.vd.pairNbr5b,'magnetostatic');   % alpha-eta
                nbrCoeff6b = spinCorrelation(app,app.vd.pairNbr6b,'magnetostatic');   % alpha-phi
                nbrCoeff7b = spinCorrelation(app,app.vd.pairNbr7b,'magnetostatic');   % alpha-tau
                A2 = [nbrCoeff1,nbrCoeff2,nbrCoeff3,nbrCoeff4,nbrCoeff5,nbrCoeff6,nbrCoeff7,...
                    nbrCoeff4b,nbrCoeff5b,nbrCoeff6b,nbrCoeff7b];
            otherwise
                A2 = [nbrCoeff1,nbrCoeff2,nbrCoeff3,nbrCoeff4,nbrCoeff5,nbrCoeff6,nbrCoeff7];
        end
        % Write coefficients to text file
        formatSpec = 'Alpha - neighbor %d coefficient: %f\n';    
        A1 = 1:length(A2);
        A = [A1;A2];
        fileID = fopen(sprintf('%sCorrelation_magnetostatic.txt',savePath),'w');
        fprintf(fileID,formatSpec,A);
        fclose(fileID);
    end
end