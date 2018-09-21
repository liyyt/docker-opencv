FROM python:2.7-alpine

LABEL maintainer="Jethro Hicks <jethro@hicksinspace.com>"

ENV OPENCV_VERSION=3.4.3
ENV CC /usr/bin/clang
ENV CXX /usr/bin/clang++

WORKDIR /opt

RUN apk add --update --no-cache --virtual .build-deps \
    build-base \
    unzip \
    wget \
    cmake \
    make \
    clang-dev \
    linux-headers \
  && apk add --no-cache \
    libjpeg  \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    libpng-dev \
    jasper-dev \
    tiff \
    tiff-dev \
    libwebp \
    libwebp-dev \
    openblas-dev \
  && pip install numpy \
  && wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
  && unzip ${OPENCV_VERSION}.zip \
  && mkdir -p /opt/opencv-${OPENCV_VERSION}/build \
  && cd /opt/opencv-${OPENCV_VERSION}/build \
  && cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_FFMPEG=NO \
    -D WITH_IPP=NO \
    -D WITH_OPENEXR=NO \
    -D WITH_TBB=YES \
    -D BUILD_EXAMPLES=NO \
    -D BUILD_ANDROID_EXAMPLES=NO \
    -D INSTALL_PYTHON_EXAMPLES=NO \
    -D BUILD_DOCS=NO \
    .. \
  && make VERBOSE=1 \
  && make \
  && make install \
  && apk del .build-deps \
  && rm -rf /opt/${OPENCV_VERSION}.zip \
  && rm -rf /opt/opencv-${OPENCV_VERSION}
