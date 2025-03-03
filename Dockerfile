# einsteintoolkit
FROM ubuntu:22.04
LABEL maintainer="Zhen Zhong <auroradysis@gmail.com>"

# Install necessary Ubuntu packages
RUN apt-get update &&                                   \
    apt-get install -y                                  \
    curl git perl python3 subversion wget               \
    build-essential g++ gcc gfortran make pkg-config    \
    gsl-bin libgsl0-dev                                 \
    h5utils hdf5-helpers hdf5-tools libhdf5-openmpi-dev \
    hwloc-nox libhwloc-dev libnuma-dev                  \
    libfftw3-bin libfftw3-dev libfftw3-mpi-dev          \
    libjpeg-dev                                         \
    libltdl-dev                                         \
    libudev-dev                                         \
    libopenblas-dev                                     \
    libopenmpi-dev openmpi-bin                          \
    libpapi-dev papi-tools                              \
    libssl-dev                                          \
    petsc-dev                                           \
    zlib1g zlib1g-dev

# Download installer
RUN curl -L https://raw.githubusercontent.com/gridaphobe/CRL/ET_2022_11/GetComponents -o /tmp/GetComponents
RUN curl -L https://bitbucket.org/einsteintoolkit/manifest/raw/ET_2022_11/einsteintoolkit.th -o /tmp/einsteintoolkit.th
RUN chmod a+rx /tmp/GetComponents &&            \
    chmod a+r /tmp/einsteintoolkit.th

# Configure the machine
RUN useradd -m scientist
USER scientist
WORKDIR /home/scientist
RUN git config --global user.email "scientist@localhost" &&             \
    git config --global user.name "Scientist, Einstein Toolkit" &&      \
    echo 'einsteintoolkit' >"$HOME/.hostname"

# Download the Einstein Toolkit
RUN mkdir Cactus simulations &&                                 \
    /tmp/GetComponents --parallel /tmp/einsteintoolkit.th
WORKDIR /home/scientist/Cactus
# TODO: Move these into the Einstein Toolkit
COPY /einsteintoolkit.ini simfactory/mdb/machines/
COPY /einsteintoolkit.cfg simfactory/mdb/optionlists/
COPY /einsteintoolkit.sub simfactory/mdb/submitscripts/
COPY /einsteintoolkit.run simfactory/mdb/runscripts/
# Configure Simfactory
COPY /defs.local.ini simfactory/etc/

# Build
RUN ./simfactory/bin/sim build -j4

# Export source and simulation directories
VOLUME /home/scientist/Cactus /home/scientist/simulations

# Run Simfactory by default
# Hint: Use "execute" to execute arbitrary shell commands
CMD ["/bin/bash"]
