FROM ubuntu:24.04

# install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    wget \
    gdal-bin \
    libgdal-dev \
    python3 \
    python3-pip \
    libjpeg62 \
    liblaszip8 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN wget https://github.com/PDAL/PDAL/releases/download/2.8.1/PDAL-2.8.1-src.tar.bz2
RUN tar -xvf PDAL-2.8.1-src.tar.bz2
RUN mkdir PDAL-2.8.1-src/build
WORKDIR /src/PDAL-2.8.1-src/build
RUN cmake ..
RUN make -j
RUN make install
RUN ldconfig

WORKDIR /src
RUN wget https://github.com/LAStools/LAStools/archive/refs/tags/v2.0.3.tar.gz
RUN tar -xvf v2.0.3.tar.gz
RUN mkdir LAStools-2.0.3/build
WORKDIR /src/LAStools-2.0.3
RUN cmake -DCMAKE_BUILD_TYPE=Release CMakeLists.txt
RUN cmake --build .
RUN install bin64/* /usr/local/bin
RUN ldconfig


# install python packages
RUN pip install --break-system-packages \
    laspy[laszip]
RUN pip install --break-system-packages \
    py3dtiles[ply,las]

WORKDIR /app
COPY . .

ENTRYPOINT [ "/app/entrypoint.sh" ]