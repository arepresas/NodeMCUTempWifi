local request_utils = {}


local function create_http_host(host,  port , uri)
    return "http://" .. host .. ":" .. port .. uri
end

local function create_get_http_header()
    return  "Cache-Control: no-cache"
end

local function debug_request_parameters(host, port, uri, http_header, http_body, callback)
    if debug == 1 then
        print("-- Request parameters --")
        print(create_http_host(host,  port , uri))
        print(http_header)
        print(http_body)
        print(callback)
        print("-- Request parameters --")
    end
end

function request_utils.build_get_request(host, port, uri, callback)

    print("-- Start GET request --")
    debug_request_parameters(host, port, uri, create_get_http_header(), nil, callback)

    http.get(
        create_http_host(host,  port , uri),
        create_get_http_header(),
        function(pCode, pData)
            if (pCode < 0) then
                print("HTTP request failed")
            else
                print(pCode, pData)
                callback(cjson.decode(pData))
            end
        end
    )
    print("-- Finish GET request --")
end

function request_utils.build_post_request(host, port, uri, http_header, http_body, callback)

    print("-- Start POST request --")
    debug_request_parameters(host, port, uri, http_header, http_body, callback)

    http.post(
        create_http_host(host,  port , uri),
        http_header,
        http_body,
        function(pCode, pData)
            if (pCode < 0) then
                print("HTTP request failed")
            else
                print(pCode, pData)
                callback(pData)
            end
        end)
    print("-- Finish POST request --")
end

return request_utils
