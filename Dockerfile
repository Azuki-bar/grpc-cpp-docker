FROM ubuntu:20.04

env MY_INSTALL_DIR /usr/local/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential autoconf libtool pkg-config wget git ca-certificates\
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O cmake-linux.sh https://github.com/Kitware/CMake/releases/download/v3.19.6/cmake-3.19.6-Linux-x86_64.sh 
RUN chmod +x cmake-linux.sh 
RUN   ./cmake-linux.sh -- --skip-license --prefix=$MY_INSTALL_DIR 

RUN git clone --recurse-submodules -b v1.41.0 https://github.com/grpc/grpc

RUN  cd grpc \
&& mkdir -p cmake/build \
&& cd cmake/build \
&& cmake -DgRPC_INSTALL=ON \
     -DgRPC_BUILD_TESTS=OFF \
     -DCMAKE_INSTALL_PREFIX=$MY_INSTALL_DIR \
     ../.. \
&& make -j \
&& make install 


