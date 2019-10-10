local awful = require('awful')
local utils = awful.util

local GRAB = 'scrot -b '
local GRAB_SELECT = GRAB .. ' -s '

-- TODO: implemenet copying to clipboard
local GRAB_COPY = GRAB
local GRAB_SELECT_COPY = GRAB


local function grab() 
  return ()
end

-- Register the keybindings
local function register(keys, modkey)
  return utils.table.join(
    keys,
    awful.key({ }, inc_key, incBrightness),
    awful.key({ }, dec_key, decBrightness)
  )
end

return {init=invoke}
