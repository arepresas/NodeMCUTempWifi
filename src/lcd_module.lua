local lcd_module = {}

local function print_wifi(pSsid, pIp)
  lcd.locate(0,0)
  lcd.print(pSsid)
  lcd.locate(0,1)
  lcd.print(pIp)
end

local function print_time(pTime)
  lcd.locate(0,2)
  lcd.print(pTime)
end

local function print_temp(pTemp, pHum)
  lcd.locate(0,3)
  lcd.print("Temp = "..pTemp.."C")
  lcd.locate(0,4)
  lcd.print("Hum  = "..pHum.."%")
end

local function print_min_max_day(pT_min, pT_max)
  lcd.locate(0,5)
  lcd.print("Mn="..pT_min.."C".." Mx="..pT_max.."C")
end

function lcd_module.print_screen(pSsid, pIp, pTime, pTemp, pHum, pT_min, pT_max)
  print("Showing info in LCD "..pSsid.." "..pIp.." "..pTime.." "..pTemp.." "..pHum.." "..pT_min.." "..pT_max.."\n")
  lcd.init()
  lcd.clear()
  print_wifi(pSsid,pIp)
  print_time(pTime)
  print_temp(pTemp,pHum)
  print_min_max_day(pT_min, pT_max)
end

return lcd_module