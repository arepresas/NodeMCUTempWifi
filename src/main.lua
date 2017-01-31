local m_wifi = require "wifi_module"
local m_dht  = require "dht_module"
local m_lcd  = require "lcd_module"
local m_temp = require "temperature_module"
local m_time = require "time_module"

-- main.lua --
print('\nMain.lua : Starting\n')

-- Global Variables
debug         = false

-- Network Variables
local ssid    = "EubaWifiFree"
local pass    = "Esthercita<3Abrahamcito"
local ip      = ""

-- Server Config Variables
local uri_temp      = "/tempdata"
local uri_time      = "/getTimeNow"
local uri_mMtemp    = "/getMaxMinTemp"
local port          = "8080"
local host_test     = "192.168.0.17"
local host_prod     = "37.187.105.125"
local host
local prod          = true

-- Data variables
local temperatureC  = 0
local humidityPC    = 0
local data

-- Other Variables
local json_time     = ""
local min_temp      = ""
local max_temp      = ""
local timer         = 0


local function print_data(data_table)
  local data = ""
  for param,value in pairs(data_table) do
    data = data .. param.." = "..value.."\n"
  end
  print("\nData = " .. data .. "\n")
end

local function isMod(mod, num)
  while num > 1 do
    --print("BEFORE num = " .. num .. " mod = " .. mod)
    num = num / mod
    --print("AFTER num = " .. num .. " mod = " .. mod)
    if num == 1 then
      --print("isMod OK")
      return true
    end
  end
  --print("isMod KO")
  return false
end

local function getTime()
  m_time.get_time_from_server(host, port, uri_time,
    function(ptime)
      if (ptime ~= nil) then
        json_time = ptime
      end
    end
  )
end

local function getTemps()
  m_temp.get_min_max_temps(host, port, uri_mMtemp,
    function(pMinTemp, pMaxTemp)
      if (pMinTemp ~= nil and pMaxTemp ~= nil) then
        max_temp = pMaxTemp
        min_temp = pMinTemp
      end
    end
  )
end

print('\nMain.lua : Connecting Wifi\n')
m_wifi.connect(ssid, pass,
  function(pIp)
    if (pIp ~= nil) then
      ip = pIp
    end
  end
)

if prod then
  host = host_prod
  debug = false
else
  host = host_test
  debug = true
end

tmr.alarm(0,15000, 1, function()

  print("TIMER = " .. timer)

  local temperatureC, humidityPC = m_dht.read()
  m_lcd.print_screen(ssid, ip, json_time, temperatureC, humidityPC, min_temp, max_temp)

  if isMod(2, timer) then
    getTime()
    print("TimeFromServer = " .. json_time)
  end

  if isMod(3, timer) then
    data = {
      temperature = temperatureC,
      humidity = humidityPC
    }
    if debug then
      print_data(data)
    end
    getTemps()
  end

  if isMod(53, timer) then
    m_temp.save_temp_in_db(data, host, port, uri_temp)
    timer = 0
  end

  timer = timer + 1
end)