

<img src="https://pbs.twimg.com/profile_images/993278064883851265/QrvMbLC7_400x400.jpg" alt="plutonium" width="75"/> <img src="https://user-images.githubusercontent.com/28491164/204064220-d6c47ae9-ef1e-4a17-9b62-f084dc386416.png" alt="ubuntu" width="75"/> 

# Server Installer for Linux

Simple installation and configuration of a T4/T5 server on linux, this repo only provides instructions for T4/T5, but it's easily adjustable for T6 and other Plutonium supported games. This installer assumes you're using Ubuntu, but you can easily use it with every distro, you just need to change the dependencies links in `install.sh`. I actually use this on an Amazon AWS EC2 instance.
Forked and based on [T5Server](https://github.com/Sterbweise/T5Server)

## Synopsis
In this guide we'll cover the following topics:
- Scripts usage, `install.sh` and `T4/5_**_server.sh`. The first one starts the configuration process (dependencies and firewall ports set-up), the second one starts the actual server using Wine.
- Manual variables changing, depending on your needs (ports, IPs, folders).
- Setting up FastDL for easier custom maps support on your server

## Requirements
+ Ubuntu >22.04
+ 10GB dedicated for this server.
+ Root permissions.
+ T4-WaW/T5-BO1 gamefiles, you can easily find them on your own. 

[I highly recommend removing unnecessary game files on T4](https://plutonium.pw/docs/server/t4/setting-up-a-server/#4-optional-slimming-down-server-directory)
[I highly recommend removing unnecessary game files on T5](https://plutonium.pw/docs/server/t5/setting-up-a-server/#4-optional-slimming-down-server-directory)

## Instructions
1. Clone the repository wherever you need to: 
```shell 
git clone https://github.com/framilano/T4Server.git
```
2. Move to `PlutoniumLinuxServer` folder.
```shell
cd T4Server/
```
3. Run the Installation Script `install.sh` .
```shell
./install.sh
```

You'll be asked to type your OS root password, follow the instructions and you can choose to install:
- UFW firewall for port forwarding. You'll be asked to choose which port to open for this Server and if you want to allow port 8000 for an HTTP Server (aka FastDL support on your Server)
- Crossplatform [plutonium-updater](https://github.com/mxve/plutonium-updater.rs) by mxve.
- Wine dependencies.

These steps are necessary, but it allows the user to choose if they need them during configuration or they can provide their own versions (like using Wine Stable instead of Wine Staging).

### I highly suggest to restart your VM/Container/OS after completing the installation, just to be sure that every env variable has been set correctly.

## Configuration
*Assuming you're configuring a T4 Server*
1. Copy your game files in `/T4Server/T4Gamefiles`, if asked merge the `main` folder with the already existing one.
2. Move to `/T4Server/T4Gamefiles/main` Folder.
3. Edit `dedicated_zm.cfg` or `dedicated_mp.cfg` according to your needs (change map rotation, [enable FastDL](https://plutonium.pw/docs/server/t4/fastdl/)).
4. Move to `/T4Server/Plutonium` Folder.
5. Edit `T4_**_server.sh` with your informations. Specify `/Plutonium` and `/T4Gamefiles` directories with their full paths, type your Server Key.

## Launch Server
1. Move to `/T4Server/Plutonium` Folder.
2. Launch Server. 
```shell
./T4_**_server.sh
```

It will update first your Plutonium files using `plutonium-updater`.

### [Optional] FastDL support 
For FastDL to work you need an HTTP Server serving your mods files. You can easily set up an http server with a single python module line:
```shell
python3 -m http.server --directory /home/ubuntu/T4Server/Plutonium/storage/t4/
```
We're setting the HTTP Server to only serve files in `/home/ubuntu/T4Server/Plutonium/storage/t4/` you should type here the path to your `mods` directory, the default port is 8000.
In this guide I assume that both HTTP and Plutonium Servers are on the same machine, but that's not required.

To easily start all the components and scripts I need at startup here's how I configured my crontab file:
```shell
#Dynamically updates the IP address for the HTTP Server
@reboot sed -i "/set sv_wwwBaseURL/c\set sv_wwwBaseURL \"http://$(curl ifconfig.me):8000\"" "/home/ubuntu/T4Server/T4Gamefiles/main/dedicated_zm.cfg"

#Start HTTP Server for FastDL
@reboot (python3 -m http.server --directory /home/ubuntu/T4Server/Plutonium/storage/t4/) &

#Start Plutonium Server
@reboot (cd /home/ubuntu/T4Server/Plutonium && ./T4_zm_server.sh) &

#Start IW4MAdmin
@reboot ((sleep 60) && (cd /home/ubuntu/IW4MAdmin && ./StartIW4MAdmin.sh)) &
```

The first command is only useful if your VM/OS changes its public IP address every time you turn it ON, for instance, AWS EC2 instances. 
With the `sed` utility I replace the `set sv_wwwBaseURL` line value in `dedicated_zm.cfg` with my current public IP address.
The fourth command just starts [IW4MAdmin](https://github.com/RaidMax/IW4M-Admin).

## Usage Report
- Removing the unnecessary game files, with default maps and a single custom map on a *AWS EC2 t3a.micro Ubuntu instance*, the occupied storage is around **9GB**.
- While the Server is running, the HTTP Server is working for FastDL and one player has joined the lobby, the average memory consumption is **620MB**.

## Issues
### Wine display errors
   + You shouldn't care about these errors, Plutonium servers don't have any graphical support.

### Unable to load import '_BinkWaitStopAsyncThread@4' from module 'binkw32.dll'
   + Check your PAT variable in `T4_**_server.sh`. (It will be ping binkw32.dll dir)
   + Make sure to your user can read the file in all sub-dir of T4Server.

### Server doesn't appear in Plutonium Servers List
   + Check if your server port is open with UDP protocol. (Example: 28961)

### Connection with nix socket lost
   + Check your plutonium key validity
   + Check if your plutonium key are correctly write in `T4_**_server.sh`

### [DW][Auth] Handling authentication request
   + Check your plutonium key validity
   + Check if your plutonium key are correctly write in T4_**_server.sh

## Source
• [Plutonium](https://plutonium.pw) <br>
• [Minami original topic](https://forum.plutonium.pw/topic/23683/guide-debian-t5-server-on-linux-vps-dedicated-server) <br>
• [Plutonium-Updater by mxve](https://github.com/mxve/plutonium-updater.rs)
