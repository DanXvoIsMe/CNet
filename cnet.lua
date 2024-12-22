local cnet = {}

local event = require("event")
local component = require("component")
local json = require("json")
local tunnel = component.tunnel

local ports = {}

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

cnet.send = function ( from, to, port, message )
    local Packed = json.encode({from, to, port, message})
    tunnel.send(Packed)
end

cnet.recive = function (mip)
    local _, _, rfrom, _, message = event.pull("modem_message")

    local Unpacked = json.decode(message)
    local from = Unpacked[1]
    local to = Unpacked[2]
    local port = Unpacked[3]
    local msg = Unpacked[4]
    if from == rfrom then
        if to == mip then
            if ports[port] == true then
                return msg, port
            end
        end
    end
end

return cnet
