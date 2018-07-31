local awful = require('awful')
local utils = awful.util

local TOOL = 'scrot -b '

local function register(keys)
  return utils.table.join(
    keys,
    awful.key({ }, inc_key, incBrightness),
    awful.key({ }, dec_key, decBrightness)
  )
end

return {init=invoke}
