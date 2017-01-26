local json_module = {}

--local data

local function display(sck,response)
    print(response)
end

local function build_data_for_request(data_table)
    local data = "{"
    for param,value in pairs(data_table) do
        data = data .. "\""..param.."\""..":".."\""..value.."\""..","
    end
    data = string.sub (data, 0, string.len(data)-1) .. "}"

    return data
end

local function build_post_request(host, port, uri, data_table)

    print("Start build request")

    local data_json = build_data_for_request(data_table)

    local request = "POST "..uri.." HTTP/1.1\r\n"..
            "Host: "..host..":"..port.."\r\n"..
            "Content-Type: application/json\r\n"..
            "Cache-Control: no-cache\r\n"..
            "Content-Length: "..string.len(data_json).."\n\r"..
            "Postman-Token: 0158e3ce-93e6-ae18-f06f-412344d1d4f7\r\n\r\n"..
            data_json

    print(request)

    return request
end

function json_module.save_temp_in_db(data_table, host, port, uri)

    print("Create connection")
    socket = net.createConnection(net.TCP,8080)

    socket:on("receive",display)

    print("Connecting to " .. host .. ":" .. port)
    socket:connect(port,host)

    socket:on("connection",function(sck)

        local post_request = build_post_request(host,port,uri,data_table)

        print(" --- Request --- ")
        print(post_request)
        print(" --- End Request --- ")

        sck:send(post_request)
    end)
end

function json_module.print_data(data_table)
    local data = ""
    for param,value in pairs(data_table) do
        data = data .. param.." = "..value.."\n"
    end
    print("\nData = " .. data .. "\n")
end

return json_module
