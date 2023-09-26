Characters = {
    'Character Name@Server', 
    'Character Name@Server', 
    'Character Name@Server', 
}
for _, char in ipairs(Characters) do
yield("/ays relog " .. char)
yield("/wait 10")
yield("/waitaddon NamePlate <maxwait.600><wait.5>")
for loops = 5, 1, -1 do
    if IsAddonVisible("JournalDetail")==false then yield("/dutyfinder") end
    yield("/waitaddon JournalDetail")
    yield("/pcall ContentsFinder true 1 9")
    yield("/pcall ContentsFinder true 12 1")
    yield("/pcall ContentsFinder true 3 7")
    yield("/pcall ContentsFinder true 12 0 <wait.1>")
    if IsAddonVisible("ContentsFinderConfirm") then yield("/click duty_commence") end
    
    yield("/waitaddon LovmResult <maxwait.900>")
    yield("/pcall LovmResult false -2")
    yield("/pcall LovmResult true -1")
    yield("/waitaddon NamePlate <maxwait.60><wait.5>")
    end
end
yield ("/ays multi")