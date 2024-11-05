#!/bin/bash

# Update and install dependencies
apt-get update && apt-get -y install \
    autoconf automake build-essential gfortran git python2.7 python-dev python3-dev latex2html \
    libcfitsio-bin libcfitsio-dev libfftw3-bin libfftw3-dev libglib2.0-dev libpng-dev libtool \
    libx11-dev pgplot5 tcsh libbz2-dev python-tk wget && \
    apt-get clean all && \
    rm -r /var/lib/apt/lists/*

# Set environment variables
export PGPLOT_DIR=/usr/local/pgplot
export PGPLOT_DEV=/Xserve
export PRESTO=/home/soft/presto
export LD_LIBRARY_PATH=/home/soft/presto/lib

# Install Python packages for both Python 2 and 3
cd /home/soft/presto
python imagebuild/get-pip2.py && python3 imagebuild/get-pip.py

pip2 install numpy minio pyfits fitsio matplotlib scipy astropy future
pip3 install numpy minio matplotlib scipy astropy pymongo boto3 future

# Clean previous builds and build libpresto
cd /home/soft/presto/src
make cleaner
make libpresto

# Install Python package and modify shebangs for Python3 compatibility
cd /home/soft/presto
pip3 install /home/soft/presto
sed -i 's/env python/env python3/' /home/soft/presto/bin/*py
python3 tests/test_presto_python.py

# Install psrcat
cd /home/soft
wget https://www.atnf.csiro.au/research/pulsar/psrcat/downloads/psrcat_pkg.tar.gz
tar -xzf psrcat_pkg.tar.gz && rm psrcat_pkg.tar.gz
cd psrcat_tar && bash makeit
cp psrcat /usr/bin
export PSRCAT_FILE=/home/soft/psrcat_tar/psrcat.db

# Install tempo from local source
cp -r /path/to/imagebuild/tempo /home/soft/tempo
cd /home/soft/tempo
./prepare && ./configure && make && make install
export TEMPO=/home/soft/tempo

# Build Presto binaries
cd /home/soft/presto/src
make makewisdom
make clean
make binaries

# Add Presto binaries to PATH
export PATH="/home/soft/presto/bin/:${PATH}"
