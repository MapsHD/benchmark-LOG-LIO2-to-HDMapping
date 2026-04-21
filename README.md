# LOG-LIO2 to HDMapping simlified instruction

## Step 1 (prepare data)
Download the dataset `kitti_seq00_ros1.bag` by clicking [link](https://huggingface.co/datasets/kubchud/kitti_to_ros/resolve/main/kitti_seq00_ros1.bag) (it is part of [kitti_seq](https://github.com/Jakubach/kitti_to_ros)).

### Extract the dataset

File `kitti_seq00_ros1.bag` is an input for further calculations.
It should be located in `~/hdmapping-benchmark/data`.

## Step 2 (prepare docker)
```shell
mkdir -p ~/hdmapping-benchmark
cd ~/hdmapping-benchmark
git clone https://github.com/MapsHD/benchmark-LOG-LIO2-to-HDMapping.git --recursive
cd benchmark-LOG-LIO2-to-HDMapping
git checkout kitti
docker build -t log-lio2_noetic .
```

## Step 3 (run docker, file 'kitti_seq00_ros1.bag' should be in '~/hdmapping-benchmark/data')
```shell
cd ~/hdmapping-benchmark/benchmark-LOG-LIO2-to-HDMapping
chmod +x docker_session_run-ros1-log-lio2.sh
cd ~/hdmapping-benchmark/data
~/hdmapping-benchmark/benchmark-LOG-LIO2-to-HDMapping/docker_session_run-ros1-log-lio2.sh kitti_seq00_ros1.bag .
```

## Step 4 (Open and visualize data)
Expected data should appear in ~/hdmapping-benchmark/data/output_hdmapping-log-lio2
Use tool [multi_view_tls_registration_step_2](https://github.com/MapsHD/HDMapping) to open session.json from ~/hdmapping-benchmark/data/output_hdmapping-log-lio2.

You should see following data in '~/hdmapping-benchmark/data/output_hdmapping-log-lio2'

lio_initial_poses.reg

poses.reg

scan_lio_*.laz

session.json

trajectory_lio_*.csv

## Contact email
januszbedkowski@gmail.com
