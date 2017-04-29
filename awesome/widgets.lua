local naughty = require('naughty')
local wibox = require("wibox")
local vicious = require("vicious")

local function _render_modifiers(modifiers)
  if modifiers ~= nil then
    if type(modifiers) == 'table' then
      result = ''
      for name, value in pairs(modifiers) do
        result = result .. name .. '="' .. value .. '" '
      end
      return result
    elseif type(modifiers) == 'string' then
      return modifiers
    end
  end
  return nil
end

local function _build_component(str, modifiers)
  if type(modifiers) == 'table' then modifiers = _render_modifiers(modifiers) end
  result = '<span'
  if modifiers ~= nil then result = result .. ' ' .. modifiers end
  result = result .. '>' .. str .. '</span>'
  return result
end

local widget_cache = {}
-- Cache widget for more less resource usage
local function _cache_widget(name, fn)
  return function (modifiers)

    cache_name = name
    modifiers = _render_modifiers(modifiers)
    if modifiers ~= nil then
      cache_name = cache_name .. '!@#$' .. modifiers
    end

    if widget_cache[cache_name] == nil then
      widget_cache[cache_name] = fn(modifiers)
    end

    return widget_cache[cache_name]

  end
end


local function ram(modifiers)
  widget = wibox.widget.textbox()
  vicious.register(
    widget,
    vicious.widgets.mem,
    _build_component('Mem: $2M/$3M', modifiers),
    1)
  return widget
end

function battery(modifiers)
  local state = {
    notification=nil,
    notification_text_holder={text='ERROR: widget has not initialized'}}

  widget = wibox.widget.textbox()
  widget:connect_signal("mouse::enter", function ()
    state.notification = naughty.notify{
      text=state.notification_text_holder.text,
      timeout=10000000}
  end)
  widget:connect_signal("mouse::leave", function ()
    if state.notification ~= nil then
      naughty.destroy(state.notification)
      state.notification = nil
    end
  end)
  vicious.register(
    widget,
    vicious.widgets.bat,
    _build_component('$1$2% ', modifiers),
    1,
    "BAT0")
  vicious.register(
    state.notification_text_holder,
    vicious.widgets.bat,
    "$3 left",
    5,
    "BAT0")
  return widget
end

local function timedate(modifiers)
  widget = wibox.widget.textbox()
  vicious.register(
    widget,
    vicious.widgets.date,
    _build_component('%b %d, %R', modifiers))
  return widget
end


return {
  ram=ram,
  battery=battery,
  timedate=timedate}
