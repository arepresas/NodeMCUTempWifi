local temperature_module = {}

local request_utils = require "request_utils"

--local data
local minTemp
local maxTemp

local function create_http_header()
    return "Content-Type: application/json\r\n" ..
           "Cache-Control: no-cache\r\n"
end

local function get_max_min_values(pResponse)
    for k,v in pairs(pResponse) do
        if k == "minTemp" then
            print("MinTemp = "..v)
            minTemp = v
        else
            print("MaxTemp = "..v)
            maxTemp = v
        end
    end
end

function temperature_module.save_temp_in_db(data_table, host, port, uri)
    request_utils.build_post_request(host, port, uri,
        create_http_header(),
        cjson.encode(data_table),
        function(pResult)
            if pResult == nil then
                print("save_temp_in_db KO")
            else
                print("save_temp_in_db OK - Inserted ID = " .. pResult)
            end
        end
    )
end

function temperature_module.get_min_max_temps(host, port, uri, callback)
    request_utils.build_get_request(host, port, uri, get_max_min_values)
    callback(minTemp, maxTemp)
end

return temperature_module
