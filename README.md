# [LOG-LIO2](https://github.com/tiev-tongji/LOG-LIO2) converter to [HDMapping](https://github.com/MapsHD/HDMapping)

## Hint

Please change branch to [Bunker-DVI-Dataset-reg-1](https://github.com/MapsHD/benchmark-LOG-LIO2-to-HDMapping/tree/Bunker-DVI-Dataset-reg-1) or [kitti](https://github.com/MapsHD/benchmark-LOG-LIO2-to-HDMapping/tree/kitti) for quick experiment.

## Intended use

This small toolset allows to integrate SLAM solution provided by [LOG-LIO2](https://github.com/tiev-tongji/LOG-LIO2) with [HDMapping](https://github.com/MapsHD/HDMapping).
This repository contains ROS 1 workspace that :
  - submodule to tested revision of LOG-LIO2
  - a converter that listens to topics advertised from odometry node and save data in format compatible with HDMapping.

## Dependencies

```shell
sudo apt install -y nlohmann-json3-dev
```

## Building

Clone the repo
```shell
mkdir -p /test_ws/src
cd /test_ws/src
git clone https://github.com/MapsHD/benchmark-LOG-LIO2-to-HDMapping.git --recursive
cd ..
catkin_make
```

## Usage - data SLAM:

Prepare recorded bag with estimated odometry:

In first terminal record bag:
```shell
rosbag record /cloud_registered /Odometry
```

and start odometry:
```shell
cd /test_ws/
source ./devel/setup.sh # adjust to used shell
roslaunch log_lio mapping_mid360.launch     # or mapping_kitti.launch
rosbag play *.bag --clock
```

## Usage - conversion:

```shell
cd /test_ws/
source ./devel/setup.sh # adjust to used shell
rosrun log-lio2-to-hdmapping listener <recorded_bag> <output_dir>
```

## Record the bag file:

```shell
rosbag record /cloud_registered /Odometry
```

## LOG-LIO2 Launch:

```shell
cd /test_ws/
source ./install/setup.sh # adjust to used shell
roslaunch log_lio mapping_mid360.launch     # or mapping_kitti.launch
```

## During the record (if you want to stop recording earlier) / after finishing the bag:

```shell
In the terminal where the ros record is, interrupt the recording by CTRL+C
Do it also in ros launch terminal by CTRL+C.
```

## Usage - Conversion (ROS bag to HDMapping, after recording stops):

```shell
cd /test_ws/
source ./install/setup.sh # adjust to used shell
rosrun log-lio2-to-hdmapping listener <recorded_bag> <output_dir>
```
