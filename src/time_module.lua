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

function time_module.get_time_from_server(host, port, uri, callback)
    request_utils.build_get_request(host, port, uri, getLocalTime)
    callback(result)
end

return time_module
