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




d888888P dP   dP    .d88888b                                                  dP                     dP            dP dP                   
   88    88   88    88.    \"'                                                 88                     88            88 88                   
   88    88aaa88    \`Y88888b. .d8888b. 88d888b. dP   .dP .d8888b. 88d888b.    88 88d888b. .d8888b. d8888P .d8888b. 88 88 .d8888b. 88d888b. 
   88         88          \`8b 88ooood8 88'  \`88 88   d8\' 88ooood8 88\'  \`88    88 88\'  \`88 Y8ooooo.   88   88\'  \`88 88 88 88ooood8 88'  \`88 
   88         88    d8\'   .8P 88.  ... 88       88 .88\'  88.  ... 88          88 88    88       88   88   88.  .88 88 88 88.  ... 88       
   dP         dP     Y88888P  \`88888P\' dP       8888P\'   \`88888P\' dP          dP dP    dP \`88888P\'   dP   \`88888P8 dP dP \`88888P\' dP       
                                                                                                                                           
                                                                                                                                           
                                                                                           
                                                                                           
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
mfirewall='Do you want install UFW firewall (Y/n) ?'
printf "${YELLOW}${mfirewall}${NC}\n"
read -p '>>> ' firewall

mupdater='Do you need to download the plutonium-updater? (Y/n) ?'
printf "${YELLOW}${mupdater}${NC}\n"
read -p '>>> ' updater

mtorrent='Do you need to download T4 game files (Y/n) ?'
printf "${YELLOW}${mtorrent}${NC}\n"
read -p '>>> ' torrent

mwine='Do you need to install wine dependecies? (Y/n) ?'
printf "${YELLOW}${mwine}${NC}\n"
read -p '>>> ' winecheck

mdotnet='Do you want install Dotnet [Required for IW4Madmin] (Y/n) ?'
printf "${YELLOW}${mdotnet}${NC}\n"
read -p '>>> ' dotnet
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
  } > /dev/null 2>&1 &
  Spinner "${mfirewall2}"
fi

# Enable 32 bit packages
mbit='Enabling 32-bit packages'
{
  sudo dpkg --add-architecture i386 && \
  sudo apt-get install wget gnupg2 software-properties-common apt-transport-https curl transmission-cli -y
} > /dev/null 2>&1 &
Spinner "${mbit}"

# Installing Wine
if [ $winecheck == 'y' ] || [ $winecheck == '' ] || [ $winecheck == 'Y' ] ; then
  mwine2='Installing Wine'
  {
    wget -nc https://dl.winehq.org/wine-builds/winehq.key
    sudo apt-key add winehq.key
    sudo apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/' -y
    rm winehq.key
    sudo apt update -y
    sudo apt install --install-recommends winehq-staging -y
    sudo apt install winetricks -y

    # Add Variables to the environment at the end of ~/.bashrc
    echo -e 'export WINEPREFIX=~/.wine\nexport WINEDEBUG=fixme-all\nexport WINEARCH=win64' >> ~/.bashrc
    echo -e 'export DISPLAY=:0' >> ~/.bashrc
    source ~/.bashrc
    winecfg
  } > /dev/null 2>&1 &
  Spinner "${mwine2}"
fi

# Dotnet Installation
if [ $dotnet == 'y' ] || [ $dotnet == '' ] || [ $dotnet == 'Y' ] ; then
  mdotnet2='Installing Dotnet'
  {
    #Dotnet Package
    wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb

    #Install the SDK
    apt-get install -y dotnet-sdk-3.1
    apt-get install -y dotnet-sdk-6.0

    #Install the runtime
    apt-get install -y aspnetcore-runtime-3.1
	  apt-get install -y aspnetcore-runtime-6.0
  } #> /dev/null 2>&1 &
  Spinner "${mdotnet2}"
fi

if [ "$updater" = 'y' ] || [ "$updater" = '' ] || [ "$updater" = 'Y' ] ; then
  mupdater2='Installing plutonium-updater'
  {
      # Download plutonium-updater
      cd Plutonium/
      wget https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
      tar xfv plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
      rm plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
      sudo chmod +x plutonium-updater

      # Make executable script
      #chmod +x Plutonium/T4Server.sh
      sudo chmod +x T4_mp_server.sh
      sudo chmod +x T4_zm_server.sh

  } > /dev/null 2>&1 &
  Spinner "${mupdater2}"
fi


if [ "$torrent" = 'y' ] || [ "$torrent" = '' ] || [ "$torrent" = 'Y' ] ; then
  mbinary='Game Binary Installation (wait for torrent to end).'
  {
      # Download plutonium-updater
      cd Plutonium/
      wget https://github.com/mxve/plutonium-updater.rs/releases/latest/download/plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
      tar xfv plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
      rm plutonium-updater-x86_64-unknown-linux-gnu.tar.gz
      sudo chmod +x plutonium-updater

      # Make executable script
      #chmod +x Plutonium/T4Server.sh
      sudo chmod +x T4_mp_server.sh
      sudo chmod +x T4_zm_server.sh
      
      # Download Game File
      cd ..
      wget https://plutonium.pw/pluto_t4_full_game.torrent
      tmpfile=$(mktemp)
      chmod a+x $tmpfile
      echo "killall transmission-cli" > $tmpfile
      transmission-cli --download-dir ./ pluto_t4_full_game.torrent

      # Clean Installation
      rm pluto_t4_full_game.torrent
      cp -r pluto_t4_full_game/* T4Gamefiles/
      rm -rf pluto_t4_full_game
  } #> /dev/null 2>&1 &
  Spinner "${mbinary}"
fi

mfinish='Installation finished.'
mquit='ENTER to quit.'
printf "\n${GREEN}${mfinish}${NC}\n"
printf "\n${mquit}"
stty -igncr
read
exit