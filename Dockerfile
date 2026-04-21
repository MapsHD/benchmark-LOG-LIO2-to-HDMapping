FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

# Workaround: fuse-overlayfs corrupts GPG signatures during layer extraction
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl gnupg2 lsb-release software-properties-common \
    build-essential git cmake \
    python3-pip python3-dev \
    libeigen3-dev \
    libpcl-dev \
    nlohmann-json3-dev \
    tmux \
    wget \
    unzip \
    libusb-1.0-0-dev \
    libboost-all-dev \
    libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
    -o /usr/share/keyrings/ros-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros/ubuntu $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/ros1.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-desktop-full \
    python3-rosdep \
    python3-catkin-tools \
    ros-noetic-geometry-msgs \
    ros-noetic-sensor-msgs \
    ros-noetic-std-msgs \
    ros-noetic-nav-msgs \
    ros-noetic-message-generation \
    ros-noetic-message-runtime \
    ros-noetic-catkin \
    ros-noetic-tf \
    ros-noetic-pcl-ros \
    ros-noetic-cv-bridge \
    libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN git clone https://github.com/Livox-SDK/Livox-SDK.git && \
    cd Livox-SDK && \
    rm -rf build && mkdir build && cd build && \
    cmake .. && make -j$(nproc) && make install

WORKDIR /ros_ws

COPY ./src ./src

# Fix LOG-LIO2 hardcoded OpenCV paths — let cmake find system OpenCV
RUN sed -i '/Set(OpenCV_DIR/d' /ros_ws/src/LOG-LIO2/CMakeLists.txt && \
    sed -i 's/find_package(OpenCV 3.2 QUIET)/find_package(OpenCV REQUIRED)/' /ros_ws/src/LOG-LIO2/CMakeLists.txt && \
    sed -i 's|#  livox_ros_driver|  livox_ros_driver|' /ros_ws/src/LOG-LIO2/CMakeLists.txt

# Build workspace
RUN source /opt/ros/noetic/setup.bash && \
    catkin_make

ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID ros && \
    useradd -m -u $UID -g $GID -s /bin/bash ros

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc && \
    echo "source /ros_ws/devel/setup.bash" >> ~/.bashrc

CMD ["bash"]
