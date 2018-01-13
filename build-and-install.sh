#!/bin/bash

# 1. UPGRADING AND CLEANING

apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove
apt-get -y autoclean

# 2. INSTALL THE DEPENDENCIES

# Build tools:
apt-get install -y build-essential cmake git

apt-get install libopencv-dev

# GUI (if you want to use GTK instead of Qt, replace 'qt5-default' with 'libgtkglext1-dev' and remove '-DWITH_QT=ON' option in CMake):
apt-get install -y libgtk-3-dev libgtkglext1-dev qt5-default vtk6 libvtk6-dev

# Media I/O:
apt-get install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev libpng12-dev libgphoto2-dev

# Video I/O:
apt-get install -y libdc1394-22 libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev v4l-utils libv4l-dev libxine2-dev libgstreamer0.10-dev libavresample-dev libgstreamer-plugins-base0.10-dev

# Others
apt-get install -y libmp3lame-dev libfaac-dev checkinstall

# Tesseract support
apt-get install -y tesseract-ocr libtesseract-dev libleptonica-dev

# Parallelism and linear algebra libraries:
apt-get install -y libtbb-dev libeigen3-dev libopenblas-dev liblapacke-dev

# Python:
apt-get install -y python-dev python-tk python-numpy python3-dev python3-tk python3-numpy

# Java:
apt-get install -y ant default-jdk

# Documentation:
apt-get install -y doxygen

OPENCV_INSTALL_VERSION="3.4.0"

if [ ! -v SOURCE_ROOT ]; then SOURCE_ROOT=$(mktemp -d); fi
SOURCE_ROOT_OPENCV=$SOURCE_ROOT/opencv
SOURCE_ROOT_OPENCV_CONTRIB=$SOURCE_ROOT/opencv_contrib
SOURCE_ROOT_OPENCV_BUILD=$SOURCE_ROOT_OPENCV/build

if [ ! -v INSTALL_PREFIX ]; then INSTALL_PREFIX=/usr/local; fi

cd $SOURCE_ROOT
git clone https://github.com/opencv/opencv_contrib $SOURCE_ROOT_OPENCV_CONTRIB
git clone https://github.com/opencv/opencv $SOURCE_ROOT_OPENCV && cd $SOURCE_ROOT_OPENCV && git checkout $OPENCV_INSTALL_VERSION
mkdir $SOURCE_ROOT_OPENCV_BUILD && cd $SOURCE_ROOT_OPENCV_BUILD

CMAKE_FLAGS="-DWITH_QT=ON"
CMAKE_FLAGS=$CMAKE_FLAGS" -DOPENCV_EXTRA_MODULES_PATH=$SOURCE_ROOT/opencv_contrib/modules"
CMAKE_FLAGS=$CMAKE_FLAGS" -DCMAKE_BUILD_TYPE=RELEASE"
CMAKE_FLAGS=$CMAKE_FLAGS" -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX"
CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_OPENGL=ON"
CMAKE_FLAGS=$CMAKE_FLAGS" -DFORCE_VTK=ON"
CMAKE_FLAGS=$CMAKE_FLAGS" -D WITH_QT=ON"
CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_TBB=ON"
CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_GDAL=ON"
CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_XINE=ON"
CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_GSTREAMER=ON"
CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_V4L=ON"
CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_LIBV4L=ON"
CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_CUDA=OFF"
# CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_TESSERACT=ON"
CMAKE_FLAGS=$CMAKE_FLAGS" -DBUILD_EXAMPLES=ON"
CMAKE_FLAGS=$CMAKE_FLAGS" -DENABLE_PRECOMPILED_HEADERS=OFF"

cmake $CMAKE_FLAGS ..
JOBS=$(($(cat /proc/cpuinfo | awk '/^processor/{print $3}' | tail -1) + 1))
make -j $JOBS
make install
ldconfig

if [ -v SOURCE_ROOT_DELETE_AT_END ]; then rm -rf $SOURCE_ROOT; fi

# 4. EXECUTE SOME OPENCV EXAMPLES AND COMPILE A DEMONSTRATION
#
# To complete this step, please visit 'http://milq.github.io/install-opencv-ubuntu-debian'.
