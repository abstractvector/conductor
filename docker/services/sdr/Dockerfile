FROM phusion/baseimage:0.11

ENV WXWIDGETS_VERSION 3.1.3

RUN apt-get update \
    && apt-get dist-upgrade -yf \
    && apt-get clean \
    && apt-get autoremove

RUN apt-get install -y git build-essential automake cmake g++ swig libgtk2.0-dev libpulse-dev libpython-dev python-numpy mesa-utils freeglut3-dev freeglut3

WORKDIR /tmp

RUN apt-get install -y wget

ENV WXWIDGETS_VERSION 3.1.2

RUN git clone https://github.com/jgaeddert/liquid-dsp.git \
    && wget https://github.com/wxWidgets/wxWidgets/releases/download/v${WXWIDGETS_VERSION}/wxWidgets-${WXWIDGETS_VERSION}.tar.bz2 \
    && tar -xvjf wxWidgets-${WXWIDGETS_VERSION}.tar.bz2 \
    && git clone https://github.com/pothosware/SoapySDR.git \
    && git clone https://github.com/pothosware/SoapySDRPlay.git \
    && git clone https://github.com/pothosware/SoapyRemote.git \
    && git clone https://github.com/cjcliffe/CubicSDR.git

RUN apt-get install -y fftw3 libfftw3-dev

# install libcorrect???

RUN cd /tmp \
    && git clone https://github.com/quiet/libcorrect.git \
    && cd /tmp/libcorrect \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && make shim \
    && make install

RUN cd /tmp/liquid-dsp \
    # Build liquid-dsp
    && ./bootstrap.sh \
    && ./configure --enable-fftoverride \
    && make -j4 \
    && make install \
    && ldconfig \
    && cd /tmp/wxWidgets-${WXWIDGETS_VERSION}/ \
    # Build wxwidgets
    && mkdir -p ~/Develop/wxWidgets-staticlib \
    && ./autogen.sh \
    && ./configure --with-opengl --disable-shared --enable-monolithic --with-libjpeg --with-libtiff --with-libpng --with-zlib --disable-sdltest --enable-unicode --enable-display --enable-propgrid --disable-webkit --disable-webview --disable-webviewwebkit --prefix=`echo ~/Develop/wxWidgets-staticlib` CXXFLAGS="-std=c++0x" --with-libiconv=/usr \
    && make -j4 \
    && make install

ENV SDRPLAY_INSTALL_SCRIPT_VERSION 2.13.1

COPY install/SDRplay_RSP_API-Linux-${SDRPLAY_INSTALL_SCRIPT_VERSION}.run .

RUN cd /tmp \
    && mkdir sdrplay \
    && chmod +x SDRplay_RSP_API-Linux-${SDRPLAY_INSTALL_SCRIPT_VERSION}.run \
    && ./SDRplay_RSP_API-Linux-${SDRPLAY_INSTALL_SCRIPT_VERSION}.run --noexec --target /tmp/sdrplay \
    && cd sdrplay \
    && sed -i 's/while true; do/while false; do/' install_lib.sh \
    && sed -i 's/sudo //' install_lib.sh \
    && apt-get install -y libudev1 libudev-dev libusb-1.0.0 libusb-dev \
    && mkdir -p /etc/udev/rules.d \
    && ./install_lib.sh

# SoapySDR
RUN cd /tmp/SoapySDR \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j4 \
    && make install \
    && ldconfig

# SoapySDRPlay
RUN cd /tmp/SoapySDRPlay \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install

# SoapyRemote
RUN cd /tmp/SoapyRemote \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install

# CubicSDR
RUN cd /tmp/CubicSDR \
    && mkdir build \
    && cd build \
    && cmake ../ -DCMAKE_BUILD_TYPE=Release -DwxWidgets_CONFIG_EXECUTABLE=~/Develop/wxWidgets-staticlib/bin/wx-config \
    && make \
    && make install \
    && rm -R ~/Develop

# GNU Radio dependencies
RUN apt-get -y install git cmake g++ python-dev swig  \
    pkg-config libfftw3-dev libboost-all-dev libcppunit-dev libgsl-dev \
    libusb-dev libsdl1.2-dev python-wxgtk3.0 python-numpy python-cheetah \
    python-lxml doxygen libxi-dev python-sip libqt4-opengl-dev libqwt-dev \
    libfontconfig1-dev libxrender-dev python-sip python-sip-dev python-qt4 \
    python-sphinx libusb-1.0-0-dev libcomedi-dev libzmq3-dev python-mako \
    python-gtk2

# GNU Radio
RUN cd /tmp \
    && git clone --recursive http://gnuradio.org/git/gnuradio.git

RUN apt-get install -y python3-pip libgmp-dev liblog4cpp5v5 liblog4cpp5-dev python-yaml liborc-0.4-0 liborc-0.4-dev \
    && pip3 install mako pyyaml lxml \
    && cd gnuradio \
    && mkdir build \
    && cd build \
    && cmake ../ \
    && make

RUN cd /tmp/gnuradio/build \
    && ctest -V \
    && make test \
    && make install

# GR OsmoSDR
RUN cd /tmp \
    && ls -alh /usr/local/bin \
    && git clone git://git.osmocom.org/gr-osmosdr.git \
    && cd gr-osmosdr \
    && mkdir build \
    && cd build/ \
    && cmake -DENABLE_NONFREE=TRUE ../ \
    && make \
    && make install \
    && ldconfig