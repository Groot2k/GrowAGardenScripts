print("HTTP TEST START")

local data = game:HttpGet("https://raw.githubusercontent.com/Groot2k/GrowAGardenScripts/main/cek1.lua", true)
print("HTTP OK, PANJANG DATA:", #data)

loadstring(data)()
