FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies to build HE libraries
RUN apt-get update
RUN apt-get install -y cmake make g++ javacc m4 libfftw3-dev git build-essential

# Install tfhe
RUN git clone https://github.com/tfhe/tfhe.git
WORKDIR tfhe
RUN mkdir build && \
    cd build && \
    cmake ../src -DENABLE_FFTW=off -DENABLE_SPQLIOS_FMA=on && \
    make -j && \
    make install
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH


# Copy files to docker container
WORKDIR /
COPY . .

