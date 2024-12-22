# CNet
A simple library for controlling linked card in open computers minecraft mod.

### What this require?
1.JSON Lua Library made by rxi.
2.ASCII encryptor made by danxvo (me)
*All of this is automaticlly installed.*

### Api reference
- *getip(): return you'r ip*
- *openport(port: number): opens port on you'r computer*
- *isopen(port: number): return true if port is open*
- *send(from: string, to: string, port: number, message: any): send packet to decided server or computer if port is open*
- *recive(mip: string): wait for a packet*

### Install
```bash
wget -f https://raw.githubusercontent.com/DanXvoIsMe/CNet/main/installer.lua /tmp/installer.lua && lua /tmp/installer.lua
```

### Made by danxvo
