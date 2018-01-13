from	ubuntu:17.10

# Ubuntu sides with libav, I side with ffmpeg.

run export SOURCE_ROOT_DELETE_AT_END=true
add	build-and-install.sh	/build-and-install.sh
run	/bin/bash /build-and-install.sh
run	rm -rf /build-and-install.sh
