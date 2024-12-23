local cnet = {}

local event = require("event")
local enc = require("asciiencryption")
local component = require("component")
local json = require("json")
local tunnel = component.tunnel

local ports = {}
local encryptkey = ""

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

cnet.setencrypt = function ( key )
    encryptkey = key
end

cnet.send = function ( from, to, port, message )
    local Packed = json.encode({from, to, port, message})
    if encryptkey ~= "" then
        Packed = enc.encrypt(Packed, encryptkey)
    end
    tunnel.send(Packed)
end

cnet.recive = function (mip)
    local  _, _, rfrom, _, _, message = event.pull("modem_message")

    if encryptkey ~= "" then
        message = enc.decrypt(message, encryptkey)
    end

    local Unpacked = json.decode(message)
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
        return msg
    end
end

return cnet
