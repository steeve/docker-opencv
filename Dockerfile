from	ubuntu:14.04

# Ubuntu sides with libav, I side with ffmpeg.
run	echo "deb http://ppa.launchpad.net/mc3man/gstffmpeg-keep/ubuntu trusty main" >> /etc/apt/sources.list
#       run	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1DB8ADC1CFCA9579
run	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 90BD7EACED8E640A 
#run	add-apt-repository ppa:gwibber-daily/ppa

run	apt-get update
run	apt-get install -y -q wget curl
run	apt-get install -y -q build-essential
run	apt-get install -y -q cmake
run	apt-get install -y -q python2.7 python2.7-dev python-pip
run	wget 'https://pypi.python.org/packages/2.7/s/setuptools/setuptools-0.6c11-py2.7.egg' && /bin/sh setuptools-0.6c11-py2.7.egg && rm -f setuptools-0.6c11-py2.7.egg
#run	curl 'https://raw.github.com/pypa/pip/master/contrib/get-pip.py' | python2.7
run	pip install numpy
run	apt-get install -y -q libavformat-dev libavcodec-dev libavfilter-dev libswscale-dev
run	apt-get install -y -q libjpeg-dev libpng-dev libtiff-dev libjasper-dev zlib1g-dev libopenexr-dev libxine-dev libeigen3-dev libtbb-dev
add	build_opencv.sh	/build_opencv.sh
run	/bin/sh /build_opencv.sh
run	rm -rf /build_opencv.sh
