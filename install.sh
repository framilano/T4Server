#!/bin/bash
clear

# Colors Section
YELLOW='\033[1;33m'
GREY='\033[1;37m'
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'


# Function Progress
Spinner (){ 
pid=$!
spin='-\|/'
i=0
while kill -0 $pid 2>/dev/null
do
  i=$(( (i+1) %4 ))
  printf "\r [${spin:$i:1}] $1"
  sleep .1
done
printf "\r [${GREEN}\xE2\x9C\x94${NC}] $1 \n"
}

# Home Section
logo(){
printf "${RED}

 888888ba  dP            dP                     oo                        dP        oo                               dP     dP                      dP   oo                   
 88     8b 88            88                                               88                                         88     88                      88                        
 a88aaaa8P 88 dP    dP d8888P .d8888b. 88d888b. dP dP    dP 88d8b.d8b.    88        dP 88d888b. dP    dP dP.  .dP    88aaaaa88a .d8888b. .d8888b. d8888P dP 88d888b. .d8888b. 
 88        88 88    88   88   88'   88 88    88 88 88    88 88' 88' 88    88        88 88'   88 88    88   8bd8      88     88  88'   88 Y8ooooo.   88   88 88'   88 88'   88 
 88        88 88.  .88   88   88.  .88 88    88 88 88.  .88 88  88  88    88        88 88    88 88.  .88  .d88b.     88     88  88.  .88       88   88   88 88    88 88.  .88 
 dP        dP  88888P    dP    88888P  dP    dP dP  88888P  dP  dP  dP    88888888P dP dP    dP  88888P  dP    dP    dP     dP   88888P'  88888P'   dP   dP dP    dP  8888P88 
                                                                                                                                                                          .88 
                                                                                                                                                                      d8888P
                                                                                                                                                                                                                                                                                                                                          
 ${NC}                                                                                        
╔══════════════════════════════╗
║         Made by ${BLUE}fra98_${NC}       ║
║    Forked from ${PURPLE}Sterbweise${NC}    ║
╚══════════════════════════════╝
"
}

logo

echo "Let's update your system first..."
sudo apt update && sudo apt upgrade -y
sleep 3

# Choices Section
mfirewall='Do you want install UFW firewall to allow traffic on this server? (Y/n) ?'
printf "${YELLOW}${mfirewall}${NC}\n"
read -p '>>> ' firewall

echo "Enter the port you want to allow for this specific server (0 if you don't want to set this)"
read -p 'Port Number: ' port

echo "Do you want to enable traffic on HTTP port 8000? (Y/n)"
echo "(This setting it's only useful to set-up FastDL if you need to host modded maps or mods)"
read -p '>>> ' httpcheck

mupdater='Do you need to download the plutonium-updater? (Y/n) ?'
printf "${YELLOW}${mupdater}${NC}\n"
read -p '>>> ' updater

mwine='Do you need to install wine dependencies? (Y/n) ?'
printf "${YELLOW}${mwine}${NC}\n"
read -p '>>> ' winecheck

miw4admin='Do you need to install IW4MAdmin dependencies? (Y/n) ?'
printf "${YELLOW}${miw4admin}${NC}\n"
read -p '>>> ' iw4admin

stty igncr

clear

# Setup Firewall
if [ "$firewall" = 'y' ] || [ "$firewall" = '' ] || [ "$firewall" = 'Y' ] ; then
  mfirewall2='Firewall installation and ssh port opening.' 
  {
    sudo apt install ufw fail2ban -y && \
    sudo ufw allow 22/tcp && \
    sudo ufw default allow outgoing && \
    sudo ufw default deny incoming && \
    sudo ufw -f enable
    
    #Checking if the chosen server port is available
    if [ $port -eq 0 ]; then
      echo "Skipping server port configuration..."
    else
      sudo ufw allow $port && \
      if [ $? -eq 0 ]; then
          echo "The port $port has been opened"
          sudo ufw reload
          if [ $? -eq 0 ]; then
              echo "The firewall has reloaded"
          else
              echo "[Error] The firewall could not be reloaded"
          fi
      else
          echo "[Error] The port could not be opened"
      fi
    fi
    
    #Checking if the chosen http port is available
    if [ "$httpcheck" = 'y' ] || [ "$httpcheck" = '' ] || [ "$httpcheck" = 'Y' ] ; then
      sudo ufw allow 8000/tcp && \
      if [ $? -eq 0 ]; then
          echo "The port 8000/tcp has been opened"
          sudo ufw reload
          if [ $? -eq 0 ]; then
              echo "The firewall has reloaded"
          else
              echo "[Error] The firewall could not be reloaded"
          fi
      else
          echo "[Error] The port could not be opened"
      fi
    else
      echo "Skipping HTTP port configuration..."
    fi
  }
fi

# Installing Wine
if [ $winecheck == 'y' ] || [ $winecheck == '' ] || [ $winecheck == 'Y' ] ; then
  mwine2='Installing Wine'
  {
    #Enabling 32bit packages
    sudo dpkg --add-architecture i386
    sudo apt-get install wget gnupg2 software-properties-common apt-transport-https curl -y
    
    #Installing wine
    sudo mkdir -pm755 /etc/apt/keyrings
    sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
    sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
    
    sudo apt update -y
    sudo apt install --install-recommends winehq-staging -y
    sudo apt install winetricks -y

    # Add Variables to the environment at the end of ~/.bashrc
    echo -e 'export WINEPREFIX=~/.wine\nexport WINEDEBUG=fixme-all\nexport WINEARCH=win64' >> ~/.bashrc
    echo -e 'export DISPLAY=:0' >> ~/.bashrc
    source ~/.bashrc
    winecfg
  }
fi

if [ "$updater" = 'y' ] || [ "$updater" = '' ] || [ "$updater" = 'Y' ] ; then
  mupdater2='Downloading plutonium-updater by mxve'
  {
      # Download plutonium-updater
      cd Plutonium/
      wget https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
      tar xfv plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
      rm plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
      sudo chmod +x plutonium-updater

      # Make executable script
      sudo chmod +x T4_mp_server.sh
      sudo chmod +x T4_zm_server.sh
      sudo chmod +x T5_mp_server.sh
      sudo chmod +x T5_zm_server.sh

  }
fi

if [ "$iw4admin" = 'y' ] || [ "$iw4admin" = '' ] || [ "$iw4admin" = 'Y' ] ; then
  miw4admin2='Downloading IW4MAdmin dependencies'
  {
    sudo apt-get update && \
    sudo apt-get install -y aspnetcore-runtime-6.0
  }
fi

mfinish='Installation finished.'
mquit='ENTER to quit.'
printf "\n${GREEN}${mfinish}${NC}\n"
printf "\n${mquit}"
stty -igncr
read
exit
