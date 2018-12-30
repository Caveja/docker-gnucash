FROM ubuntu:latest

RUN apt-get update &&\
    apt-get -y install git\
        build-essential \
        cmake \
        ninja-build \
        swig \
        libwebkit2gtk-4.0-dev \
        libgtest-dev \
        libblkid-dev \
        e2fslibs-dev \
        libboost-all-dev \
        libaudit-dev \
        libxslt1-dev \
        libgwenhywfar60-dev \
        guile-2.0-dev \
        && \
    apt clean && \
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
