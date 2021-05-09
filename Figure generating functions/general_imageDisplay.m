% General plotting function to make sure the image takes up the entire frame
function general_imageDisplay(app,refFrame,imageSelect)
    cla(refFrame);
    [imgHeight,imgWidth,~] = size(imageSelect);
    imshow(imageSelect,'Parent',refFrame,'InitialMagnification','fit');
    refFrame.XLim = [0 imgHeight];
    refFrame.YLim = [0 imgWidth];
end