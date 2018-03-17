-- {{{ Imports

-- Standart awesome library
local naughty = require('naughty')
local wibox = require("wibox")
local vicious = require("vicious")
local gears = require("gears")
local math = require("math")

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
  vicious.register(
    widget,
    vicious.widgets.bat,
    _build_component(_colorize('Battery: ') .. '$1$2%  ' .. _colorize('Left: ') .. '$3', modifiers),
    1,
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
    local size_key = '{' .. disk .. ' size_gb}'
    local used_key = '{' .. disk .. ' used_gb}'
    vicious.register(
      widget,
      vicious.widgets.fs,
      function (w, data)
          return _build_component(_colorize('Disk: ') .. data[used_key] .. '/' .. data[size_key], modifiers)
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
--
-- {{{ Timer widget

local function formatTime (moment)
    local seconds = moment % 60
    local moment = math.floor((moment - seconds) / 60)
    local minutes = moment % 60
    local hours = math.floor((moment - minutes) / 60)
    return tostring(hours) .. ':' ..
        tostring(minutes) .. ':' ..
        tostring(seconds)
end

local function timer()

    local state = {
        timerTimeout = 60 * 60, -- AN HOUR
        currentMoment = 0,
        enabled = false,
        label = _colorize('Timer: '),
        renderText = function (signal, state)
            local addText
            if signal == 'step' then
                if state.ignoreStep then
                    state.ignoreStep = false
                    return;
                end
                if state.enabled then
                    addText = formatTime(state.timerTimeout - state.currentMoment)
                else
                    addText = 'DISABLED'
                end
            elseif signal == 'less_time' then
                state.timerTimeout = math.max(
                    state.timerTimeout - 5 * 60, 5 * 60)
                addText = formatTime(state.timerTimeout)
            elseif signal == 'more_time' then
                state.timerTimeout = state.timerTimeout + 5 * 60
                addText = formatTime(state.timerTimeout)
            end
            state.widget:set_markup(
                _build_component(state.label .. addText))
        end,
        finish = function (state)
            state.enabled = false
            state.currentMoment = 0
            state.ignoreStep = false
        end,
        start = function (state)
            state.enabled = true
        end,
        updateTimerView = function (state)
            if state.currentMoment + 1 >= state.timerTimeout then
                naughty.notify {
                    title='Timer has exceeded',
                    text='It is time to have some rest',
                    timeout=2,
                }
                state.finish(state)
            end
            if state.enabled then
                state.currentMoment = state.currentMoment + 1
            end
            state.renderText('step', state)
        end,
    }

    state.timer = gears.timer {
        timeout = 1,
        autostart = true,
        callback = function () state.updateTimerView(state) end,
    }

    state.widget = wibox.widget.textbox()
    state.renderText('step', state)

    state.widget:connect_signal(
        'button::press',
        function (wdg, x, y, btn)
            if btn == 1 then
                if state.enabled then
                    state.finish(state)
                else
                    state.start(state)
                end
                state.renderText('step', state)
            elseif btn == 4 then
                state.renderText('more_time', state)
                state.ignoreStep = true
            elseif btn == 5 then
                state.renderText('less_time', state)
                state.ignoreStep = true
            end
        end
    )

    return state.widget
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
  timer=timer,
}
