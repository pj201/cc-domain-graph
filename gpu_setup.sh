# EC2 GPU system prep for deep learning

# See:
# https://www.tensorflow.org/install/install_linux
#
# Choose Ubuntu 16.04 GPU p2.xlarge (Tesla K80)
# CUDA Toolkit 8.0
# cuDNN 7.0 (or 6.0 if find problems)
# Tensorflow, Keras, Jupyter
# Install with Virtualenv

# check GPU

lspci -nnk | grep -i nvidia

# install basics

sudo apt-get update
#sudo apt-get install libglu1-mesa libxi-dev libxmu-dev -y
#sudo apt-get — yes install build-essential
sudo apt-get install python-pip python-dev -y
sudo apt-get install python-numpy python-scipy -y
sudo apt-get install -y linux-headers-$(uname -r)
sudo apt-get install -y gcc
sudo apt-get install -y make
sudo apt-get install -y g++
sudo apt-get install git

# clone git repo

git clone https://github.com/box121209/cc-domain-graph

# CUDA drivers and toolkit
# see
# http://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html

mkdir packages
cd packages

wget https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
sudo dpkg -i cuda-repo-ubuntu1604-8-0-local-ga2_8.0.61-1_amd64-deb
sudo apt-get update
sudo apt-get install -y cuda
export PATH=$PATH:/usr/local/cuda-8.0/bin
export LD_LIBRARY_PATH=/usr/local/cuda-8.0/lib64\
                         ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# verify installation

nvidia-smi
nvcc --version
sudo modprobe nvidia
cd /usr/local/cuda/samples/1_Utilities/deviceQuery
sudo make
./deviceQuery
cd ~/packages

# install cuDNN
# See
# http://docs.nvidia.com/deeplearning/sdk/cudnn-install/index.html

cp ~/cc-domain-graph/lib/* .
sudo dpkg -i libcudnn7_7.0.2.38-1+cuda8.0_amd64.deb
sudo dpkg -i libcudnn7-dev_7.0.2.38-1+cuda8.0_ppc64el.deb
sudo dpkg -i libcudnn7-doc_7.0.2.38-1+cuda8.0_ppc64el.deb

# testing:
cp -r /usr/src/cudnn_samples_v7/ $HOME
cd $HOME/cudnn_samples_v7/mnistCUDNN
make clean &&& make
./mnistCUDNN


# install tensorflow using Virtualenv
# see
# https://www.tensorflow.org/install/install_linux#nvidia_requirements_to_run_tensorflow_with_gpu_support

cd $HOME/packages
sudo apt-get install libcupti-dev

sudo apt-get install python-pip python-dev python-virtualenv # for Python 2.7

mkdir ~/tensorflow
sudo virtualenv --system-site-packages ~/tensorflow # for Python 2.7

source ~/tensorflow/bin/activate

# EITHER

easy_install -U pip

# OR (if easy_install fails)

sudo pip install --upgrade tensorflow      # for Python 2.7
sudo pip install --upgrade tensorflow-gpu  # for Python 2.7 and GPU
sudo pip install --upgrade <tfBinaryURL>


# install jupyter and keras etc

sudo apt-get update
sudo apt-get -y install ipython ipython-notebook
sudo pip install --upgrade pip
sudo pip install jupyter
sudo pip install keras
sudo pip install boto

# configure Jupyter password

jupyter notebook --generate-config
jupyter notebook password

cd cc-domain-graph
jupyter notebook &

