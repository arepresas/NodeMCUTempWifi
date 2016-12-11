local mywifi = require "wifi_module"
local mydht = require "dht_module"
local mylcd = require "lcd_module"

-- main.lua --
print('\nMain.lua : Starting\n')

-- Global Variables
temperatureC = 0
humidityPC = 0
time_between_sensor_readings = 5

-- Network Variables
local ssid = "EubaWifiFree"
local pass = "Esthercita<3Abrahamcito"
local ip

print('\nMain.lua : Connecting Wifi\n')
local ip = mywifi.connect(ssid, pass)


tmr.alarm(0,30000, 1, function()
  local temperatureC, humidityPC = mydht.read()
  mylcd.print_screen(ssid, "", temperatureC, humidityPC, "", "")
end)







