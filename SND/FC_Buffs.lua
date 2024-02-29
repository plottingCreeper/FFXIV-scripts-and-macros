is_use_level_2_buffs = true
actions_to_buy = {
  "heat of battle",
  "reduced rates",
}

----------------------------------------------------------

actions_list = {
  "heat battle",
  "earth water",
  "helping hand",
  "best friend",
  "mark up",
  "seal sweetener",
  "jack pot",
  "brave world",
  "live land",
  "what you",
  "eat hand",
  "control control",
  "which binds",
  "meat mead",
  "proper care",
  "fleet foot",
  "reduced rates",
}

selected_action = 0

function NextBuff()
  action_click = nil
  if selected_action < #actions_to_buy then
    selected_action = selected_action + 1
  else
    selected_action = 1
  end
  for number, name in pairs(actions_list) do
    if string.find(actions_to_buy[selected_action],string.gsub(name, ".+ ", "")) or string.find(actions_to_buy[selected_action],string.gsub(name, " .+", "")) then
      if is_use_level_2_buffs then
        action_click = number + 16
      else
        action_click = number - 1
      end
      break
    end
  end
  if not action_click then yield("/pcall stop") end
end

for i, _ in pairs(actions_to_buy) do
  actions_to_buy[i] = string.gsub(string.lower(actions_to_buy[i]),"%A","")
end

while not IsAddonVisible("FreeCompanyExchange") do
  if GetTargetName()~="OIC Quartermaster" then
    yield("/target OIC Quartermaster")
  elseif GetCharacterCondition(32, false) then
    yield("/pinteract")
  elseif IsAddonVisible("Talk") then
    yield("/click talk")
  elseif IsAddonVisible("SelectString") then
    yield("/pcall SelectString true 0")
  end
  yield("/wait 0.5")
end

while not IsAddonReady("FreeCompanyExchange") do yield("/wait 0.1") end

while IsAddonVisible("FreeCompanyExchange") do
  action_inventory = GetNodeText("FreeCompanyExchange", 6)
  action_max = string.gsub(action_inventory, "%d+/", "")
  action_current = string.gsub(action_inventory, "/%d+", "")
  buy_amount = tonumber(action_max) - tonumber(action_current)
  if not (buy_amount>0) then
    yield("/pcall FreeCompanyExchange true -1")
    break
  end
  if IsAddonVisible("SelectYesno") then
    yield("/pcall SelectYesno true 0")
  elseif buy_amount>0 then
    NextBuff()
    yield("/pcall FreeCompanyExchange true 2 "..action_click.."u")
  end
  yield("/wait 0.5")
end
