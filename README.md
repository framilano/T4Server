

<img src="https://pbs.twimg.com/profile_images/993278064883851265/QrvMbLC7_400x400.jpg" alt="plutonium" width="75"/> <img src="https://user-images.githubusercontent.com/28491164/204064220-d6c47ae9-ef1e-4a17-9b62-f084dc386416.png" alt="ubuntu" width="75"/> <img src="https://i.imgur.com/ylf2Uzh.png" alt="ubuntu" width="200"/> 


# T4 Server Installer for Linux
Simple installation and configuration of a T4 server on linux. This installer assumes you're using Ubuntu, but you can easily use it with every distro, you just need to change the dependencies links in `install.sh`.

Forked and based on [T5Server](https://github.com/Sterbweise/T5Server)

## Requirements
+ Ubuntu >22.04
+ 10GB dedicated for this server
+ Root permissions
+ T4-WaW gamefiles, you can easily find them on your own

## Instructions
1. Clone the repository wherever you need to: 
```shell 
git clone https://github.com/framilano/T4Server.git
```
2. Move to `T4Server` folder.
```shell
cd T4Server/
```
3. Run the Installation Script `install.sh` .
```shell
./install.sh
```
You'll be asked to type your machine root password, follow the instructions and you can choose to install:
- UFW firewall for port forwarding.
- crossplatform [plutonium-updater](https://github.com/mxve/plutonium-updater.rs) by mxve.
- Wine dependencies.

These steps are necessary, but it allows the user to choose if they need them right now or they can provide their own versions (like using Wine Stable instead of Wine Staging)

## Configuration
1. Copy your game files in `/T4Server/T4Gamefiles`, if asked merge the `main` folder with already existing one.
2. Move to `/T4Server/T4Gamefiles/main` Folder.
3. Edit dedicated_zm.cfg or dedicated_mp.cfg according to your needs.
4. Move to `/T4Server/Plutonium` Folder.
5. Edit `T4_**_server.sh` with your informations. Specify Plutonium and T4Gamefiles directories with their full paths, type your Server Key.

3. Allow server port. Move to `/T4Server/Scripts/` and the run `allow_port.sh`
```shell
sudo ./allow_port.sh
```
You'll be asked to choose the Server port to open, by default `T4_**_server.sh` are set to use `28961`

## Launch Server
1. Move to `/T4Server/Plutonium` Folder.
2. Launch Server. 
```shell
./T4_**_server.sh
```

It will update first your Plutonium files using `plutonium-updater`.

## Issues
### Wine display errors
   + Don't care of these errors, plutonium server doesn't have graphic support.

### Unable to load import '_BinkWaitStopAsyncThread@4' from module 'binkw32.dll'
   + Check your PAT variable in `T4_**_server.sh`. (It will be ping binkw32.dll dir)
   + Make sure to your user can read the file in all sub-dir of T4Server.

### Server don't appear in Plutonium Servers List
   + Check if your server port is open with UDP protocol. (Example: 28961)

### Connection with nix socket lost
   + Check your plutonium key validity
   + Check if your plutonium key are correctly write in `T4_**_server.sh`

### [DW][Auth] Handling authentication request
   + Check your plutonium key validity
   + Check if your plutonium key are correctly write in T6Server.sh

## Source
• **Plutonium:** https://plutonium.pw <br>
• **Minami original topic** https://forum.plutonium.pw/topic/23683/guide-debian-t5-server-on-linux-vps-dedicated-server <br>
• **Plutonium-Updater by mxbe:** https://github.com/mxve/plutonium-updater.rs <br>
