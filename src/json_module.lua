local temperature_module = {}

local request_utils = require "request_utils"

--local data

local function display(sck,response)
    print(response)
end

local function create_http_header(data_length)
    return "Content-Type: application/json\r\n"..
           "Cache-Control: no-cache\r\n".."Content-Length: "..
           data_length..
           "\n\r"..
           "Postman-Token: 0158e3ce-93e6-ae18-f06f-412344d1d4f7\r\n\r\n"
end

function temperature_module.save_temp_in_db(data_table, host, port, uri)

    local http_body = cjson.encode(data_table)
    local http_header = create_http_header(string.len(http_body))

    print("Create connection")
    socket = net.createConnection(net.TCP,8080)

    socket:on("receive",display)

    print("Connecting to " .. host .. ":" .. port)
    socket:connect(port,host)

    socket:on("connection",function(sck)

        local post_request = request_utils. build_post_request(host, port, uri, http_header, http_body)

        print(" --- Request --- ")
        print(post_request)
        print(" --- End Request --- ")

        sck:send(post_request)
    end)
end

function temperature_module.print_data(data_table)
    local data = ""
    for param,value in pairs(data_table) do
        data = data .. param.." = "..value.."\n"
    end
    print("\nData = " .. data .. "\n")
end

return temperature_module
