function removeRedundantNbrIdx(app)
    % Generates a list of unique vertex pairs based on what n-th neighbors they are
    pairNbr1 = zeros(length(app.vd.magnet)*10,2);
    pairNbr2 = zeros(length(app.vd.magnet)*10,2);
    pairNbr3 = zeros(length(app.vd.magnet)*10,2);
    pairNbr4 = zeros(length(app.vd.magnet)*10,2);
    pairNbr5 = zeros(length(app.vd.magnet)*10,2);
    pairNbr6 = zeros(length(app.vd.magnet)*10,2);
    pairNbr7 = zeros(length(app.vd.magnet)*10,2);
    pairNbr4b = zeros(length(app.vd.magnet)*10,2);
    pairNbr5b = zeros(length(app.vd.magnet)*10,2);
    pairNbr6b = zeros(length(app.vd.magnet)*10,2);
    pairNbr7b = zeros(length(app.vd.magnet)*10,2);

    % Initialize a counter variable i
    idx1 = 1;
    idx2 = 1;
    idx3 = 1;
    idx4 = 1;
    idx5 = 1;
    idx6 = 1;
    idx7 = 1;
    idx4b = 1;
    idx5b = 1;
    idx6b = 1;
    idx7b = 1;
    currentStatus = uiprogressdlg(app.IceScannerUI,'Title','Spin-spin correlation',...
        'Message',sprintf('%s\n\n%s','Identifying all unique n-th nearest neighboring pairs.',...
        'This will take a while.'));
    for alpha = 1:length(app.vd.magnet)
        currentStatus.Value = alpha/length(app.vd.magnet);
        % Index all alpha-nbr1 pairs (make sure nbr1 is not blank)
        if ~isempty(app.vd.magnet(alpha).nbr1)
            for i = 1:length(vertcat(app.vd.magnet(alpha).nbr1))
                pairNbr1(idx1,1) = alpha;
                pairNbr1(idx1,2) = app.vd.magnet(alpha).nbr1(i);
                idx1 = idx1+1;
            end
        end
        % Index all alpha-nbr2 pairs (make sure nbr2 is not blank)
        if ~isempty(app.vd.magnet(alpha).nbr2)
            for i = 1:length(vertcat(app.vd.magnet(alpha).nbr2))
                pairNbr2(idx2,1) = alpha;
                pairNbr2(idx2,2) = app.vd.magnet(alpha).nbr2(i);
                idx2 = idx2+1;
            end
        end
        % Index all alpha-nbr3 pairs (make sure nbr3 is not blank)
        if ~isempty(app.vd.magnet(alpha).nbr3)
            for i = 1:length(vertcat(app.vd.magnet(alpha).nbr3))
                pairNbr3(idx3,1) = alpha;
                pairNbr3(idx3,2) = app.vd.magnet(alpha).nbr3(i);
                idx3 = idx3+1;
            end
        end
        % Index all alpha-nbr4 pairs (make sure nbr4 is not blank)
        if ~isempty(app.vd.magnet(alpha).nbr4)
            for i = 1:length(vertcat(app.vd.magnet(alpha).nbr4))
                pairNbr4(idx4,1) = alpha;
                pairNbr4(idx4,2) = app.vd.magnet(alpha).nbr4(i);
                idx4 = idx4+1;
            end
        end
        % Index all alpha-nbr5 pairs (make sure nbr5 is not blank)
        if ~isempty(app.vd.magnet(alpha).nbr5)
            for i = 1:length(vertcat(app.vd.magnet(alpha).nbr5))
                pairNbr5(idx5,1) = alpha;
                pairNbr5(idx5,2) = app.vd.magnet(alpha).nbr5(i);
                idx5 = idx5+1;
            end
        end
        % Index all alpha-nbr6 pairs (make sure nbr6 is not blank)
        if ~isempty(app.vd.magnet(alpha).nbr6)
            for i = 1:length(vertcat(app.vd.magnet(alpha).nbr6))
                pairNbr6(idx6,1) = alpha;
                pairNbr6(idx6,2) = app.vd.magnet(alpha).nbr6(i);
                idx6 = idx6+1;
            end
        end
        % Index all alpha-nbr7 pairs (make sure nbr5 is not blank)
        if ~isempty(app.vd.magnet(alpha).nbr7)
            for i = 1:length(vertcat(app.vd.magnet(alpha).nbr7))
                pairNbr7(idx7,1) = alpha;
                pairNbr7(idx7,2) = app.vd.magnet(alpha).nbr7(i);
                idx7 = idx7+1;
            end
        end
        switch app.vd.typeASI
            case 'Brickwork'
                % Index all alpha-nbr4 pairs (make sure nbr4 is not blank)
                if ~isempty(app.vd.magnet(alpha).nbr4b)
                    for i = 1:length(vertcat(app.vd.magnet(alpha).nbr4b))
                        pairNbr4b(idx4b,1) = alpha;
                        pairNbr4b(idx4b,2) = app.vd.magnet(alpha).nbr4b(i);
                        idx4b = idx4b+1;
                    end
                end
                % Index all alpha-nbr5 pairs (make sure nbr5 is not blank)
                if ~isempty(app.vd.magnet(alpha).nbr5b)
                    for i = 1:length(vertcat(app.vd.magnet(alpha).nbr5b))
                        pairNbr5b(idx5b,1) = alpha;
                        pairNbr5b(idx5b,2) = app.vd.magnet(alpha).nbr5b(i);
                        idx5b = idx5b+1;
                    end
                end
                % Index all alpha-nbr6 pairs (make sure nbr6 is not blank)
                if ~isempty(app.vd.magnet(alpha).nbr6b)
                    for i = 1:length(vertcat(app.vd.magnet(alpha).nbr6b))
                        pairNbr6b(idx6b,1) = alpha;
                        pairNbr6b(idx6b,2) = app.vd.magnet(alpha).nbr6b(i);
                        idx6b = idx6b+1;
                    end
                end
                % Index all alpha-nbr7 pairs (make sure nbr5 is not blank)
                if ~isempty(app.vd.magnet(alpha).nbr7b)
                    for i = 1:length(vertcat(app.vd.magnet(alpha).nbr7b))
                        pairNbr7b(idx7b,1) = alpha;
                        pairNbr7b(idx7b,2) = app.vd.magnet(alpha).nbr7b(i);
                        idx7b = idx7b+1;
                    end
                end
        end
    end
    
    % Get rid of entries that are zero in both columns
    pairNbr1(pairNbr1(:,1) == 0 & pairNbr1(:,2) == 0,:) = [];
    pairNbr2(pairNbr2(:,1) == 0 & pairNbr2(:,2) == 0,:) = [];
    pairNbr3(pairNbr3(:,1) == 0 & pairNbr3(:,2) == 0,:) = [];
    pairNbr4(pairNbr4(:,1) == 0 & pairNbr4(:,2) == 0,:) = [];
    pairNbr5(pairNbr5(:,1) == 0 & pairNbr5(:,2) == 0,:) = [];
    pairNbr6(pairNbr6(:,1) == 0 & pairNbr6(:,2) == 0,:) = [];
    pairNbr7(pairNbr7(:,1) == 0 & pairNbr7(:,2) == 0,:) = [];
    pairNbr4b(pairNbr4b(:,1) == 0 & pairNbr4b(:,2) == 0,:) = [];
    pairNbr5b(pairNbr5b(:,1) == 0 & pairNbr5b(:,2) == 0,:) = [];
    pairNbr6b(pairNbr6b(:,1) == 0 & pairNbr6b(:,2) == 0,:) = [];
    pairNbr7b(pairNbr7b(:,1) == 0 & pairNbr7b(:,2) == 0,:) = [];
    
    % Sort each row so that the smallest entry is in the first column
    pairNbr1 = sort(pairNbr1,2);
    pairNbr2 = sort(pairNbr2,2);
    pairNbr3 = sort(pairNbr3,2);
    pairNbr4 = sort(pairNbr4,2);
    pairNbr5 = sort(pairNbr5,2);
    pairNbr6 = sort(pairNbr6,2);
    pairNbr7 = sort(pairNbr7,2);
    pairNbr4b = sort(pairNbr4b,2);
    pairNbr5b = sort(pairNbr5b,2);
    pairNbr6b = sort(pairNbr6b,2);
    pairNbr7b = sort(pairNbr7b,2);
    
    % Identify the unique combinations of neighbors
    pairNbr1 = unique(pairNbr1,'rows');
    pairNbr2 = unique(pairNbr2,'rows');
    pairNbr3 = unique(pairNbr3,'rows');
    pairNbr4 = unique(pairNbr4,'rows');
    pairNbr5 = unique(pairNbr5,'rows');
    pairNbr6 = unique(pairNbr6,'rows');
    pairNbr7 = unique(pairNbr7,'rows');
    pairNbr4b = unique(pairNbr4b,'rows');
    pairNbr5b = unique(pairNbr5b,'rows');
    pairNbr6b = unique(pairNbr6b,'rows');
    pairNbr7b = unique(pairNbr7b,'rows');
    
    % Make a list of all indices that have a ignore flag
    ignoreFlagList = find(vertcat(app.vd.magnet.ignoreFlag)==true);
    
    % Remove all pairs containing an index with a ignore flag
    nbr1Flags = ~ismember(pairNbr1,ignoreFlagList);
    nbr1Flags = nbr1Flags(:,1).*nbr1Flags(:,2);
    pairNbr1 = pairNbr1(nbr1Flags == 1,:);
    
    nbr2Flags = ~ismember(pairNbr2,ignoreFlagList);
    nbr2Flags = nbr2Flags(:,1).*nbr2Flags(:,2);
    pairNbr2 = pairNbr2(nbr2Flags == 1,:);
    
    nbr3Flags = ~ismember(pairNbr3,ignoreFlagList);
    nbr3Flags = nbr3Flags(:,1).*nbr3Flags(:,2);
    pairNbr3 = pairNbr3(nbr3Flags == 1,:);
    
    nbr4Flags = ~ismember(pairNbr4,ignoreFlagList);
    nbr4Flags = nbr4Flags(:,1).*nbr4Flags(:,2);
    pairNbr4 = pairNbr4(nbr4Flags == 1,:);
    
    nbr5Flags = ~ismember(pairNbr5,ignoreFlagList);
    nbr5Flags = nbr5Flags(:,1).*nbr5Flags(:,2);
    pairNbr5 = pairNbr5(nbr5Flags == 1,:);
    
    nbr6Flags = ~ismember(pairNbr6,ignoreFlagList);
    nbr6Flags = nbr6Flags(:,1).*nbr6Flags(:,2);
    pairNbr6 = pairNbr6(nbr6Flags == 1,:);
    
    nbr7Flags = ~ismember(pairNbr7,ignoreFlagList);
    nbr7Flags = nbr7Flags(:,1).*nbr7Flags(:,2);
    pairNbr7 = pairNbr7(nbr7Flags == 1,:);
    
    nbr4bFlags = ~ismember(pairNbr4b,ignoreFlagList);
    nbr4bFlags = nbr4bFlags(:,1).*nbr4bFlags(:,2);
    pairNbr4b = pairNbr4b(nbr4bFlags == 1,:);
    
    nbr5bFlags = ~ismember(pairNbr5b,ignoreFlagList);
    nbr5bFlags = nbr5bFlags(:,1).*nbr5bFlags(:,2);
    pairNbr5b = pairNbr5b(nbr5bFlags == 1,:);
    
    nbr6bFlags = ~ismember(pairNbr6b,ignoreFlagList);
    nbr6bFlags = nbr6bFlags(:,1).*nbr6bFlags(:,2);
    pairNbr6b = pairNbr6b(nbr6bFlags == 1,:);
    
    nbr7bFlags = ~ismember(pairNbr7b,ignoreFlagList);
    nbr7bFlags = nbr7bFlags(:,1).*nbr7bFlags(:,2);
    pairNbr7b = pairNbr7b(nbr7bFlags == 1,:);
    
    % Save the pair identifications
    app.vd.pairNbr1 = pairNbr1;
    app.vd.pairNbr2 = pairNbr2;
    app.vd.pairNbr3 = pairNbr3;
    app.vd.pairNbr4 = pairNbr4;
    app.vd.pairNbr5 = pairNbr5;
    app.vd.pairNbr6 = pairNbr6;
    app.vd.pairNbr7 = pairNbr7;
    app.vd.pairNbr4b = pairNbr4b;
    app.vd.pairNbr5b = pairNbr5b;
    app.vd.pairNbr6b = pairNbr6b;
    app.vd.pairNbr7b = pairNbr7b;
    close(currentStatus);
    
    % Plot the final vertices, but make sure to omit any ignoreFlagList indices
    currentStatus = uiprogressdlg(app.IceScannerUI,'Title','Spin-spin correlation',...
        'Message',sprintf('%s\n\n%s','Results are being archived as a movie.',...
        'This will take a while.'));
    v = VideoWriter(sprintf('%sNbr',app.dirImages),'Uncompressed AVI');
    v.FrameRate = 10;
    open(v);
    f = figure('Visible','off');
    f.Position = [10 10 1000 1000];
    ax = axes('Position',[0,0,1,1],'units','normalized');
    axis image;
    hold on
    imshow(mat2gray(app.vd.xmcd),'Parent',ax);
    quiver(app.vd.whiteOffsetX,app.vd.whiteOffsetY,app.vd.whiteVectorX,app.vd.whiteVectorY,'b',...
        'AutoScale','off','LineWidth',1);
    quiver(app.vd.blackOffsetX,app.vd.blackOffsetY,app.vd.blackVectorX,app.vd.blackVectorY,'r',...
        'AutoScale','off','LineWidth',1);
    for alpha = 1:length(app.vd.magnet)
        % Plot
        if app.vd.magnet(alpha).ignoreFlag == false
            % Alpha
            t = title(ax,sprintf('alpha = %d',alpha));
            pltAlpha = text(vertcat(app.vd.magnet(alpha).colXPos),vertcat(app.vd.magnet(alpha).rowYPos),...
                sprintf('%d',alpha),'Color','green','FontSize',15,'FontWeight','bold','HorizontalAlignment','center');
            circAlpha = plot(vertcat(app.vd.magnet(alpha).colXPos),vertcat(app.vd.magnet(alpha).rowYPos),'ro',...
                'MarkerSize',15);
            % Nbr1 "Beta"
            finalNbr1 = app.vd.magnet(alpha).nbr1;
            finalNbr1 = finalNbr1(~ismember(finalNbr1,ignoreFlagList));
            pltNbr1 = text(vertcat(app.vd.magnet(finalNbr1).colXPos),vertcat(app.vd.magnet(finalNbr1).rowYPos),...
                '1','Color','blue','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
            % Nbr2 "Gamma"
            finalNbr2 = app.vd.magnet(alpha).nbr2;
            finalNbr2 = finalNbr2(~ismember(finalNbr2,ignoreFlagList));
            pltNbr2 = text(vertcat(app.vd.magnet(finalNbr2).colXPos),vertcat(app.vd.magnet(finalNbr2).rowYPos),...
                '2','Color','red','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
            % Nbr3 "Nu"
            finalNbr3 = app.vd.magnet(alpha).nbr3;
            finalNbr3 = finalNbr3(~ismember(finalNbr3,ignoreFlagList));
            pltNbr3 = text(vertcat(app.vd.magnet(finalNbr3).colXPos),vertcat(app.vd.magnet(finalNbr3).rowYPos),...
                '3','Color','blue','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
            % Nbr4 "Delta"
            finalNbr4 = app.vd.magnet(alpha).nbr4;
            finalNbr4 = finalNbr4(~ismember(finalNbr4,ignoreFlagList));
            pltNbr4 = text(vertcat(app.vd.magnet(finalNbr4).colXPos),vertcat(app.vd.magnet(finalNbr4).rowYPos),...
                '4','Color','red','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
            % Nbr5 "Eta"
            finalNbr5 = app.vd.magnet(alpha).nbr5;
            finalNbr5 = finalNbr5(~ismember(finalNbr5,ignoreFlagList));
            pltNbr5 = text(vertcat(app.vd.magnet(finalNbr5).colXPos),vertcat(app.vd.magnet(finalNbr5).rowYPos),...
                '5','Color','blue','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
            % Nbr6 "Phi"
            finalNbr6 = app.vd.magnet(alpha).nbr6;
            finalNbr6 = finalNbr6(~ismember(finalNbr6,ignoreFlagList));
            pltNbr6 = text(vertcat(app.vd.magnet(finalNbr6).colXPos),vertcat(app.vd.magnet(finalNbr6).rowYPos),...
                '6','Color','red','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
            % Nbr7 "Tau"
            finalNbr7 = app.vd.magnet(alpha).nbr7;
            finalNbr7 = finalNbr7(~ismember(finalNbr7,ignoreFlagList));
            pltNbr7 = text(vertcat(app.vd.magnet(finalNbr7).colXPos),vertcat(app.vd.magnet(finalNbr7).rowYPos),...
                '7','Color','blue','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
            switch app.vd.typeASI
                case 'Brickwork'
                    % Nbr4b "Delta"
                    finalNbr4b = app.vd.magnet(alpha).nbr4b;
                    finalNbr4b = finalNbr4b(~ismember(finalNbr4b,ignoreFlagList));
                    pltNbr4b = text(vertcat(app.vd.magnet(finalNbr4b).colXPos),vertcat(app.vd.magnet(finalNbr4b).rowYPos),...
                        '4b','Color','red','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
                    % Nbr5b "Eta"
                    finalNbr5b = app.vd.magnet(alpha).nbr5b;
                    finalNbr5b = finalNbr5b(~ismember(finalNbr5b,ignoreFlagList));
                    pltNbr5b = text(vertcat(app.vd.magnet(finalNbr5b).colXPos),vertcat(app.vd.magnet(finalNbr5b).rowYPos),...
                        '5b','Color','blue','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
                    % Nbr6b "Phi"
                    finalNbr6b = app.vd.magnet(alpha).nbr6b;
                    finalNbr6b = finalNbr6b(~ismember(finalNbr6b,ignoreFlagList));
                    pltNbr6b = text(vertcat(app.vd.magnet(finalNbr6b).colXPos),vertcat(app.vd.magnet(finalNbr6b).rowYPos),...
                        '6b','Color','red','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
                    % Nbr7b "Tau"
                    finalNbr7b = app.vd.magnet(alpha).nbr7b;
                    finalNbr7b = finalNbr7b(~ismember(finalNbr7b,ignoreFlagList));
                    pltNbr7b = text(vertcat(app.vd.magnet(finalNbr7b).colXPos),vertcat(app.vd.magnet(finalNbr7b).rowYPos),...
                        '7b','Color','blue','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
            end
            frame = getframe(f);
            writeVideo(v,frame);
            delete(pltAlpha);
            delete(pltNbr1);
            delete(pltNbr2);
            delete(pltNbr3);
            delete(pltNbr4);
            delete(pltNbr5);
            delete(pltNbr6);
            delete(pltNbr7);
            switch app.vd.typeASI
                case 'Brickwork'
                    delete(pltNbr4b);
                    delete(pltNbr5b);
                    delete(pltNbr6b);
                    delete(pltNbr7b);
            end
            delete(circAlpha);
            delete(t);
        end
        currentStatus.Value = alpha/length(app.vd.magnet);
    end
    close(v);
    close(f);
    close(currentStatus);
end