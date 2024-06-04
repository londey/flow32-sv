FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Set the timezone to UTC by default
RUN ln -fs /usr/share/zoneinfo/UTC /etc/localtime

# Install dependencies
RUN apt-get update && apt-get install -y \
    bison \
    build-essential \
    clang \
    cmake \
    flex \
    gawk \
    git \
    graphviz \
    iverilog \
    libboost-dev \
    libboost-filesystem-dev \
    libboost-iostreams-dev \
    libboost-program-options-dev \
    libboost-python-dev \
    libboost-system-dev \
    libboost-thread-dev \
    libeigen3-dev \
    libffi-dev \
    libftdi-dev \
    libreadline-dev \
    mercurial \
    pkg-config \
    python3 \
    python3-dev \
    qtcreator qtbase5-dev qt5-qmake \
    tcl-dev \
    verilator \
    xdot \
    zlib1g-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Icestorm tools (Yosys, nextpnr, Icestorm)
RUN git clone https://github.com/cliffordwolf/icestorm.git /icestorm && \
    cd /icestorm && \
    make -j$(nproc) && \
    make install

RUN git clone --branch yosys-0.42 --recurse-submodules https://github.com/YosysHQ/yosys.git /yosys && \
    cd /yosys && \
    make -j$(nproc) && \
    make install


RUN git clone --recurse-submodules https://github.com/YosysHQ/nextpnr.git /nextpnr && \
    cd /nextpnr && \
    cmake -DARCH=ice40 -DBUILD_GUI=ON . && \
    make -j$(nproc) && \
    make install

# Install Verilog simulator (Icarus Verilog)
RUN apt-get install -y iverilog

RUN git clone https://github.com/tinyvision-ai-inc/uf2-utils.git && \
    cd uf2-utils && \
    make install

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory
WORKDIR /workspace
