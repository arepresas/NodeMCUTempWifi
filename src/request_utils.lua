local request_utils = {}


local function create_http_host(pHost,  pPort , pUri)
    return "http://" .. pHost .. ":" .. pPort .. pUri
end

local function create_get_http_header()
    return  "Cache-Control: no-cache"
end

local function debug_request_parameters(pHost, pPort, pUri, pHttp_header, pHttp_body, pCallback)
    if debug then
        print("-- Request parameters --")
        print(create_http_host(pHost,  pPort , pUri))
        print(pHttp_header)
        print(pHttp_body)
        print(pCallback)
        print("-- Request parameters --")
    end
end

function request_utils.get_request(pHost, pPort, pUri, pCallback)

    print("-- Start GET request --")
    debug_request_parameters(pHost, pPort, pUri, create_get_http_header(), nil, pCallback)

    http.get(
        create_http_host(pHost,  pPort , pUri),
        create_get_http_header(),
        function(pCode, pData)
            if (pCode < 0) then
                print("HTTP request failed")
            else
                print(pCode, pData)
                pCallback(cjson.decode(pData))
            end
        end
    )
    print("-- Finish GET request --")
end

function request_utils.post_request(pHost, pPort, pUri, pHttp_header, pHttp_body, pCallback)

    print("-- Start POST request --")
    debug_request_parameters(pHost, pPort, pUri, pHttp_header, pHttp_body, pCallback)

    http.post(
        create_http_host(pHost,  pPort , pUri),
        pHttp_header,
        pHttp_body,
        function(pCode, pData)
            if (pCode < 0) then
                print("HTTP request failed")
            else
                print(pCode, pData)
                pCallback(pData)
            end
        end)
    print("-- Finish POST request --")
end

return request_utils