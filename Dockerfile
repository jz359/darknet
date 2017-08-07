FROM ubuntu:14.04

WORKDIR /darknetyolo

COPY cfg /darknetyolo/cfg/
COPY data /darknetyolo/data/
COPY examples /darknetyolo/examples/
COPY include /darknetyolo/include/
COPY obj /darknetyolo/obj/
COPY python /darknetyolo/python/
COPY scripts /darknetyolo/scripts/
COPY src /darknetyolo/src/

ADD ./darknet /darknetyolo
ADD ./libdarknet.a /darknetyolo
ADD ./libdarknet.so /darknetyolo
ADD ./yolo.weights /darknetyolo
ADD ./testcv2.py /darknetyolo

RUN ls

#necessary for dependencies
EXPOSE 80

#Install OpenCV
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise multiverse\n\
deb-src http://us.archive.ubuntu.com/ubuntu/ precise multiverse\n\
deb http://us.archive.ubuntu.com/ubuntu/ precise-updates multiverse\n\
deb-src http://us.archive.ubuntu.com/ubuntu/ precise-updates multiverse\n"\
>> /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
curl \
cmake \
wget \
unzip \
libopencv-dev \
build-essential \
git \
libgtk2.0-dev \
pkg-config \
python-dev \
python-numpy \
libdc1394-22 \
libdc1394-22-dev \
libjpeg-dev \
libpng12-dev \
libtiff4-dev \
libjasper-dev \
libavcodec-dev \
libavformat-dev \
libswscale-dev \
libxine-dev \
libgstreamer0.10-dev \
libgstreamer-plugins-base0.10-dev \
libv4l-dev \
libtbb-dev \
libqt4-dev \
libfaac-dev \
libmp3lame-dev \
libopencore-amrnb-dev \
libopencore-amrwb-dev \
libtheora-dev \
libvorbis-dev \
libxvidcore-dev \
x264 \
v4l-utils

RUN mkdir opencv
WORKDIR opencv

RUN wget https://github.com/Itseez/opencv/archive/2.4.8.zip -O opencv-2.4.8.zip
RUN unzip opencv-2.4.8.zip
RUN mkdir opencv-2.4.8/build
WORKDIR opencv-2.4.8/build

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D WITH_OPENGL=ON ..

RUN make -j $(nproc) && make install
RUN echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf
RUN ldconfig

#Test OpenCV installation
WORKDIR /darknetyolo
RUN pwd
RUN ls
RUN python ./testcv2.py

#install OpenCV and dependencies for mxnet
RUN apt-get update && apt-get install -y \
    python-setuptools \
    python-pip \
    make \
    cmake \
    libopenblas-dev \
    liblapack-dev \
    libgtk-3-dev \
    libboost-all-dev

RUN pip install --upgrade pip
RUN pip install --upgrade -r requirements.txt

WORKDIR /darknetyolo
#should be at directory containing mxnet and everything else
RUN pwd
RUN ls

#add detect.py
ADD ./main.sh /darknetyolo
ADD ./vid2frames.py /darknetyolo

#run the detection script
#will automatically look for videos in /data/yolo_movies/
CMD ["bash", "./main.sh"]
