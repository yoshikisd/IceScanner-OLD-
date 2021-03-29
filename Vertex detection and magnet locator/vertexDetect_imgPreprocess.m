% Processes imported images for vertex detection via EMD
function outputImg = vertexDetect_imgPreprocess(app,inputImg)
    contrastLowerLimit = 0;
    contrastUpperLimit = 1;

    outputImg = imadjust(abs(imresize(mat2gray(inputImg),app.EMD_scaleFactor.Value)),...
        [contrastLowerLimit,contrastUpperLimit],[]);

    % If the imported image file is RGB, reduce to grayscale
    [~,~,z1] = size(outputImg);
    if z1 > 1
        outputImg = rgb2gray(outputImg);
    end
end