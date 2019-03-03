# STAGE 1: build ROSE
FROM ubuntu:xenial as build

# install build dependencies
RUN apt-get update && apt-get install -y gcc-4.9 g++-4.9 gfortran-4.9 make wget tar lbzip2 git autoconf automake libtool flex bison lsb-release texlive doxygen && rm -rf /var/lib/apt/lists/*

# use gcc 4.9
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 100
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 100
RUN update-alternatives --install /usr/bin/gfortran gfortran /usr/bin/gfortran-4.9 100

# fetch boost source
WORKDIR /usr/src
RUN wget -O boost-1.61.0.tar.bz2 http://sourceforge.net/projects/boost/files/boost/1.61.0/boost_1_61_0.tar.bz2/download \
	&& tar xf boost-1.61.0.tar.bz2 \
	&& rm -f boost-1.61.0.tar.bz2

# build boost
WORKDIR /usr/src/boost_1_61_0
RUN ./bootstrap.sh --prefix=/usr/rose --with-libraries=chrono,date_time,filesystem,iostreams,program_options,random,regex,serialization,signals,system,thread,wave || cat ./bootstrap.log
RUN ./b2 -sNO_BZIP2=1 install

# add JDK which is required for ROSE building
ADD jdk/ /opt/jdk

# prepare ROSE source code
WORKDIR /usr/src
RUN git clone https://github.com/rose-compiler/rose-develop
RUN cd rose-develop && ./build

# build ROSE
WORKDIR /usr/src/rose-build
RUN CXXFLAGS='-g -rdynamic -Wall -Wno-unused-local-typedefs -Wno-attributes' ../rose-develop/configure --enable-assertion-behavior=abort --prefix=/usr/rose --with-CFLAGS=-fPIC --with-CXXFLAGS=-fPIC --with-C_OPTIMIZE=-O0 --with-CXX_OPTIMIZE=-O0 --with-C_DEBUG='-g -rdynamic' --with-CXX_DEBUG='-g -rdynamic' --with-C_WARNINGS='-Wall -Wno-unused-local-typedefs -Wno-attributes' --with-CXX_WARNINGS='-Wall -Wno-unused-local-typedefs -Wno-attributes' --with-ROSE_LONG_MAKE_CHECK_RULE=yes --with-boost=/usr/rose --with-gfortran=/usr/bin/gfortran-4.9 --enable-languages=c,c++,fortran --with-java=/opt/jdk --enable-projects-directory --with-doxygen --without-sqlite3 --without-libreadline --without-magic --without-yaml --with-dlib='/home/demo/opt/dlib/18.18' --without-wt --without-yices --without-pch --enable-rosehpct --without-haskell --enable-edg_version=4.12
# feel free to change the -j value
RUN make core -j4
RUN make install-core -j4

# strip symbols from the binaries to reduce size
RUN apt-get update && apt-get install -y binutils && rm -rf /var/lib/apt/lists/*
RUN strip /usr/rose/bin/* /usr/rose/lib/* || true

# STAGE 2: build the image
FROM ubuntu:xenial as rose

# copy installed ROSE
COPY --from=build /usr/rose /usr/rose

# add configuration of ld
ADD ld.so.conf /etc/

# add JRE
ADD jre/ /usr/jre

# setup PATH
ENV PATH="/usr/rose/bin:/usr/jre/bin:$PATH"

# apply ld configuration
RUN ldconfig

# add other packages
RUN apt-get update
RUN apt-get install -y gcc-4.9 g++-4.9 gfortran-4.9
