local wifi_module = {}

-- Configure Wireless Internet
local function init()
  wifi.setmode(wifi.STATION)
  print('set mode=STATION (mode='..wifi.getmode()..')\n')
  print('MAC Address: ',wifi.sta.getmac())
  print('Chip ID: ',node.chipid())
  print('Heap Size: ',node.heap(),'\n')
end

----------------------------------
-- WiFi Connection Verification --
----------------------------------

function wifi_module.connect(ssid, pass, callback)
  init()
  wifi.sta.config(ssid,pass)

  print("Ready to Set up wifi mode ")
  wifi.sta.connect()

  local cnt = 0
  tmr.alarm(3, 1000, 1, function()
    if (wifi.sta.getip() == nil) and (cnt < 20) then
      print("Trying Connect to Router, Waiting...")
      cnt = cnt + 1
    else
      tmr.stop(3)
      if (cnt < 20) then print("Config done, IP is "..wifi.sta.getip())
        local ip, nm, gw = wifi.sta.getip()
        print("IP Address: ",ip)
        print("Netmask: ",nm)
        print("Gateway Addr: ",gw,'\n')
        callback(ip)
      else print("Wifi setup time more than 20s, Please verify wifi.sta.config() function. Then re-download the file.")
      end
      cnt = nil
      collectgarbage()
    end
  end)
end

return wifi_module
