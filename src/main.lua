local mywifi = require "wifi_module"
local mydht = require "dht_module"
local mylcd = require "lcd_module"
local temperature = require "temperature_module"
local time = require "time_module"

-- main.lua --
print('\nMain.lua : Starting\n')

-- Global Variables
temperatureC = 0
humidityPC = 0
time_between_sensor_readings = 5

-- Network Variables
local ssid = "EubaWifiFree"
local pass = "Esthercita<3Abrahamcito"
local ip = ""

-- Server Config Variables
local uri_temp = "/tempdata"
local uri_time = "/getTimeNow"
local host_test = "192.168.0.21"
local host_prod = "37.187.105.125"
local host
local port = 8080

-- Other Variables
local json_time = ""
local timer = 0
local data
local debug = 0
local prod = 1

local function setIp(pIp)
  if (pIp ~= nil) then
    ip = pIp
  end
end

local function setTime(ptime)
  if (ptime ~= nil) then
    json_time = ptime
  end
end

print('\nMain.lua : Connecting Wifi\n')
mywifi.connect(ssid, pass, setIp)

if prod == 1 then
  host = host_prod
else
  host = host_test
end

--local function set_time(local_time)
--  json_time = local_time
--end

tmr.alarm(0,15000, 1, function()

  time.get_time_from_server(host, port, uri_time, setTime)

  print(json_time)

  local temperatureC, humidityPC = mydht.read()
  mylcd.print_screen(ssid, ip, json_time, temperatureC, humidityPC, "10", "15")

  timer = timer + 1

  --if timer/4 == 0 then
--  local t = cjson.decode(time.get_time_from_server(host, port, uri_time))
--  for k,v in pairs(t) do print(k,v) end
  --end

  if timer == 40 then

    timer = 0
    data = {
      temperature = temperatureC,
      humidity = humidityPC
    }

    if debug == 1 then
      temperature.print_data(data)
    end

    temperature.save_temp_in_db(data, host, port, uri_temp)
  end

end)







