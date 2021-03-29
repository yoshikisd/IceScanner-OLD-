# IceScanner - Artificial spin ice analysis toolbox

MATLAB application containg tools to analyze XMCD-PEEM images of artificial spin ice arrays.

This application contains several functions that can be used to analyze artificial spin ice arrays with square, brickwork, and Kagome geometries. By providing the application reference topography images of the ASI vertices, this application can perform automated vertex detection using the Earth Movers Distance and perform subsequent nanomagnet position/magnetization detection as well as map each nanomagnet to points in an ideal Cartesian/hexagonal coordinate system. The application can use this information to output counts of vertex types and produce a corresponding magnetic structure factor image.

This package uses mexopencv functions developed by Dr. Kota Yamaguchi (https://github.com/kyamagu/mexopencv). Specifically, the EMD functions (EMD.m and EMD.mexw64) were used to perform vertex detection. For convenience, a copy of these functions have been included in this repository so that this toolbox can be executed without having to compile the entire MEXOpenCV package.

**Before running this package on MATLAB or running the standalone executable, please read the installation instructions. If you don't, you're probably going to get a headache because of some OpenCV-related issue.**

## Installation/Build
Prerequisite:
- MATLAB version R2020 or R2021a (if you plan on running the mlapp file)
- OpenCV (3.4.1, see details below on how you can avoid having to build this)

### OpenCV
The vertex detection functionality of this app is based on Dr. Kota Yamaguchi's mexopencv, which uses the final 3.4.1 stable version of OpenCV. Consequently, certain components of OpenCV 3.4.1 need to be present on your computer for this program to function properly. There are a couple of ways to install OpenCV on to your system

- **The simple method:** Unzip the contents of the "Pre-built OpenCV.7z", which, as the name implies, contains some prebuilt OpenCV binaries that I think are essential for the mexopencv function to run properly (for the folks that have built OpenCV in the past using CMake and Visual Studio, this is basically all the DLL files contained within the build/install/x64/vc14/bin folder). Then, you will need to add the folder containing these DLL files to the PATH environment variable (go to "System Properties" and select the "Advanced" tab, select the button "Environment Variables...", edit the system Path variable and add the OpenCV dll folder path to the variable value).

- **The "I don't trust the DLL files some random dude on the Internet is providing" method:** The other alternative is to compile OpenCV from scratch. Dr. Yamaguchi provides a guide on how you can install OpenCV on different operating systems (https://github.com/kyamagu/mexopencv/wiki). It takes some time to compile everything (hence why I provided the prebuilt binaries), but you will be able to also use the other mexopencv functions Dr. Yamaguchi has to offer! 

  - **READ THIS CAREFULLY WHEN USING CMAKE:** In Cmake, when you press the "Configure" button for the first time you will be asked to specify the generator for your project (some version of Visual Studio). Make sure you have that exact version of Visual Studio installed or the configure step will fail. At the time of writing this, I used Visual Studio 14 2015 and CMake version 3.7.2 x64.

### The IceScanner application
There are a couple of ways you can use this application: either directly running the mlapp file through MATLAB (R2020a or later) or running the installer which will install an IceScanner executable along with the required MATLAB runtime (which is free). I recommend running the package through MATLAB as your debugging capabilities will be very limited if you choose to run the executable.

Will update a bit more in the coming days...
