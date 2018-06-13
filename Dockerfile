FROM	ubuntu:12.10

# Ubuntu sides with libav, I side with ffmpeg.
RUN	echo "deb http://ppa.launchpad.net/jon-severinsson/ffmpeg/ubuntu quantal main" >> /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1DB8ADC1CFCA9579 && \
    apt-get update && \
    apt-get install -y -q wget curl && \
    apt-get install -y -q build-essential && \
    apt-get install -y -q cmake && \
    apt-get install -y -q python2.7 python2.7-dev && \
    wget 'https://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg' && /bin/sh setuptools-0.6c11-py2.7.egg && rm -f setuptools-0.6c11-py2.7.egg && \
    curl 'https://raw.github.com/pypa/pip/master/contrib/get-pip.py' | python2.7 && \
    pip install numpy && \
    apt-get install -y -q libavformat-dev libavcodec-dev libavfilter-dev libswscale-dev && \
    apt-get install -y -q libjpeg-dev libpng-dev libtiff-dev libjasper-dev zlib1g-dev libopenexr-dev libxine-dev libeigen3-dev libtbb-dev

ADD 	build_opencv.sh	/build_opencv.sh
RUN	/bin/sh /build_opencv.sh && \
    rm -rf /build_opencv.sh
