local dht_module = {}

-- DHT Variables
local dht11PIN    = 5

----------------------
-- Read Temperature --
----------------------

function dht_module.read()
  local status, temperature, humidity = dht.read11(dht11PIN)
  if status == dht.OK then
    print("DHT Temperature:"..temperature..";".."Humidity:"..humidity)
  elseif status == dht.ERROR_CHECKSUM then
    print( "DHT Checksum error." )
  elseif status == dht.ERROR_TIMEOUT then
    print( "DHT timed out." )
  end
  return temperature, humidity
end

return dht_module