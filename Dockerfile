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
    python3-dev \
    libpython3-dev \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN wget -q https://github.com/PDAL/PDAL/releases/download/2.8.2/PDAL-2.8.2-src.tar.bz2
RUN tar -xf PDAL-2.8.2-src.tar.bz2
RUN mkdir PDAL-2.8.2-src/build
WORKDIR /src/PDAL-2.8.2-src/build
RUN cmake .. -DBUILD_PLUGIN_PYTHON=ON -DPYTHON_EXECUTABLE=$(which python3)
RUN make -j
RUN make install
RUN ldconfig

WORKDIR /src
RUN wget -q https://github.com/LAStools/LAStools/archive/refs/tags/v2.0.3.tar.gz
RUN tar -xf v2.0.3.tar.gz
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
RUN pip install --break-system-packages \
    pdal-plugins

WORKDIR /app
COPY . .

ENTRYPOINT [ "/app/entrypoint.sh" ]