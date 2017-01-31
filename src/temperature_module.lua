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
        elseif k == "maxTemp" then
            print("MaxTemp = "..v)
            maxTemp = v
        end
    end
end

function temperature_module.save_temp_in_db(pData_table, pHost, pPort, pUri)
    request_utils.post_request(pHost, pPort, pUri,
        create_http_header(),
        cjson.encode(pData_table),
        function(pResult)
            if pResult == nil then
                print("save_temp_in_db KO")
            else
                print("save_temp_in_db OK - Inserted ID = " .. pResult)
            end
        end
    )
end

function temperature_module.get_min_max_temps(pHost, pPort, pUri, pCallback)
    request_utils.get_request(pHost, pPort, pUri, get_max_min_values)
    pCallback(minTemp, maxTemp)
end

return temperature_module