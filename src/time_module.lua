local time_module = {}

local request_utils = require "request_utils"

--local data

local result

local function getLocalTime(pResponse)
    for k,v in pairs(pResponse) do
        if k == "localDateTime" then
            print("Time = "..v)
            result = v
        end
    end
end

function time_module.get_time_from_server(pHost, pPort, pUri, pCallback)
    request_utils.get_request(pHost, pPort, pUri, getLocalTime)
    pCallback(result)
end

return time_module