FROM ubuntu:20.04

ENV MY_INSTALL_DIR /usr/local/

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential autoconf libtool pkg-config wget git ca-certificates\
       apt-transport-https curl gnupg \
    && curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > bazel.gpg \
    && mv bazel.gpg /etc/apt/trusted.gpg.d/ \
    && echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
    && apt-get update \
    && apt-get -y install bazel \
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
      ../.. 
RUN cd && cd grpc && make -j
RUN cd && cd grpc && make install 

#RUN cd grpc \
 #   && bazel build:all
