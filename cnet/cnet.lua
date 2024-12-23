--[[

cnet.lua

MIT License

Copyright (c) 2024 DanXvoIsMe

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

]]

local spt = {}
local cnet = {}

cnet.spt = spt

local event = require("event")
local enc = require("asciiencryption")
local component = require("component")
local json = require("json")
local tunnel = component.tunnel

local ports = {}
local dolisten = false

cnet.getip = function ()
    local adress = tunnel.address
    local ip = string.sub(adress, 1, 3)
    return ip
end

cnet.openport = function ( port )
    ports[port] = true
end

cnet.isopen = function ( port )
    if ports[port] then
        return true
    else
        return false
    end
end

spt.use = false
spt.key = ""

cnet.send = function ( from, to, port, message )
    local Packed = json.encode({from, to, port, message})
    if spt.use then
        Packed = enc.encrypt(Packed, spt.key)
    end
    tunnel.send(Packed)
end

cnet.recive = function (mip)
    local  _, _, rfrom, _, _, message = event.pull("modem_message")

    if spt.use then
        message = enc.decrypt(message, spt.key)
    end

    local Unpacked = json.decode(message)
    local from = nil
    local to = nil
    local port = nil
    local msg = nil
    for i, a in pairs(Unpacked) do
        if i == 1 then
            from = a
        elseif i == 2 then
            to = a
        elseif i == 3 then
            port = a
        elseif i == 4 then
            msg = a
        end
    end
    if from == string.sub(rfrom, 1, 3) and to == mip and ports[port] == true then
        return msg, from, port
    else
        return cnet.recive(mip)
    end
end

function on_recive()
    
end

cnet.listen = function ( mip, event_name )
    dolisten = true
    event.listen("modem_message", function ( _, _, rfrom, _, _, message )
        if spt.use then
            message = enc.decrypt(message, spt.key)
        end
    
        local Unpacked = json.decode(message)
        local from = nil
        local to = nil
        local port = nil
        local msg = nil
        for i, a in pairs(Unpacked) do
            if i == 1 then
                from = a
            elseif i == 2 then
                to = a
            elseif i == 3 then
                port = a
            elseif i == 4 then
                msg = a
            end
        end
        if from == string.sub(rfrom, 1, 3) and to == mip and ports[port] == true and dolisten == true then
            event.push("cnet_message", from, port, msg)
        end
    end)
end

cnet.unlisten = function (  )
    dolisten = false
end

return cnet
