target = GetNodeText("_TargetInfoMainTarget", 8)
count = -1
function Board()
  if IsAddonVisible("Mobhunt") then board = "Mobhunt" end
  if IsAddonVisible("Mobhunt2") then board = "Mobhunt2" end
  if IsAddonVisible("Mobhunt3") then board = "Mobhunt3" end
  if IsAddonVisible("Mobhunt4") then board = "Mobhunt4" end
  if IsAddonVisible("Mobhunt5") then board = "Mobhunt5" end
end
if string.find(target, "Board") and IsAddonVisible("SelectString") then
  for i=0, 5 do
    if GetSelectStringText(i)~=i then
      yield("/echo "..GetSelectStringText(i))
      count = count + 1
      yield("/echo "..count)
    end
  end
  for j=1, count do
    yield("/click select_string"..j)
    yield("/wait 0.1")
    if not board then Board() end
    yield("/pcall "..board.." true 0")
    yield("/wait 0.1")
    if IsAddonVisible("SelectYesno") then
      yield("/pcall SelectYesno true 0")
    end
    if j < count then
      yield("/wait 1")
      yield("/target "..target)
      yield("/wait 0.1")
      yield("/pinteract")
      yield("/wait 0.7")
    end
  end
end
