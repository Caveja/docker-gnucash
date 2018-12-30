FROM ubuntu:bionic

RUN git clone https://github.com/google/googletest.git &&\
    git clone https://github.com/Gnucash/gnucash.git

RUN apt-get update &&\
    apt-get -y install git\
        build-essential \
        cmake \
        ninja-build \
        swig \
        e2fslibs-dev \
        libaqbanking-dev \
        libaudit-dev \
        libblkid-dev \
        libboost-all-dev \
        libgtest-dev \
        libgwengui-gtk3-dev \
        libgwenhywfar60-dev \
        libofx-dev \
        libwebkit2gtk-4.0-dev \
        libxslt1-dev \
        guile-2.0-dev \
        xsltproc \
        && \
    apt clean && \
    rm -r /var/lib/apt/lists/*

RUN cd googletest &&\
    git pull &&\
    cd googletest &&\
    mkdir mybuild &&\
    cd mybuild &&\
    cmake -DBUILD_GMOCK=ON ../ &&\
    make

RUN cd gnucash &&\
    git pull &&\
    cd .. &&\
    mkdir build-gnucash &&\
    cd build-gnucash &&\
    export GTEST_ROOT=/googletest/googletest &&\
    export GMOCK_ROOT=/googletest/googlemock &&\
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr/local ../gnucash &&\
    ninja &&\
    ninja install &&\
    cd .. && rm -rf gnucash build-gnucash
