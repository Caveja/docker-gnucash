FROM ubuntu:bionic

RUN apt-get update &&\
    apt-get -y install git &&\
    apt-get clean && \
    rm -r /var/lib/apt/lists/*

RUN git clone https://github.com/google/googletest.git &&\
    git clone https://github.com/Gnucash/gnucash.git

RUN apt-get update &&\
    apt-get -y install \
        build-essential \
        cmake \
        ninja-build \
        swig \
        e2fslibs-dev \
        dbus-x11 \
        libaqbanking-dev \
        libaudit-dev \
        libblkid-dev \
        libboost-all-dev \
        libdbd-mysql \
        libdbd-pgsql \
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


RUN cd googletest &&\
    git pull &&\
    mkdir mybuild &&\
    cd mybuild &&\
    cmake -DBUILD_GMOCK=ON ../ &&\
    make

RUN cd gnucash &&\
    git fetch &&\
    git checkout 3.4 &&\
    git reset --hard &&\
    git clean -fd &&\
    cd .. &&\
    mkdir build-gnucash &&\
    cd build-gnucash &&\
    export GTEST_ROOT=/googletest/googletest &&\
    export GMOCK_ROOT=/googletest/googlemock &&\
    cmake -GNinja -DCMAKE_INSTALL_PREFIX=/usr ../gnucash &&\
    ninja &&\
    ninja install &&\
    cd .. && rm -rf gnucash build-gnucash

ENTRYPOINT ["/usr/bin/gnucash", "--logto", "stderr"]
