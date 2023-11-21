 
function ContextMenu(input)
  string = input
  menu = "ContextMenu"
  if not IsAddonVisible("ContextMenu") then yield("/wait 0.1") end
  ::Retry::
  if IsAddonVisible(menu) and string then
    for i=1, 21 do
      entry = GetNodeText(menu, 2, i, 6)
      if entry==6 then break end
      if entry==string then
        click = i-1
        break
      end
    end
    if click then
      yield("/pcall "..menu.." true 0 "..click)
      if string == "Second Tier" then
        string = input
        click = nil
        menu = "AddonContextSub"
        yield("/wait 0.1")
        goto Retry
      end
    elseif string~="Second Tier" then
      string = "Second Tier"
      goto Retry
    end
  end
  if click then return true else return false end
end
