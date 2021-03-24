function removeRedundantNbrIdx(app)
    % Generates a list of unique vertex pairs based on what n-th neighbors they are
    pairNbr1 = zeros(length(app.vd.magnet)*10,2);
    pairNbr2 = zeros(length(app.vd.magnet)*10,2);
    pairNbr3 = zeros(length(app.vd.magnet)*10,2);
    pairNbr4 = zeros(length(app.vd.magnet)*10,2);
    pairNbr5 = zeros(length(app.vd.magnet)*10,2);
    pairNbr6 = zeros(length(app.vd.magnet)*10,2);
    pairNbr7 = zeros(length(app.vd.magnet)*10,2);

    % Initialize a counter variable i
    idx1 = 1;
    idx2 = 1;
    idx3 = 1;
    idx4 = 1;
    idx5 = 1;
    idx6 = 1;
    idx7 = 1;
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
    end
    
    % Get rid of entries that are zero in both columns
    pairNbr1(pairNbr1(:,1) == 0 & pairNbr1(:,2) == 0,:) = [];
    pairNbr2(pairNbr2(:,1) == 0 & pairNbr2(:,2) == 0,:) = [];
    pairNbr3(pairNbr3(:,1) == 0 & pairNbr3(:,2) == 0,:) = [];
    pairNbr4(pairNbr4(:,1) == 0 & pairNbr4(:,2) == 0,:) = [];
    pairNbr5(pairNbr5(:,1) == 0 & pairNbr5(:,2) == 0,:) = [];
    pairNbr6(pairNbr6(:,1) == 0 & pairNbr6(:,2) == 0,:) = [];
    pairNbr7(pairNbr7(:,1) == 0 & pairNbr7(:,2) == 0,:) = [];
    
    % Sort each row so that the smallest entry is in the first column
    pairNbr1 = sort(pairNbr1,2);
    pairNbr2 = sort(pairNbr2,2);
    pairNbr3 = sort(pairNbr3,2);
    pairNbr4 = sort(pairNbr4,2);
    pairNbr5 = sort(pairNbr5,2);
    pairNbr6 = sort(pairNbr6,2);
    pairNbr7 = sort(pairNbr7,2);
    
    % Identify the unique combinations of neighbors
    pairNbr1 = unique(pairNbr1,'rows');
    pairNbr2 = unique(pairNbr2,'rows');
    pairNbr3 = unique(pairNbr3,'rows');
    pairNbr4 = unique(pairNbr4,'rows');
    pairNbr5 = unique(pairNbr5,'rows');
    pairNbr6 = unique(pairNbr6,'rows');
    pairNbr7 = unique(pairNbr7,'rows');
    
    % Save the pair identifications
    app.vd.pairNbr1 = pairNbr1;
    app.vd.pairNbr2 = pairNbr2;
    app.vd.pairNbr3 = pairNbr3;
    app.vd.pairNbr4 = pairNbr4;
    app.vd.pairNbr5 = pairNbr5;
    app.vd.pairNbr6 = pairNbr6;
    app.vd.pairNbr7 = pairNbr7;
    close(currentStatus);
end