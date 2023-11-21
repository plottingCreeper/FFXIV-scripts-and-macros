main = ""
keep_gil_in_fc_chest = 100000000
keep_gil_on_alts = 0

file_characters = os.getenv("appdata").."\\XIVLauncher\\pluginConfigs\\SomethingNeedDoing\\my_characters.txt"
if io.open(file_characters,"r")~=nil then
  file_characters = io.input(file_characters)
  main = file_characters:read("l")
  file_characters:close()
end

yield("/echo Main character set to: "..main)
if string.find(main, GetCharacterName()) then
  yield("/echo On main character!")
  on_main = true
end

if IsAddonVisible("FreeCompanyChest") then
  yield("/pcall FreeCompanyChest true 2")
  yield("/waitaddon Bank")
  if on_main then
    gil = string.gsub(GetNodeText("Bank",20),"%D","") - keep_gil_in_fc_chest
    yield("/pcall Bank true 2")
    yield("/wait 0.1")
  else
    gil = string.gsub(GetNodeText("Bank",15),"%D","") - keep_gil_on_alts
  end
  if tonumber(gil) > 0 then
    yield("/pcall Bank true 3 "..gil)
    yield("/wait 0.1")
    yield("/pcall Bank true 0")
  else
    yield("/pcall Bank true 1")
  end
end

