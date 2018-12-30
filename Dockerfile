FROM ubuntu:bionic

RUN apt-get update &&\
    apt-get -y install git &&\
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

RUN apt-get update &&\
    apt-get -y install \
        build-essential \
        cmake \
        ninja-build \
        swig \
        e2fslibs-dev \
        libaqbanking-dev \
        libaudit-dev \
        libblkid-dev \
        libboost-all-dev \
        libdbi-dev \
        libgtest-dev \
        libgwengui-gtk3-dev \
        libgwenhywfar60-dev \
        libofx-dev \
        libwebkit2gtk-4.0-dev \
        libxml2-utils \
        libxslt1-dev \
        guile-2.0-dev \
        xsltproc \
        && \
    apt-get clean && \
    rm -r /var/lib/apt/lists/*


RUN git clone https://github.com/google/googletest.git &&\
    cd googletest &&\
    mkdir mybuild &&\
    cd mybuild &&\
    cmake -DBUILD_GMOCK=ON ../ &&\
    make

RUN git clone https://github.com/Gnucash/gnucash.git &&\
    mkdir build-gnucash &&\
    cd build-gnucash &&\
    export GTEST_ROOT=/googletest/googletest &&\
    export GMOCK_ROOT=/googletest/googlemock &&\
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr/local ../gnucash &&\
    ninja &&\
    ninja install &&\
    cd .. && rm -rf gnucash build-gnucash
