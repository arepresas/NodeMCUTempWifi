local time_module = {}

local request_utils = require "request_utils"

--local data

local result

local function print_data(data_table)
    local data = ""
    for param,value in pairs(data_table) do
        data = data .. param.." = "..value.."\n"
    end
    print("\nData = " .. data .. "\n")
end

local function display(sck, response)
    print("-- Display response --")
    print(response)
    print("-- End Display response --")

    if sck ~= 0 then
--        print("-- Display response SCK = 0 --")
--        print(response)
--    else
        print("-- Display response SCK <> 0 --")
        local json_start = string.find (response, "{")
        local json_end = string.find (response, "}", start)

        if json_start ~= nil and json_end ~= nil then

            print("Start = "..json_start.." End = "..json_end)

            local json_data = string.sub(response, json_start, json_end)

            print("Data = "..json_data)

            json_data = cjson.decode(json_data)

            for k,v in pairs(json_data) do
                if k == "localDateTime" then
                    print("Time = "..v)
                    result = v
                end
            end

        end

        print("-- END Display response SCK <> 0 --")
    end
end

local function create_http_header()
    return  "Content-Type: application/json\r\n"..
            "Cache-Control: no-cache\r\n"..
            "Postman-Token: 0158e3ce-93e6-ae18-f06f-412344d1d4f7\r\n\r\n"
end

function time_module.get_time_from_server(host, port, uri, callback)

    print("Create connection")
    socket = net.createConnection(net.TCP,8080)

    socket:on("receive",display)

    print("Connecting to " .. host .. ":" .. port)
    socket:connect(port,host)

    socket:on("connection",function(sck)
        local get_request = request_utils.build_get_request(host, port, uri, create_http_header(), "")
        sck:send(get_request)
        callback(result)
    end)
end

return time_module
