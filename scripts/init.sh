# To verify your gpu is cuda enable check.
lspci | grep -i nvidia

# If you have previous installation remove it first. 
sudo apt purge nvidia* -y
sudo apt remove nvidia-* -y
sudo rm -rf /etc/apt/sources.list.d/cuda*
sudo apt autoremove -y && sudo apt autoclean -y
sudo rm -rf /usr/local/cuda*

# System update.
sudo apt update && sudo apt upgrade -y
sudo reboot now

# Install other import packages.
sudo apt install g++ freeglut3-dev build-essential libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev -y

# First get the PPA repository driver.
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update

# Find recommended driver versions for you.
sudo apt install ubuntu-drivers-common -y
ubuntu-drivers devices

# Install nvidia driver with dependencies (recommended).
sudo apt install libnvidia-common-560 libnvidia-gl-560 nvidia-driver-560 -y

# Reboot.
sudo reboot now

# Verify that the following command works.
nvidia-smi

# Runfile to install cuda-11.8. Please note that we only select CUDA Toolkit 11.8 option and deselect all other options when running the runfile.
wget https://developer.download.nvidia.com/compute/cuda/11.8.0/local_installers/cuda_11.8.0_520.61.05_linux.run
sudo sh cuda_11.8.0_520.61.05_linux.run

###########
# # Another method to install cuda-11.8
# sudo wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
# sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
# sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/3bf863cc.pub
# sudo add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/ /"
#
# # Update and upgrade (optional, not required)
# # sudo apt update && sudo apt upgrade -y
# # sudo apt --fix-broken install
#
# # Install cuda 11.8
# sudo apt update && sudo apt install cuda-11-8 -y
###########


# Setup your paths.
echo 'export PATH=/usr/local/cuda-11.8/bin:$PATH' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda-11.8/lib64:$LD_LIBRARY_PATH' >> ~/.bashrc
source ~/.bashrc

# Install cudnn-9.3.0.
cd ~ && wget https://developer.download.nvidia.com/compute/cudnn/9.3.0/local_installers/cudnn-local-repo-ubuntu2204-9.3.0_1.0-1_amd64.deb
sudo dpkg -i cudnn-local-repo-ubuntu2204-9.3.0_1.0-1_amd64.deb
sudo cp /var/cudnn-local-repo-ubuntu2204-9.3.0/cudnn-*-keyring.gpg /usr/share/keyrings/
sudo apt update -y
sudo apt install cudnn-cuda-11 -y

# Test cudnn and see its version.
sudo apt install libcudnn9-samples -y
sudo apt install libfreeimage3 libfreeimage-dev -y
cd /usr/src/cudnn_samples_v9/mnistCUDNN && sudo make clean && sudo make
./mnistCUDNN

# Install pyenv.
sudo apt update
sudo apt install make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
echo 'alias python3=python' >> ~/.bashrc
source ~/.bashrc
pyenv install 3.11.9
pyenv global 3.11.9

# https://github.com/git-lfs/git-lfs?tab=readme-ov-file#from-binary.
cd ~ && wget https://github.com/git-lfs/git-lfs/releases/download/v3.5.1/git-lfs-linux-amd64-v3.5.1.tar.gz
tar -xvzf git-lfs-linux-amd64-v3.5.1.tar.gz
sudo ./git-lfs-3.5.1/install.sh

# Setup git config global.
git config --global user.name "your_user_name"
git config --global user.email "your_email@gmail.com"

# Clone datasets-trichotrack & dinov2-lrft repos and setup virtual env.
cd ~ && git clone https://github.com/Alvisual/datasets-trichotrack.git
cd datasets-trichotrack && git lfs install && git lfs pull
cd ~ && git clone https://github.com/Alvisual/dinov2-lrft.git
cd dinov2-lrft && git lfs install
git remote add root https://github.com/facebookresearch/dinov2.git
git fetch root
git checkout -b root root/main
git checkout dev
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt


# Declare more aliases.
cat <<EOL >> ~/.bashrc
alias gbranch="git branch -vv"
alias glog="git log --graph --color --abbrev-commit --pretty=format:'%C(bold red)%h%Creset -%C(auto)%d%Creset %s %C(bold green)(%cs) %C(bold blue)<%an>%Creset'"
alias gl="git log --pretty=oneline"
alias gclean="git fetch --prune && git gc"
alias gdbl="git branch -D"
alias gdbr="git push origin --delete"
alias gpnb="git push -u origin"
alias gdtl="git tag --delete"
alias gdtr="git push origin --delete"
alias gpnt="git push origin --tags"
alias plod="pip list --outdate"
alias pinstall="pip install -U"
alias pclean="pip cache purge && pip cache info"
EOL
source ~/.bashrc

# Remove all downloaded/extracted files/folders.
rm -rf cuda*
rm -rf cudnn*
rm -rf git-lfs*
