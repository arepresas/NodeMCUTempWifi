local request_utils = {}


local function create_http_host(host,  port , uri)
    return "http://" .. host .. ":" .. port .. "/" .. uri
end

function build_get_request(host, port, uri, http_header, http_body)

    print("Start build GET request")

    http.get(create_http_host(host,  port , uri),
        http_header,
        http_body,
        function(code, data)
            if (code < 0) then
                print("HTTP request failed")
            else
                print(code, data)
                return data
            end
        end)
end

function build_post_request(host, port, uri, http_header, http_body)

    print("Start build POST request")

    http.post(create_http_host(host,  port , uri),
        http_header,
        http_body,
        function(code, data)
            if (code < 0) then
                print("HTTP request failed")
            else
                print(code, data)
                return data
            end
        end)

    local data_json = cjson.encode(data_table) --build_data_for_request(data_table)

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

return request_utils
