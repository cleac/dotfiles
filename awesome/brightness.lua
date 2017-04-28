local awful = require("awful")

local app = 'light '
local inc_cmd = '-Ap '
local dec_cmd = '-Up '
local default_percents = 2

local inc_key = "XF86MonBrightnessUp"
local dec_key = "XF86MonBrightnessDown"

local function registerBrightnessKeys(keys)
  return awful.util.table.join(
    keys,
    awful.key({ }, inc_key, function () awful.util.spawn(app..inc_cmd..default_percents) end),
    awful.key({ }, dec_key, function () awful.util.spawn(app..dec_cmd..default_percents) end)
  )
end


return {init=registerBrightnessKeys}
