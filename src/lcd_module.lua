local lcd_module = {}

local function print_wifi(ssid, ip)
  lcd.locate(0,0)
  lcd.print(ssid)
  lcd.locate(0,1)
  lcd.print(ip)
end

local function print_temp(temp, hum)
  lcd.locate(0,2)
  lcd.print("Temp = "..temp.."C")
  lcd.locate(0,3)
  lcd.print("Hum  = "..hum.."%")
end

local function print_min_max_day(t_min, t_max)
  lcd.locate(0,4)
  lcd.print("MinTemp = "..t_min.."C")
  lcd.locate(0,5)
  lcd.print("MaxTemp = "..t_max.."C")
end

function lcd_module.print_screen(ssid, ip, temp, hum, t_min, t_max)
  print("Showing info in LCD "..ssid.." "..ip.." "..temp.." "..hum.." "..t_min.." "..t_max)
  lcd.init()
  lcd.clear()
  print_wifi(ssid,ip)
  print_temp(temp,hum)
  print_min_max_day(temp,temp)
  return 1
end

return lcd_module
