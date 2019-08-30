FROM ubuntu:19.04

########################
# Install what we need
########################

# install generic tools
RUN apt-get update \
    && apt-get upgrade -y --allow-unauthenticated \
    && apt-get install -y --allow-unauthenticated \
		git \
		python3.7 \
		python3.7-dev \
		python3-pip \
        gcc-8=8.3.0-6ubuntu1 \
        g++-8=8.3.0-6ubuntu1 \
        gdb=8.2.91.20190405-0ubuntu3 \
        cmake \
        clang-format-8 \
		wget \
		tar \
	&& rm -rf /var/lib/apt/lists/*

# install python modules
RUN pip3 install \
		cmake-format==0.5.4 \
	&& rm /root/.cache/pip -rf

RUN GCC=/usr/bin/x86_64-linux-gnu- GCC_SUFFIX=-8 CC=${GCC}gcc${GCC_SUFFIX} CXX=${GCC}g++${GCC_SUFFIX} AR=${GCC}gcc-ar${GCC_SUFFIX} RANLIB=${GCC}gcc-ranlib${GCC_SUFFIX}; \
    cd /tmp/ \
    && wget https://github.com/protocolbuffers/protobuf/releases/download/v3.9.1/protobuf-all-3.9.1.tar.gz \
    && tar -xf /tmp/protobuf-all-3.9.1.tar.gz -C /tmp \
    && mkdir -p /tmp/protobuf-3.9.1/build/debug \
    && cmake -S /tmp/protobuf-3.9.1/cmake -B /tmp/protobuf-3.9.1/build/debug -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_BUILD_PROTOC_BINARIES=OFF -DCMAKE_BUILD_TYPE=Debug -DCMAKE_DEBUG_POSTFIX=-debug -DCMAKE_C_COMPILER=${CC} -DCMAKE_C_COMPILER_AR=${AR} -DCMAKE_C_COMPILER_RANLIB=${RANLIB} -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_CXX_COMPILER_AR=${AR} -DCMAKE_CXX_COMPILER_RANLIB=${RANLIB} && make -C /tmp/protobuf-3.9.1/build/debug all -j4 && make -C /tmp/protobuf-3.9.1/build/debug install -j4  \
    && cp /usr/local/lib/cmake/protobuf/protobuf-targets-debug.cmake /tmp/protobuf-targets-debug.cmake \
    && mkdir -p /tmp/protobuf-3.9.1/build/release \
    && cmake -S /tmp/protobuf-3.9.1/cmake -B /tmp/protobuf-3.9.1/build/release -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=${CC} -DCMAKE_C_COMPILER_AR=${AR} -DCMAKE_C_COMPILER_RANLIB=${RANLIB} -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_CXX_COMPILER_AR=${AR} -DCMAKE_CXX_COMPILER_RANLIB=${RANLIB} && make -C /tmp/protobuf-3.9.1/build/release all -j4 && make -C /tmp/protobuf-3.9.1/build/release install -j4  \
    && cp /tmp/protobuf-targets-debug.cmake /usr/local/lib/cmake/protobuf/protobuf-targets-debug.cmake \
	&& rm -rf /tmp/protobuf*
