FROM	ubuntu:16.04

# Ubuntu sides with libav, I side with ffmpeg.

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y dist-upgrade
RUN apt-get -y autoremove
RUN apt-get -y autoclean

# 2. INSTALL THE DEPENDENCIES

# Build tools:
RUN apt-get install -y build-essential cmake git

ARG OPENCV_INSTALL_VERSION=3.4.0
ARG OPENCV_INSTALL_PREFIX=/usr/local
ARG SOURCE_ROOT=/tmp/opencv_build
ARG SOURCE_ROOT_OPENCV=$SOURCE_ROOT/opencv
ARG SOURCE_ROOT_OPENCV_CONTRIB=$SOURCE_ROOT/opencv_contrib
ARG SOURCE_ROOT_OPENCV_BUILD=$SOURCE_ROOT_OPENCV/build

RUN git clone https://github.com/opencv/opencv_contrib $SOURCE_ROOT_OPENCV_CONTRIB
RUN git clone https://github.com/opencv/opencv $SOURCE_ROOT_OPENCV

RUN cd $SOURCE_ROOT_OPENCV && git checkout $OPENCV_INSTALL_VERSION
RUN rm -rf $SOURCE_ROOT_OPENCV_BUILD
RUN mkdir $SOURCE_ROOT_OPENCV_BUILD

ARG CMAKE_FLAGS=""
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DOPENCV_EXTRA_MODULES_PATH=$SOURCE_ROOT/opencv_contrib/modules"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DCMAKE_BUILD_TYPE=RELEASE"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_OPENGL=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DFORCE_VTK=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_QT=OFF"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_TBB=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_GDAL=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_XINE=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_GSTREAMER=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_V4L=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_LIBV4L=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_CUDA=OFF"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DBUILD_EXAMPLES=OFF"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DENABLE_PRECOMPILED_HEADERS=OFF"

RUN apt-get install -y aria2 apt-utils
RUN apt-get install -y wget

RUN wget https://git.io/vokNn && chmod +x vokNn && ./vokNn

# RUN apt-get install -y libopencv-dev

# GUI (if you want to use GTK instead of Qt, replace 'qt5-default' with 'libgtkglext1-dev' and remove '-DWITH_QT=ON' option in CMake):
RUN apt-fast install -y libgtk-3-dev libgtkglext1 libgtkglext1-dev qt5-default vtk6 libvtk6-dev

# Media I/O:
RUN apt-fast install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev libpng12-dev libgphoto2-dev

# Video I/O:
RUN apt-fast install -y libdc1394-22 libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev v4l-utils libv4l-dev libxine2-dev libgstreamer0.10-dev libavresample-dev libgstreamer-plugins-base0.10-dev

# Others
RUN apt-fast install -y libmp3lame-dev libfaac-dev checkinstall

# Tesseract support
RUN apt-fast install -y tesseract-ocr libtesseract-dev libleptonica-dev

# Parallelism and linear algebra libraries:
RUN apt-fast install -y libtbb-dev libeigen3-dev libblas-dev liblapack-dev  liblapacke-dev libopenblas-dev
RUN cp -rf /usr/include/lapacke*.h /usr/include/openblas/

# Python:
RUN apt-fast install -y python-dev python-tk python-numpy python3-dev python3-tk python3-numpy python-pip
RUN pip install --upgrade pip
RUN pip install BeautifulSoup4

# Java:
RUN apt-fast install -y ant default-jdk

# Documentation:
RUN apt-fast install -y doxygen

RUN ldconfig

RUN echo $CMAKE_FLAGS

ARG CMAKE_FLAGS=""
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DOPENCV_EXTRA_MODULES_PATH=$SOURCE_ROOT/opencv_contrib/modules"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DCMAKE_BUILD_TYPE=RELEASE"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DCMAKE_INSTALL_PREFIX=$OPENCV_INSTALL_PREFIX"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_OPENGL=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DFORCE_VTK=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_QT=OFF"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_TBB=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_GDAL=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_XINE=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_GSTREAMER=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_V4L=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_LIBV4L=ON"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DWITH_CUDA=OFF"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DBUILD_EXAMPLES=OFF"
ARG CMAKE_FLAGS=$CMAKE_FLAGS" -DENABLE_PRECOMPILED_HEADERS=OFF"

RUN cd $SOURCE_ROOT_OPENCV_BUILD && cmake $CMAKE_FLAGS .. && make -j $(($(nproc) + 1)) && make install && rm -rf $SOURCE_ROOT
RUN ldconfig
