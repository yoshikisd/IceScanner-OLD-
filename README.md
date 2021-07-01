# IceScanner - Artificial spin ice analysis toolbox
MATLAB application containing tools to analyze XMCD-PEEM images of artificial spin ice arrays.

This application contains several functions that can be used to analyze artificial spin ice arrays with square, brickwork, and Kagome geometries. By providing the application reference topography images of the ASI vertices, this application can perform automated vertex detection using the Earth Movers Distance and perform subsequent nanomagnet position/magnetization detection as well as map each nanomagnet to points in an ideal Cartesian/hexagonal coordinate system. The application can use this information to output counts of vertex types and produce a corresponding magnetic structure factor image.

This package uses mexopencv functions developed by Dr. Kota Yamaguchi (https://github.com/kyamagu/mexopencv) as well as pre-built OpenCV binaries. Specifically, the files EMD.mexw64 (renamed to cvEMD.mexw64), opencv_core341.dll, and opencv_imgproc341.dll were used to perform vertex detection. For convenience, a copy of these functions have been included in this repository so that this toolbox can be executed without having to compile both OpenCV and MEXOpenCV packages.

## Installation/Build
Prerequisite:
- MATLAB version R2020 or R2021a (if you plan on running the mlapp file)
- OpenCV (3.4.1, see details below if you do not want to use the included DLL files/installer)

### OpenCV and mexopencv components
The vertex detection functionality of this app is based on Dr. Kota Yamaguchi's mexopencv, which uses the final 3.4.1 stable version of OpenCV. Consequently, certain components of OpenCV 3.4.1 need to be present on your computer for this program to function properly. There are a couple of ways to install OpenCV on to your system

- **The simple method:** 
  - If you wish to run the IceScanner application, run the IceScanner and MATLAB Runtime installer (the necessary files are incorporated in the executable). 
  - If you wish to run the MATLAB files, find the opencv_core341.dll and opencv_imgproc341.dll prebuilt binaries located in the "Vertex detection and magnet locator" folder. Make sure that these files remain in the same folder as the vertexDetect_EMD.m function.

- **The "I don't trust the DLL files some random dude on the Internet is providing" method:** The other alternative is to compile OpenCV and MEXOpenCV from scratch. Dr. Yamaguchi provides a guide on how you can install OpenCV on different operating systems (https://github.com/kyamagu/mexopencv/wiki). It takes some time to compile everything (hence why I provided the prebuilt binaries), but you will be able to also use the other mexopencv functions Dr. Yamaguchi has to offer! 

  - **READ THIS CAREFULLY WHEN USING CMAKE:** In Cmake, when you press the "Configure" button for the first time you will be asked to specify the generator for your project (some version of Visual Studio). Make sure you have that exact version of Visual Studio installed or the configure step will fail. At the time of writing this, I used Visual Studio 14 2015 and CMake version 3.7.2 x64.


# Analyzing magnetic contrast images of ASIs
The current version of IceScanner is only capable of analyzing XMCD-PEEM images of ASIs. Integration of magnetic force microscopy (MFM) images will be incorporated in the future.

Before starting the analysis, ensure that you have both the asymmetry (XMCD-PEEM) and corresponding single/averaged polarization (XA-PEEM) images. The latter will serve as the topography image from which IceScanner will perform vertex detection on. Also ensure that the images are 32 bit tif files; the magnetic contrast needs to vary between positive and negative values, corresponding to either parallel or antiparallel alignment with the X-ray vector.


## Image preprocessing: Vertex detection

### Step 1: Import images
When opening IceScanner for the first time, you will automatically be directed to the "Import images" step of the vertex detection process as shown in the image below:

![image](https://user-images.githubusercontent.com/37006268/124043639-446eea80-d9c0-11eb-8c72-084b22e2c000.png)

To import a new image, first select the "Type" dropdown menu to select the type of ASI you wish to analyze. Currently only square, brickwork, and Kagome can be analyzed (Tetris ASI analysis is being incorportated; you can try it out at your own risk). Then select the "Topography image" button and select the XA-PEEM image file you wish to import. 

The XA-PEEM image, as well as a square ROI, should be shown in the bottom half of the IceScanner UI:

![image](https://user-images.githubusercontent.com/37006268/124043894-eee70d80-d9c0-11eb-84ae-33e19b76c309.png)

In order for IceScanner to perform automated detection of vertices in the ASI, we must provide a reference image of a vertex. It should be noted, however, that vertex detection works best if every vertex looks identical to one another (both in terms of geometry and relative intensity). One way that we can "flatten" out the image is to perform a flatfield correction. Adjust the value of the "Flatfield sigma" by entering a value and pressing enter. The bottom half if the IceScanner UI will automatically update with the new flatfield-corrected image. Generally, the smaller you make the sigma value, the "flatter" the image becomes. 

In the image shown below, the flatfield sigma was reduced from 100 to 5.

![image](https://user-images.githubusercontent.com/37006268/124044216-c27fc100-d9c1-11eb-96c3-1441a9733c2a.png)

Drag the ROI (blue box) so that the center of the ROI coincides with a vertex. In order to zoom into a region on the image, hover your mouse over the XA-PEEM image until five tool buttons appear on the top-right hand of the image (below the "Next (start EMD) button). Click on the magnifying glass and select a region around the ROI to zoom in. Before dragging the ROI, make sure that you deselect the magnifying glass tool by clicking it once more; the magnifying glass color should change from blue back to gray. 

You may also increase/devrease the size of the square ROI by changing the "ROI edge size". However, you must make sure that the value is ODD. Increasing this value may make the vertex detection more accurate, it also increases the time required to complete the detection. By default this value is set to 35.

In the image shown below, the ROI is positioned on the center of the vertex. Also shown are the five tool buttons below the "Next (start EMD" button.

![image](https://user-images.githubusercontent.com/37006268/124044317-05419900-d9c2-11eb-858b-0c52d24ffa90.png)

Once you have set the ROI to the desired location, you can save the reference image by pressing the "Select n-th ref." (either 1st, 2nd, 3rd, ...). Depending on the ASI you choose you may have multiple vertices that possess unique arrangements of the adjacent nanoislands.

- For Square ASI: Only one unique vertex exist and, therefore, only "Select 1st ref" is enabled.
- For Kagome ASI: Two unique vertex appearance exists (magnets arranges as >- and -<). Both "Select 1st ref" and "Select 2nd ref" are enabled. It does not matter which arrangement is used for either reference.
- For Brickwork ASI: Same as Kagome with the exception that the 1st reference MUST look like a "y" (either forward or backward) and the 2nd reference MUST look like a lambda (either forwards or backwards).

The image below shows what the UI looks like after selecting the first reference.

![image](https://user-images.githubusercontent.com/37006268/124048934-49d23200-d9cc-11eb-96d6-66cd9a334260.png)

Once the reference images have been select, press the "Next (start EMD)" button. IceScanner will perform two tasks: (1, left image) It will first set things up so that all CPU cores can be utilized to calculate the detection and (2, right image) the calculations will be performed on all accessible cores.

During the first process, MATLAB may ask for you to allow IceScanner to access your network. You may deny this request and things should still work fine.

![image](https://user-images.githubusercontent.com/37006268/124049188-c82ed400-d9cc-11eb-9937-b20d8782ea2c.png)![image](https://user-images.githubusercontent.com/37006268/124049198-ccf38800-d9cc-11eb-8992-65cd02b78278.png)

To further speed up the calculations you may also change the following values (though it is not recommended):
- "Scale (1-0.41)": This value changes how both the ROI and XA-PEEM images are scaled. Downscaling these images means there's less pixels for IceScanners to deal with (and, therefore, speeds up calculations). By default, the value is set to 0.41, which I have found to yield decent computation speed while minimizing garbage detection points. If you do decide to change the scale, you need to make sure that the final rounded width of the reference image is ODD.
- "Skip # of pixels": This value tells IceScanner to skip a certain number of pixels after scanning a given area. In principle, the calculations should speed up by a factor of whatever number you set "Skip # of pixels" to. However, increasing this value will also reduce the ability of IceScanner to properly detect vertices.

### Step 2: Thresholding
Once the EMD calculation have been completed, IceScanner will move you to the "Thresholding" step window. At this point, IceScanner has internally calculated a surface where each point on the surface corresponds to how dissimilar a region on the XA-PEEM image is compared to the reference vertex. In other words, each minima on that calculated surface corresponds to a potential location of a vertex. At the moment the software is not smart enough to figure out where thise minima are in a robust manner.

What you will need to do is to specify a threshold value. Below this threshold value is where the potential vertex locations are at. To do this is rather straightforward:
- Change the values of one of the reference thresholds in increments of 0.1-0.5 and watch how many dots appear in the XA-PEEM images. These dots corresponds to potential vertex locations.
  - Increasing this value will cause more vertices to pop up. However, increasing this value too much will also result in the acceptance of areas that are not vertices.
  - It is normal to see clusters of points around a vertex. These clusters can be reduced into one single point in subsequent processing steps.
- Continue changing the threshold value until you minimize the amount of garbage detection points while accepting the most amount of vertices.
  - In later processing steps you can manually add or delete vertex locations.

The image below shows an example of a manually-optimized threshold for the square ASI. Note that the defective region close to the center does not possess any detected points.

![image](https://user-images.githubusercontent.com/37006268/124050387-56a45500-d9cf-11eb-8727-cb9017d0b514.png)

Once completed, select the "Save results" button to export the pre-processed data as a MAT file.
