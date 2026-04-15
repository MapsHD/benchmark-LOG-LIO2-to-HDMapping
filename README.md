# [LOG-LIO2](https://github.com/tiev-tongji/LOG-LIO2) converter to [HDMapping](https://github.com/MapsHD/HDMapping)

## Intended use

This small toolset allows to integrate the SLAM solution provided by [LOG-LIO2](https://github.com/tiev-tongji/LOG-LIO2) with [HDMapping](https://github.com/MapsHD/HDMapping).
This repository contains a ROS 1 workspace that:
  - submodule to tested revision of LOG-LIO2
  - a converter that listens to topics advertised from the odometry node and saves data in a format compatible with HDMapping.

## Example datasets

- [Bunker DVI Dataset](https://charleshamesse.github.io/bunker-dvi-dataset/) — `reg-1.bag` (Livox MID-360). LOG-LIO2 is FAST-LIO2-derived and supports Livox; a MID-360 config has to be adapted (copy e.g. `newer_college.yaml`, switch preprocess to `lid_type: 1` Livox).
- [KITTI raw/odometry](https://www.cvlibs.net/datasets/kitti/) — converted `.bag` (`/velodyne_points`, `/kitti/oxts/imu`). Use a Velodyne config (`newer_college.yaml` base) with 64 scan lines.

Upstream ships configs for M2DGR, Newer College, VIRAL.

## Published topics (from LOG-LIO2)

- `/cloud_registered`      — `sensor_msgs/PointCloud2`, per-scan registered cloud in world frame
- `/cloud_registered_body` — `sensor_msgs/PointCloud2`, per-scan cloud in body frame
- `/Odometry`              — `nav_msgs/Odometry`
- `/path`                  — `nav_msgs/Path`
- `/Laser_map`             — global map

The converter only consumes `/cloud_registered` and `/Odometry`.

## Dependencies

```shell
sudo apt install -y nlohmann-json3-dev
```

## Building

Clone the repo:
```shell
mkdir -p /test_ws/src
cd /test_ws/src
git clone https://github.com/MapsHD/benchmark-log-lio2-to-HDMapping.git --recursive
cd ..
catkin_make
```

## Usage — running SLAM:

In a first terminal start LOG-LIO2:
```shell
cd /test_ws/
source ./devel/setup.sh
roslaunch log_lio2 mapping_newer_college.launch   # or mapping_m2dgr / mapping_viral
```

In a second terminal record converter-relevant topics:
```shell
rosbag record /cloud_registered /Odometry -O recorded.bag
```

In a third terminal replay the raw data (adjust topics to your dataset):
```shell
rosbag play <raw>.bag --clock
```

## Usage — conversion (recorded bag → HDMapping session):

```shell
cd /test_ws/
source ./devel/setup.sh
rosrun log-lio2-to-hdmapping listener <recorded.bag> <output_dir>
```

Output: `scan_lio_*.laz`, `trajectory_lio_*.csv`, `lio_initial_poses.reg`, `poses.reg`, `session.json` — directly loadable in HDMapping.
