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
  if on_main then
    yield("/pcall FreeCompanyChest true 1")
    for i=1, 18 do
      if tonumber(GetNodeText("FreeCompanyChest", 27-i, 1)) > 1 then
        yield("/pcall FreeCompanyChest true 4 "..i-1)
        yield("/wait 0.1")
        if IsAddonVisible("ContextMenu") then
          yield("/pcall ContextMenu true 0 0 0 0 0")
          yield("/wait 1")
        end
      end
    end
  end
end
