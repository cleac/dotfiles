local awful = require("awful")
local io = io

local app = 'light '
local get_args = ''
local inc_cmd = '-Ap '
local dec_cmd = '-Up '
local last_modificator = 2
local percent_modificator = 30

local inc_key = "XF86MonBrightnessUp"
local dec_key = "XF86MonBrightnessDown"

local function getCurBrightness ()
    return tonumber(io.popen(app..get_args):read('*line'))
end

local function computeBrightnessDiff ()
    local brightness = getCurBrightness()
    if brightness ~= nil and brightness > 0.01 then
        last_modificator = brightness * (percent_modificator / 100.0)
    end
    return last_modificator
end

local function incBrightness ()
    awful.util.spawn(app..inc_cmd..computeBrightnessDiff())
end

local function decBrightness ()
    awful.util.spawn(app..dec_cmd..computeBrightnessDiff())
end

local function registerBrightnessKeys(keys)
  return awful.util.table.join(
    keys,
    awful.key({ }, inc_key, incBrightness),
    awful.key({ }, dec_key, decBrightness)
  )
end


return {init=registerBrightnessKeys}
