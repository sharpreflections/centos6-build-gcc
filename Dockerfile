FROM sharpreflections/centos6-build-binutils
LABEL maintainer="dennis.brendel@sharpreflections.com"

ARG gmp=gmp-4.3.2
ARG mpfr=mpfr-2.4.2
ARG mpc=mpc-1.0.1
ARG isl=isl-0.14.1
ARG cloog=cloog-0.18.4
ARG gcc=gcc-5.5.0

ARG prefix=/opt

WORKDIR /build/

# This is very slow, but should work always
#RUN svn co svn://gcc.gnu.org/svn/gcc/tags/gcc_4_8_5_release gcc && \
# Instead of manually downloading the dependencies, there is a script in contrib/ that does that, too. It uses hard
# coded urls but we use gnu.org's ftp (behind a load balancer) which I think is better
RUN echo "Downloading $gcc:   " && curl --remote-name --progress-bar https://ftp.gnu.org/gnu/gcc/$gcc/$gcc.tar.xz  && \
    echo "Downloading $gmp:   " && curl --remote-name --progress-bar https://ftp.gnu.org/gnu/gmp/$gmp.tar.bz2      && \
    echo "Downloading $mpfr:  " && curl --remote-name --progress-bar https://ftp.gnu.org/gnu/mpfr/$mpfr.tar.xz     && \
    echo "Downloading $mpc:   " && curl --remote-name --progress-bar https://ftp.gnu.org/gnu/mpc/$mpc.tar.gz       && \
    echo "Downloading $isl:   " && curl --remote-name --progress-bar http://isl.gforge.inria.fr/$isl.tar.xz        && \
    # see https://repo.or.cz/w/cloog.git
    echo "Downloading $cloog: " && curl --remote-name --progress-bar http://www.bastoul.net/cloog/pages/download/$cloog.tar.gz && \
    echo -n "Extracting $gcc..   " && tar xf $gcc.tar.xz   && echo " done" && \
    echo -n "Extracting $gmp..   " && tar xf $gmp.tar.bz2  && mv $gmp   $gcc/gmp   && echo " done" && \
    echo -n "Extracting $mpfr..  " && tar xf $mpfr.tar.xz  && mv $mpfr  $gcc/mpfr  && echo " done" && \
    echo -n "Extracting $mpc..   " && tar xf $mpc.tar.gz   && mv $mpc   $gcc/mpc   && echo " done" && \
    echo -n "Extracting $isl..   " && tar xf $isl.tar.xz   && mv $isl   $gcc/isl   && echo " done" && \
    echo -n "Extracting $cloog.. " && tar xf $cloog.tar.gz && mv $cloog $gcc/cloog && echo " done" && \
    mkdir build && cd build && \
    ../$gcc/configure --prefix=$prefix/$gcc \
                      --disable-multilib \
                      --enable-languages=c,c++,fortran && \
    make --quiet --jobs=$(nproc --all) && \
    make install && \
    rm -rf /build/*

