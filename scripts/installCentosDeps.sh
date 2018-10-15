#!/usr/bin/env bash

# set -e

SCRIPT=$(pwd)/$0
FILENAME=$(basename $SCRIPT)
PATHNAME=$(dirname $SCRIPT)
ROOT=$PATHNAME/..
BUILD_DIR=$ROOT/build
CURRENT_DIR=$(pwd)
NVM_CHECK="$PATHNAME"/checkNvm.sh

LIB_DIR=$BUILD_DIR/libdeps
PREFIX_DIR=$LIB_DIR/build/

parse_arguments() {
    while [ "$1" != "" ]; do
        case $1 in
        "--cleanup")
            CLEANUP=true
            ;;
        esac
        shift
    done
}

cleanup() {
    if [ -d $LIB_DIR ]; then
        rm -rf $LIB_DIR/*
    fi
}

parse_arguments $*

if [ "$CLEANUP" = "true" ]; then
    echo "Cleaning up..."
    cleanup
    exit 0
fi

mkdir -p $PREFIX_DIR
sudo yum install -y -q centos-release-scl
sudo yum install -y -q devtoolset-7 yasm
source /opt/rh/devtoolset-7/enable
export PKG_CONFIG_PATH="$PREFIX_DIR/lib/pkgconfig"

. "$PATHNAME"/common.sh

check_proxy() {
    if [ -z "$http_proxy" ]; then
        echo "No http proxy set, doing nothing"
    else
        echo "http proxy configured, configuring npm"
        npm config set proxy $http_proxy
    fi

    if [ -z "$https_proxy" ]; then
        echo "No https proxy set, doing nothing"
    else
        echo "https proxy configured, configuring npm"
        npm config set https-proxy $https_proxy
    fi
}

install_nvm_node() {
    export NVM_DIR=$(readlink -f "$LIB_DIR/nvm")
    if [ ! -s "$NVM_DIR/nvm.sh" ]; then
        git clone https://github.com/creationix/nvm.git "$NVM_DIR"
        cd "$NVM_DIR"
        git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" origin)
        cd "$CURRENT_DIR"
    fi
    . $NVM_CHECK
    nvm install
}

install_yum_deps() {
    install_nvm_node
    nvm use
    npm install
    npm install -g node-gyp --registry=https://registry.npm.taobao.org
    npm install gulp@3.9.1 gulp-eslint@3 run-sequence@2.2.1 webpack-stream@4.0.0 google-closure-compiler-js@20170521.0.0 del@3.0.0 gulp-sourcemaps@2.6.4 script-loader@0.7.2 expose-loader@0.7.5 --registry=https://registry.npm.taobao.org
    sudo yum install -y -q git make cmake glib2-devel pkgconfig boost-devel rabbitmq-server mongodb-server mongodb curl log4cxx-devel gnutls-devel bzip2

    sudo chown -R $(whoami) ~/.npm
}

install_openssl() {
    inst $LIB_DIR https://github.com/openssl/openssl OpenSSL_1_0_2p "./config --prefix=$PREFIX_DIR" --openssldir=$PREFIX_DIR -fPIC shared
}

install_libnice() {
    sudo yum install -y -q gtk-doc
    inst $LIB_DIR https://github.com/libnice/libnice git ./autogen.sh --prefix="$PREFIX_DIR"
}

function nasm_inst() {
    dlrepo https://www.nasm.us/nasm.repo
    sudo yum -y install nasm
    rmrepo nasm.repo
}

install_mediadeps() {
    sudo yum -y -q install git autoconf automake gettext make libtool mercurial pkgconfig patch libXext-devel glibc libstdc++ zlib
    #for x264
    nasm_inst
    inst $LIB_DIR https://github.com/chriskohlhoff/asio git "cd asio \&\& ./autogen.sh \&\& ./configure --prefix=$PREFIX_DIR" --without-boost
    exit
    #inst $LIB_DIR https://github.com/madler/zlib git ./configure --prefix="$PREFIX_DIR"
    inst $LIB_DIR https://github.com/webmproject/libvpx git ./configure --prefix="$PREFIX_DIR" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm
    inst $LIB_DIR https://github.com/mirror/x264 git ./configure --prefix="$PREFIX_DIR" --enable-shared
    inst $LIB_DIR https://github.com/xiph/opus git ./configure --prefix="$PREFIX_DIR"
    inst $LIB_DIR https://github.com/FFmpeg/FFmpeg git "./configure --prefix=$PREFIX_DIR --enable-hardcoded-tables --extra-cflags=-I$PREFIX_DIR/include --extra-ldflags=-L$PREFIX_DIR/lib --extra-libs=-lpthread --extra-libs=-lm --enable-gpl --enable-nonfree --enable-openssl --enable-libopus --enable-libx264 --enable-libvpx --disable-debug --enable-gpl --enable-nonfree --enable-shared --disable-static"
}

install_libsrtp() {
    inst $LIB_DIR https://github.com/cisco/libsrtp git ./configure --enable-openssl --prefix=$PREFIX_DIR --with-openssl-dir=$PREFIX_DIR
}


echo '--------------install_yum_deps------------------'
install_yum_deps
echo '----------------check_proxy---------------------'
check_proxy
echo '---------------install_openssl------------------'
install_openssl
echo '---------------install_libsrtp------------------'
install_libsrtp
echo '---------------install_libnice------------------'
install_libnice
echo '---------------install_mediadeps------------------'
install_mediadeps
