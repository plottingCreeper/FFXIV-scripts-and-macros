characters_to_run = {
  5, 6, 4
}
my_characters = {'Character Name@Server', 'Alt Name@Server',}
what_to_play = "Master Battle (Extreme)"
games_to_lose = 5
file_characters = os.getenv("appdata").."\\XIVLauncher\\pluginConfigs\\SomethingNeedDoing\\my_characters.txt"

if io.open(file_characters,"r")~=nil then
  file_characters = io.input(file_characters)
  main = file_characters:read("l")
  my_characters = {}
  next_line = main
  i = 0
  while next_line do
    i = i + 1
    my_characters[i] = next_line
    yield("/echo Character "..i.." from file: "..next_line)
    next_line = file_characters:read("l")
  end
  file_characters:close()
  yield("/echo Characters loaded from file: "..i)
else
  yield("/echo "..file_characters.." not found!")
end

tick = 0
completed_characters = 0
next_character = my_characters[characters_to_run[completed_characters+1]]

::Relog::
games_played = 0
if not string.find(next_character, GetCharacterName()) then
  yield("/ays relog " .. next_character)
  yield("/wait 10")
  yield("/waitaddon NamePlate <maxwait.600><wait.5>")
end

if HasStatus("Squadron Enlistment Manual")==false and GetItemCount(14945)~=0 then
  yield("/wait 1")
  yield("/item Squadron Enlistment Manual")
  yield("/wait 3")
end

::Queue::
if IsAddonVisible("JournalDetail")==false then yield("/dutyfinder") end
yield("/waitaddon JournalDetail")
yield("/pcall ContentsFinder true 1 9")
yield("/pcall ContentsFinder true 12 1")
while string.gsub(GetNodeText("ContentsFinder", 25, 6, 14),"%W","")=="" do
  yield("/wait 0.1")
  tick = tick + 1
  if tick > 30 then yield("/pcraft stop")
end
yield("/wait 0.1")
for i=3, 12 do
  entry = GetNodeText("ContentsFinder", 25, i, 14)
  if entry==what_to_play then
    click = i-2
    break
  end
end
if not click then yield("/pcraft stop") end
yield("/pcall ContentsFinder true 3 "..click)
yield("/pcall ContentsFinder true 12 0 <wait.1>")
if IsAddonVisible("ContentsFinderConfirm") then yield("/click duty_commence") end

::Return::
yield("/waitaddon LovmResult <maxwait.666>")
games_played = games_played + 1
yield("/pcall LovmResult false -2")
yield("/pcall LovmResult true -1")
yield("/waitaddon NamePlate <maxwait.60><wait.5>")

if HasStatus("Squadron Enlistment Manual")==false and GetItemCount(14945) > 0 then
  yield("/wait 1")
  yield("/item Squadron Enlistment Manual")
  yield("/wait 3")
end

if games_played < games_to_lose then goto Queue end
completed_characters = completed_characters + 1

next_character = my_characters[characters_to_run[completed_characters+1]]
if next_character then goto Relog end



::Finish::
yield("/ays relog " .. main)
yield("/wait 10")
yield("/ays multi")


