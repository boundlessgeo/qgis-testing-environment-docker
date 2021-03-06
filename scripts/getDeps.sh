#!/bin/bash
# Accepts:
# $1 branch
# $2 legacy ("true"|"false")

set -e
apt-get -y update
apt-get install -y software-properties-common
add-apt-repository ppa:ubuntugis/ubuntugis-unstable
apt-get -y update

if [ "$2"  = "true" ]; then
    # Deps for < master (Py2/Qt4)
    LC_ALL=C DEBIAN_FRONTEND=noninteractive  \
        apt-get install -y git cmake flex bison build-essential \
        gdal-bin git graphviz grass-dev libexpat1-dev libfcgi-dev libgdal-dev \
        libgeos-dev libgsl0-dev libopenscenegraph-dev libosgearth-dev libpq-dev \
        libproj-dev libqca2-dev libqca2-plugin-ossl libqjson-dev libqscintilla2-dev \
        libqt4-dev libqt4-opengl-dev libqt4-sql-sqlite libqtwebkit-dev libqwt5-qt4-dev \
        libspatialindex-dev libspatialite-dev libsqlite3-dev lighttpd locales \
        pkg-config poppler-utils pyqt4-dev-tools python-all python-all-dev python-gdal \
        python-mock python-nose2 python-psycopg2 python-pyspatialite python-qscintilla2 \
        python-qt4 python-qt4-dev python-qt4-sql python-sip python-sip-dev python-yaml \
        qt4-dev-tools spawn-fcgi txt2tags xauth xfonts-100dpi xfonts-75dpi \
        xfonts-base xfonts-scalable xvfb vim supervisor expect-dev python-setuptools \
        python-dev

        easy_install --upgrade pip
        pip install -r /usr/local/requirements.txt
        pip install subprocess32 # This is for 2.7 only

        chmod -R a+w /usr/lib/x86_64-linux-gnu/qt4/plugins/designer/
        chmod -R a+w /usr/lib/python2.7/dist-packages/PyQt4/uic/widget-plugins


else
    # Deps for master (Py3/Qt5)
    LC_ALL=C DEBIAN_FRONTEND=noninteractive  \
        apt-get install -y git cmake flex bison libproj-dev libgeos-dev libgdal1-dev \
        libexpat1-dev libfcgi-dev libgsl0-dev libpq-dev libqca2-dev libqca2-plugin-ossl \
        pyqt5-dev qttools5-dev qtpositioning5-dev libqt5svg5-dev libqt5webkit5-dev \
        python3-pyqt5.qtwebkit python3-pyqt5.qtsvg qt5keychain-dev \
        libqt5gui5 libqt5scripttools5 qtscript5-dev libqca-qt5-2-dev grass-dev \
        libgeos-dev libgdal-dev libqt5xmlpatterns5-dev libqt5scintilla2-dev python3-gdal python3-yaml \
        pyqt5.qsci-dev python3-pyqt5.qsci libgsl-dev txt2tags libproj-dev libqwt-qt5-dev \
        libspatialindex-dev pyqt5-dev-tools qttools5-dev-tools qt5-default python3-future \
        python3-pyqt5.qtsql python3-psycopg2 lighttpd locales pkg-config poppler-utils python3-dev \
        python3-pyqt5 pyqt5.qsci-dev python3-pyqt5.qtsql spawn-fcgi xauth xfonts-100dpi \
        xfonts-75dpi xfonts-base xfonts-scalable xvfb vim supervisor expect python3-setuptools \
        python3-dev python3-owslib libzip-dev

        easy_install3 --upgrade pip

        pip3 install -r /usr/local/requirements.txt

        chmod -R a+w /usr/lib/x86_64-linux-gnu/qt5/plugins/designer/
        chmod -R a+w /usr/lib/python3/dist-packages/PyQt5/uic/widget-plugins/

fi


# 2.18, we want the OAuth2 plugin
if [[ "$1" == *"2_18"* ]]; then
    LC_ALL=C DEBIAN_FRONTEND=noninteractive  \
        apt-get install -y libqtkeychain0 qtkeychain-dev wget unzip
    wget "https://github.com/MonsantoCo/o2/archive/o2-monsanto-features.tar.gz"
    pushd .
    tar -xzf o2-monsanto-features.tar.gz
    rm o2-monsanto-features.tar.gz
    cd o2-o2-monsanto-features
    mkdir build
    cd build
    cmake -DBUILD_SHARED_LIBS=ON -Do2_WITH_QT5=OFF ..
    make -j4 install
    popd
    rm -rf o2-o2-monsanto-features
fi
