-- Variables mask
local awful = require('awful')
local utils = awful.util
local gears = require('gears')
local wibox = require('wibox')
local naughty = require('naughty')
local io = io

local app = 'light '
local get_args = ''
local inc_cmd = '-A '
local dec_cmd = '-U '
local last_modificator = 2
local percent_modificator = 30

local inc_key = 'XF86MonBrightnessUp'
local dec_key = 'XF86MonBrightnessDown'

local widgetData = {
    widgets = {}
}

local function getCurBrightness ()
    return tonumber(io.popen(app..get_args):read('*line'))
end

local function computeBrightnessDiffOld ()
    local brightness = getCurBrightness()
    if brightness ~= nil and brightness > 0.01 then
        last_modificator = brightness * (percent_modificator / 100.0)
    end
    return last_modificator
end

local function computeBrightnessDiff ()
    local brightness = getCurBrightness()
    return math.log(2 + brightness)
end

local function showNotif (brightness)
    if widgetData.notificationId == nil then
        widgetData.notificationId = naughty.notify {
            position = 'bottom_middle',
            text     = tostring(brightness),
            shape    = gears.shape.rounded_rect,
            margin   = 10,
            timeout  = 1,
            destroy  = function ()
                widgetData.notificationId = nil
            end,
        }.id
    else
        widgetData.notificationId = naughty.notify {
            position = 'bottom_middle',
            text     = tostring(brightness),
            shape    = gears.shape.rounded_rect,
            margin   = 10,
            timeout  = 1,
            destroy  = function ()
                widgetData.notificationId = nil
            end,
            replaces_id = widgetData.notificationId,
        }.id
    end
end

local function incBrightness ()
    utils.spawn(app..inc_cmd..computeBrightnessDiff())
    showNotif(getCurBrightness())
end

local function decBrightness ()
    utils.spawn(app..dec_cmd..computeBrightnessDiff())
    showNotif(getCurBrightness())
end

local function registerBrightnessKeys(keys)
  return utils.table.join(
    keys,
    awful.key({ }, inc_key, incBrightness),
    awful.key({ }, dec_key, decBrightness)
  )
end

-- widget to display brightness
-- could be used as a sample about how to create widgets in awesome
local function make_widget(modifiers)
    local widget = wibox.widget {
        {
            min_value = 0,
            max_value = 100,
            value = 0,
            forced_width = 50,
            widget = wibox.widget.progressbar,
            id = 'pb'
        },
        {
            id           = "mytb",
            text         = "100%",
            widget       = wibox.widget.textbox,
        },
        layout = wibox.layout.stack,
        set_battery = function (self, val)
            self.mytb.text = tonumber(val)..'%'
            self.pb.value = tonumber(val)
        end,
    }
    widgetData.widgets[#widgetData.widgets] = widget
    return widget
end

return {
    init=registerBrightnessKeys,
    widget=make_widget,
}
