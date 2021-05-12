# IceScanner - Artificial spin ice analysis toolbox
MATLAB application containing tools to analyze XMCD-PEEM images of artificial spin ice (ASI) arrays.

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

## Usage
### Preprocessing - Vertex detection tab
- **Operating principles**: IceScanner relies on the locations of vertices in an ASI topography image to "read" the corresponding magnetic contrast image of the array (e.g., interpret magnet locations and magnetizations). Vertex detection is performed by calculating the Earth Mover's Distance (EMD) between a user-specified reference image of a vertex (**reference image**) and some location within the main topography image (**main image**). **Long story short, the EMD can be used to figure out how dissimilar regions in the main image are compared to the reference image.** If the two images are identical, EMD = 0. The value of the EMD will increase depending on how dissimilar the two images are. This, in effect, helps IceScanner to "see" vertices in the image.
- **Performing vertex detection**: 
  1.  First, open IceScanner and wait until the graphical interface looks like the picture shown here (will attach in a bit...). This may take a while to fully update (blame MATLAB).
  2.  From the drop-down menu, select the type of ASI you wish to analyze. Currently, only square, brickwork, and Kagome ASIs can be analyzed (Tetris is under development).
  3.  Click the "Topography image" button to select the ASI topography image to import (must be tiff/tif format).
  4.  Adjust the flatfield sigma to "flatten" the image; the goal here is to make all features around each vertex look identical to one another.
    -  Lowering the sigma will make the image "flatter"
  5.  Move the blue region-of-interest (ROI) box so that the box center is aligned with a vertex. The part of the image within this box can now be stored as a reference image of a vertex.
  6.  Once the ROI box has been positioned to the desired location, you can save this as the 1st/2nd/3rd/... reference image by clicking the button with the corresponing text. The image of the selected region should now appear above the pressed button.
  7.  Repeat steps i-iv for each unique reference image (see notes about unique vertices).
  8.  Once all unique reference images have been defined, press the "Start EMD" button.


### "Reading" the ASI magnetizations - Image analysis tab

Will update a bit more in the coming days...
