Working! Still have some stuff left to do. All the important stuff is done.
Don't message me. I don't care what you have to say.
In case you're blind and/or stupid, here's another link to the script itself https://github.com/plottingCreeper/FFXIV-scripts-and-macros/blob/main/SND/MarketBotty/MarketBotty.lua

# MarketBotty!
Automatic sale undercutting script. Requires `Something Need Doing (Expanded Edition)`. Multimode currently requires `AutoRetainer`.
Requires Pandora for /pcall, but that's being moved to SND at some point(?) so good luck I guess.
<br>

## Starting conditions
If script is started while not at a summoning bell, it will try to find a summoning bell and interact with it. Don't expect too much of this. It's only intended for multimode, for characters that are logged out near a summoning bell or house.  
If started while on the retainer list, MarketBotty will run in normal mode. Retainers that have items for sale and aren't on the blacklist will be opened. All items on opened retainers will be repriced according to configured pricing logic.  
If started while a retainer is open, MarketBotty will run in single retainer mode. All items on that retainer will be repriced, then the script will stop.  
If started while an item price window is open, MarketBotty will run in single item mode. That item will be repriced, then the script will stop.  
If started while at a summoning bell, and the `Recommendations` window is open, MarketBotty will start in helper mode. It will wait for an item sale window to appear, then it will reprice the item and go back to waiting. Helper mode will end when the summoning bell is closed.  

## Repricing logic
MarketBotty will read the first 10 prices from search, and up to 20 prices from history.  
A trimmed mean is taken from history prices by culling the highest and lowest `5` (configurable) then averaging what's left.  
The lowest search result is found which:
- is higher than 1 gil
- is higher than half the trimmed mean from history

If none of the first 9 search results qualify, then the 10th search result is chosen.  
If the 10th search result is lower than the item `minimum` set in `item_overrides` then item minimum is used instead.  
Unless `minimum` is used, the target listings retainer name will be checked. If it's on the `my_retainers` list, the price will be matched rather than undercut.  
If after all this the price is somehow only 1, it will be set to 69 instead. That's an old bit of code, but it seemed nice enough, so it's staying in.  

If there are no search results, the price is set to history trimmed mean multiplied by `10` (configurable).

<br>

## Script options

### after_multi
`"logout"` to logout
`"wait 10"` to wait `10` minutes (configurable)
`1` to relog to first character in `my_characters` list.


### `my_characters`  
Used for multimode. First in the list should be main character, which will be switched back to before running `multimode_ending_command`  
Will probably cause an infinite wait loop if your character isn't known to AutoRetainer. Rework planned eventually to remove dependency, but it's still going to require you to spell your own characters name correctly.  
```
my_characters = { --Characters to switch to in multimode
  'Character Name@Server',
  'Character Name@Server',
}
```

<br>
<br>

### `my_retainers`  
Exact string match. Price sanity checking takes priority, but if the target price is of a retainer on this list, it will be matched rather than undercut.
```
my_retainers = { --Retainers to avoid undercutting
  'Dont-undercut-this-retainer',
  'Or-this-one',
}
```

<br>
<br>

### `blacklist_retainers`  
Exact string match. Retainers on this list will be skipped when opening the next retainer. MarketBotty will still run in single retainer mode if started when a blacklisted retainer is already open.
```
blacklist_retainers = { --Do not run script on these retainers
  'Dont-run-this-retainer',
  'Or-this-one',
}
```

<br>
<br>

`my_characters`, `my_retainers`, and `blacklist_retainers` arrays are **replaced** be the contents of `file_characters`, `file_retainers`, and `file_blacklist`, if found.  
Files should be one entry per line, with no additional quotes, escape characters, or formatting of any kind.  
Default file location is `%appdata%\XIVLauncher\pluginConfigs\SomethingNeedDoing\`  
