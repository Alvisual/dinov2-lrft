### to verify your gpu is cuda enable check
lspci | grep -i nvidia

### If you have previous installation remove it first. 
sudo apt purge nvidia* -y
sudo apt remove nvidia-* -y
sudo rm -rf /etc/apt/sources.list.d/cuda*
sudo apt autoremove -y && sudo apt autoclean -y
sudo rm -rf /usr/local/cuda*

# system update
sudo apt update && sudo apt upgrade -y
sudo reboot now

# install other import packages
sudo apt install g++ freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev -y

# first get the PPA repository driver
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update

# find recommended driver versions for you
sudo apt install ubuntu-drivers-common -y
ubuntu-drivers devices

# install nvidia driver with dependencies (recommended)
sudo apt install libnvidia-common-560 libnvidia-gl-560 nvidia-driver-560 -y

# reboot
sudo reboot now

# verify that the following command works
nvidia-smi

sudo wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub
sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /"

# Update and upgrade (optional, not required)
# sudo apt update && sudo apt upgrade -y
# sudo apt --fix-broken install

# Install cuda 11.8
sudo apt update && sudo apt install cuda-11-8 -y

# setup your paths
echo 'export PATH=/usr/local/cuda-11.8/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

cd ~ && wget https://developer.download.nvidia.com/compute/cudnn/9.3.0/local_installers/cudnn-local-repo-ubuntu2204-9.3.0_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2204-9.3.0_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-ubuntu2204-9.3.0/cudnn-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update -y
sudo apt-get -y install cudnn-cuda-11

# Test cudnn and see its version
sudo apt install libcudnn9-samples -y
sudo apt install libfreeimage3 libfreeimage-dev -y
cd /usr/src/cudnn_samples_v9/mnistCUDNN && sudo make clean && sudo make
./mnistCUDNN

# Install pyenv
sudo apt update
sudo apt install make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'alias python3=python' >> ~/.bashrc
pyenv install 3.11.9
pyenv global 3.11.9

# https://github.com/git-lfs/git-lfs?tab=readme-ov-file#from-binary
cd ~ && wget https://github.com/git-lfs/git-lfs/releases/download/v3.5.1/git-lfs-linux-amd64-v3.5.1.tar.gz
tar -xvzf git-lfs-linux-amd64-v3.5.1.tar.gz
sudo ./git-lfs-3.5.1/install.sh

mkdir -p ssl_project && cd ~/ssl_project
git clone https://github.com/Alvisual/datasets-trichotrack.git
cd datasets-trichotrack && git lfs install

cd ~/ssl_project && git clone https://github.com/Alvisual/dinov2-lrft.git
cd dinov2-lrft
git lfs install
# git remote add root https://github.com/facebookresearch/dinov2.git
# git fetch root
# git checkout -b root root/main
git checkout dev
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

rm cudnn*
rm -rf git-lfs*
