-- {{{ Imports

-- Standart awesome library
local naughty = require('naughty')
local wibox = require("wibox")
local vicious = require("vicious")

-- For awesome-client to work properly
require('awful.remote')

-- }}}

-- {{{ Utility functions
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
  local result = '<span'
  if modifiers ~= nil then result = result .. ' ' .. modifiers end
  result = result .. '>' .. str .. '</span>'
  return result
end

local colorize_cache = {}

local colorSet = {
    '#e5fc99',
    '#b4fc99',
    '#fce299',
    '#b299fc',
    '#99e3fc',
    '#99b2fc',
    '#fc99fa',
}

local function _colorize(str)
  if colorize_cache[str] == nil then colorize_cache[str] = colorSet[math.random(#colorSet)] end
  return '<span color="' .. colorize_cache[str] .. '">' .. str .. '</span>'
end

-- }}}

-- {{{ RAM widget

local function ram(modifiers)
  local widget = wibox.widget.textbox()
  vicious.register(
    widget,
    vicious.widgets.mem,
    _build_component(_colorize('Mem:') .. ' $2M/$3M', modifiers),
    1)
  return widget
end
-- }}}

-- {{{ Battery widget

function battery(modifiers)
  local state = {
    notification=nil,
    notification_text_holder={text='ERROR: widget has not initialized'}}

  local widget = wibox.widget.textbox()
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
    _build_component(_colorize('Battery: ') .. '$1$2%  ' .. _colorize('Left: ') .. '$3', modifiers),
    1,
    "BAT0")
  vicious.register(
    state.notification_text_holder,
    vicious.widgets.bat,
    _colorize('Battery:') .. ' $3 left', 5,
    "BAT0")
  return widget
end

-- }}}

-- {{{ Timedate widget

local function timedate(modifiers)
  local widget = wibox.widget.textbox()
  vicious.register(
    widget,
    vicious.widgets.date,
    _build_component(_colorize('Date: ') .. '%b %d ' .. _colorize('  Time: ') .. ' %R', modifiers))
  return widget
end

local function vpn_status(modifiers)
    local widget = wibox.widget.textbox()
    widget:connect_signal('mouse::enter', function ()
        awful.spawn('nm-connection-editor')
    end)
    vicious.register(
        widget,
        vicious.widgets.net,
        function (w, status)
            status_str = _colorize('Wi-Fi: ')
            if status['{wlp2s0 carrier}'] ~= nil then status_str = status_str .. 'connected' end
            if status['{tun0 carrier}'] ~= nil then status_str = status_str .. _colorize('<sub>vpn</sub>') end
            return _build_component(status_str)
        end,
        5
    )
    return widget
end

local function disk_status(modifiers)
    local disk = '/home'
    local widget = wibox.widget.textbox()
    local size_key = '{' .. disk .. ' size_mb}'
    local used_key = '{' .. disk .. ' used_mb}'
    vicious.register(
      widget,
      vicious.widgets.fs,
      function (w, data)
          return _build_component(_colorize('Disk: ') .. data[used_key] .. 'M/' .. data[size_key] .. 'M', modifiers)
      end)
    return widget
end

-- }}}

-- Music player widget {{{

function cmus_client ()
    local music_text = wibox.widget.textbox()
    music:set_markup("Couldn't connect to cmus server")
end

-- }}}

local separator = wibox.widget.textbox()
separator:set_markup('  ')

return {
  ram=ram,
  battery=battery,
  timedate=timedate,
  vpn_status=vpn_status,
  disk_status=disk_status,
  separator=separator,
}
