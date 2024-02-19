--[[
  vnavmesh random movement function
  Usage:
    MoveNear(20, 5, 30, walk, 5) to walk to somewhere random within 5 yalms of x20 y5 z30
    MoveNear(20, 5, 30, fly, 5) same as above but flying instead
    MoveNear(20, 5, 30, fly, 5, 60) same as above but stop if it takes more than 60 seconds
  Note 1:
    MoveNear(20, false, 30, walk, 5) probably won't work with navmesh? It's the old visland way of ignoring y
  hc_workaround:
    MoveNear(20, 5, 30, fly, 5, 60, "OEM_8") hc_workaround is for hybrid camera users. Since hybrid camera sets movement type to standard and vnavmesh requires legacy, this is to be set to an otherwise unused key that is configured in hybrid camera as a movement key.
]]

function MoveNear(near_x, near_y, near_z, walkfly, radius, timeout, hc_workaround)
  if walkfly~="fly" then
    movement = "moveto"
  else
    movement = "flyto"
  end
  if type(radius)~="number" then radius = 3 end
  if type(timeout)~="number" then timeout = 999 end
  if type(near_y)=="number" then
    move_y = near_y
  else
    move_y = string.format("%.3f",GetPlayerRawYPos())
  end
  move_x = math.random( (near_x-radius)*1000, (near_x+radius)*1000) /1000
  move_z = math.random( (near_z-radius)*1000, (near_z+radius)*1000) /1000
  if hc_workaround then yield("/hold "..hc_workaround) end
  yield("/vnavmesh "..movement.." "..move_x.." "..move_y.." "..move_z)
  start_moving_tick = 0
  while IsMoving()==false do
    if start_moving_tick>=3 then
      yield("/echo Failed to start moving!")
      yield("/vnavmesh stop")
      if hc_workaround then yield("/release "..hc_workaround) end
      yield("/pcraft stop")
    else
      yield("/wait 0.1")
      start_moving_tick = start_moving_tick + 0.1
    end
  end
  move_tick = 0
  while IsMoving() and move_tick <= timeout do
    move_tick = move_tick + 0.1
    if near_y == false then
      move_y = math.floor(GetPlayerRawYPos()*1000)/1000
      yield("/vnavmesh "..movement.." "..move_x.." "..move_y.." "..move_z)
    end
    yield("/wait 0.1")
  end
  yield("/vnavmesh stop")
  if hc_workaround then yield("/release "..hc_workaround) end
  if is_debug then
    yield("/echo Aimed for: X: "..move_x.." Y: "..move_y.." Z: "..move_z)
    yield("/echo Landed at: "..string.format("X: %.3f Y: %.3f Z: %.3f", GetPlayerRawXPos(), GetPlayerRawYPos(), GetPlayerRawZPos()))
    if move_tick < timeout then
      yield("/echo Reason: arrived")
    else
      yield("/echo Reason: timeout")
    end
  end
  return "X:"..move_x.." Y:"..move_y.." Z:"..move_z
end
