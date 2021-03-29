function neighborIdxLocator(app)
    % Determines the alpha, beta, gamma, delta, ... neighbors for correlation function calculation
    switch app.vd.typeASI
        case 'Kagome'
            dist1 = 1;              % Beta /
            dist2 = sqrt(3);        % Gamma /
            dist3 = 2;              % Delta 
            dist4 = dist3;          % Nu
            dist5 = 3;              % Eta /
            dist6 = 3.4641;         % Phi /
            dist7 = 2.6458;         % Tau /
            hexToRectCoords(app);
            idx = [vertcat(app.vd.magnet.aInd_Hex2Rec),vertcat(app.vd.magnet.bInd_Hex2Rec)];
        case {'Square','Brickwork','Tetris'}
            dist1 = sqrt(2);
            dist2 = 2;
            dist3 = dist2;
            dist4 = 4;
            dist5 = 3.1623;
            dist6 = 2*sqrt(2);
            dist7 = dist4;
            idx = [vertcat(app.vd.magnet.aInd),vertcat(app.vd.magnet.bInd)];
    end
    currentStatus = uiprogressdlg(app.IceScannerUI,'Title','Spin-spin correlation',...
        'Message',sprintf('%s\n\n%s','Identifying n-th nearest neighbors for each nanomagnet.',...
        'This may take a while.'));
    switch app.vd.typeASI
        case 'Kagome'
            for alpha = 1:length(idx)
                % Tabulate the distance to all neighboring magnets
                vectorToIdx = idx - idx(alpha,:);
                distToIdx = sqrt(vectorToIdx(:,1).^2 + vectorToIdx(:,2).^2);
                % All beta neighbors are dist1 away from the observed alpha mag
                app.vd.magnet(alpha).nbr1 = find(distToIdx >= 0.95*dist1 & distToIdx <= 1.05*dist1);
                % All eta neighbors are dist5 away from the observed alpha mag
                app.vd.magnet(alpha).nbr5 = find(distToIdx >= 0.95*dist5 & distToIdx <= 1.05*dist5);
                % All phi neighbors are dist6 away from the observed alpha mag
                % For the case of the Kagome ASI, make sure that the nbr6 magnets directly lie within the
                % alpha axis of elongation. This can be determined by taking the dot product of two vectors:
                % The alpha spin vector and a vector cast from the center of the alpha magnet to a candidate
                % nbr6 magnet. If the two vectors coincide with one another, then the nbr6 magnet has been detected.
                % Here a slightly different approach is used: Rotate the alpha spin vector by 90 degrees and take
                % the dot product: a zero value will indicate detection of a nbr6 magnet.
                nbr6 = find(distToIdx >= 0.999*dist6 & distToIdx <= 1.001*dist6);
                nbr6_a = vertcat(app.vd.magnet(nbr6).aInd_Hex2Rec);
                nbr6_b = vertcat(app.vd.magnet(nbr6).bInd_Hex2Rec);
                alpha2nbr6 = [nbr6_b - app.vd.magnet(alpha).bInd_Hex2Rec nbr6_a - app.vd.magnet(alpha).aInd_Hex2Rec ];
                [ht, wt] = size(alpha2nbr6);
                % Generate a matrix containing the vector information of the alpha magnet to perform element-wise dot products
                alpha_v_R90 = zeros(ht,wt);
                % The absence of a "-" is associated with an mapping correction since MATLAB does this dumb f-ck thing where the coordinate system
                % on regular plots and images are inverted
                alpha_v_R90(:,1) = app.vd.magnet(alpha).ySpin; 
                alpha_v_R90(:,2) = app.vd.magnet(alpha).xSpin; 
                isNbr6 = round(dot(alpha_v_R90,alpha2nbr6,2)) == 0;
                app.vd.magnet(alpha).nbr6 = nbr6(isNbr6);
                % For gamma, delta, nu, and tau neighbors need additional information regarding "topological" distance away from the
                % alpha magnet (i.e., how many magnets away is the neighbor magnet)

                % Search for all neighbors that have a unique distance away from the alpha magnet
                app.vd.magnet(alpha).nbr2 = find(distToIdx >= 0.95*dist2 & distToIdx <= 1.05*dist2);
                app.vd.magnet(alpha).nbr7 = find(distToIdx >= 0.95*dist7 & distToIdx <= 1.05*dist7);
                % For the nu and delta magnets, first identify all magnets that are dist3 = dist4 away from alpha
                deltaNu = find(distToIdx >= 0.99*dist3 & distToIdx <= 1.01*dist3);
                % Delta magnets are separated from the alpha magnet by 1 magnet (beta), 
                % whereas the nu magnet is separated by 2 (beta and gamma).
                % Using the information acquired about the beta magnet, we can simply look for which magnet indices in deltaNu
                % share at least 1 vertex with the same index
                mat_34 = vertcat(app.vd.magnet(deltaNu).nbrVertexInd);
                idx1 = app.vd.magnet(alpha).nbr1;
                mat_2 = vertcat(app.vd.magnet(idx1).nbrVertexInd);
                compare_34_2 = ismember(mat_34,mat_2);
                isNbr3 = compare_34_2(:,1) | compare_34_2(:,2);
                app.vd.magnet(alpha).nbr4 = deltaNu(~isNbr3);
                app.vd.magnet(alpha).nbr3 = deltaNu(isNbr3);
                currentStatus.Value = alpha/length(idx);
            end
    end
end