#!/bin/bash

# See:
# https://github.com/fluxcapacitor/pipeline/wiki/AWS-GPU-TensorFlow-Docker

# CUDA drivers and toolkit

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y wget
sudo apt-get install -y linux-headers-$(uname -r)
sudo apt-get install -y gcc
sudo apt-get install -y make
sudo apt-get install -y g++
wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
sudo apt-get update
sudo apt-get install -y cuda
export PATH=$PATH:/usr/local/cuda/bin

# verify installation

echo '---> testing...'
nvidia-smi
nvcc --version
sudo modprobe nvidia
cd /usr/local/cuda/samples/1_Utilities/deviceQuery
sudo make
./deviceQuery
cd 

# set up Docker

sudo apt-get update
sudo curl -fsSL https://get.docker.com/ | sh
sudo curl -fsSL https://get.docker.com/gpg | sudo apt-key add -

# set up NVidia Docker instance

wget -P /tmp https://github.com/NVIDIA/nvidia-docker/releases/download/v1.0.1/nvidia-docker_1.0.1-1_amd64.deb
sudo dpkg -i /tmp/nvidia-docker*.deb && rm /tmp/nvidia-docker*.deb

# test NVidia SMI

sudo nvidia-docker run --rm nvidia/cuda nvidia-smi

# download Docker image with TF examples

sudo docker pull fluxcapacitor/gpu-tensorflow-spark:master

sudo nvidia-docker run -itd --name=gpu-tensorflow-spark -p 80:80 -p 50070:50070 -p 39000:39000 -p 9000:9000 -p 9001:9001 -p 9002:9002 -p 9003:9003 -p 9004:9004 -p 6006:6006 -p 8754:8754 -p 7077:7077 -p 6066:6066 -p 6060:6060 -p 6061:6061 -p 4040:4040 -p 4041:4041 -p 4042:4042 -p 4043:4043 -p 4044:4044 -p 2222:2222 -p 5050:5050 fluxcapacitor/gpu-tensorflow-spark:master

# verify successful set-up

sudo nvidia-docker exec -it gpu-tensorflow-spark bash
nvidia-smi

# run tensorboard in the background

tensorboard --logdir /root/train &

# install jupyter and keras

sudo apt-get update
sudo apt-get -y install python-pip
sudo apt-get -y install ipython ipython-notebook
pip install --upgrade pip
sudo pip install jupyter
sudo pip install tensorflow
sudo pip install tensorflow-gpu
sudo pip install keras

# if error, try:
# sudo pip install keras==1.2.2

# clone git repo

sudo apt-get install git
git clone https://github.com/box121209/cc-domain-graph
cd cc-domain-graph
jupyter notebook &

