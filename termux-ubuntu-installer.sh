apt update && apt upgrade -y
apt install git wget proot -y
git clone https://github.com/Neo-Oli/termux-ubuntu.git
cd termux-ubuntu
chmod +x ubuntu.sh
./ubuntu.sh

# Run ubuntu
./start-ubuntu.sh

#To Run again just give command cd termux-ubuntu && ./start-ubuntu.sh

