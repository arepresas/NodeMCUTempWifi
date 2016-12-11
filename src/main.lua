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

print('\nMain.lua : Connecting Wifi\n')
local ip = mywifi.connect(ssid, pass)

tmr.alarm(3, 1000, 1, function()
  if ip then
    tmr.alarm(3, 1000, 1, function()
      print('\nMain.lua : Reading sensor\n')
      local temp, hum = mydht.read()
      print('\nMain.lua : Printing LCD\n')
      mylcd.print_screen(ssid, ip, temp, hum, temp, temp)
      print('\nMain.lua : Finishing\n')
    end)
  else
    tmr.stop(3)
    lcd.clear()
    lcd.locate(0,0)
    --lcd.write("ERROR WIFI")
    collectgarbage()
  end
end)
