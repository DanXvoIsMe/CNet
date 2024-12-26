# CNet
A simple library for controlling linked card in open computers minecraft mod.

### What this require?
- JSON Lua Library made by rxi.
- ASCII encryptor made by danxvo (me)

### Api reference
#### Main
- *cnet.getip(): return you'r ip*
- *cnet.openport(port: number): opens port on you'r computer*
- *cnet.isopen(port: number): return true if port is open*
- *cnet.send(from: string, to: string, port: number, message: any): send packet to decided server or computer if port is open*
- *cnet.recive(mip: string): wait for a packet and when recive then return 3 values msg, from, port*
- *cnet.listen(mip: string, callback: function): start a listner*
#### SPT (Secure Package Transfer)
- *cnet.spt.use: bool*
- *cnet.spt.sptkey: bool*

### Install
```bash
wget -f https://raw.githubusercontent.com/DanXvoIsMe/CNet/main/installer.lua /tmp/installer.lua && lua /tmp/installer.lua
```

### Made by danxvo
