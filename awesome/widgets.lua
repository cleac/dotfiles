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
  if colorize_cache[str] == nil then
    colorize_cache[str] = colorSet[math.random(#colorSet)]
  end
  return '<span font="Source Code Pro 10" color="' .. colorize_cache[str] .. '">' .. str .. '</span>'
end

local function label_wrap(label_text, func)
  local caption = wibox.widget.textbox('<span font="Source Code Pro 10">' .. label_text .. '</span>')

  return function ()
    return wibox.widget {
      -- wibox.widget.textbox('|')
      wibox.container.margin(caption, 8, 2, 0),
      wibox.container.margin(func(), 2, 4, 0),
      -- wibox.widget.textbox('|'),
      layout = wibox.layout.align.horizontal,
    }
  end
end

-- }}}

-- {{{ RAM widget

local ram = label_wrap(
  'ram',
  function ()
   local widget = wibox.widget.textbox()
   vicious.register(
     widget,
     vicious.widgets.mem,
     '$1%',
     5)
   return widget
  end
)
-- }}}

-- {{{ Battery widget

local battery_percent = label_wrap(
  'bat',
  function ()
      local sent_notification = false
    local widget = wibox.widget.textbox()
    vicious.register(
      widget,
      vicious.widgets.bat,
      function (w, status)
          if status[2] < 10 then
              if not sent_notification then
                  naughty.notify{
                      title   = 'Battery is critically low',
                      text    = 'There is ' .. status[3] .. ' left',
                      timeout = 2,
                      ontop   = true,
                  }
                  sent_notification = true
              end
              return '<span color="#F77">' .. tostring(status[2]) .. '%</span>'
          else
              sent_notification = false
              return tostring(status[2]) .. '%'
          end
      end,
      5,
      "BAT0")
    return widget
  end)

local battery_left = label_wrap(
  '',
  function ()
    local widget = wibox.widget.textbox()
    vicious.register(
      widget,
      vicious.widgets.bat,
      '$3',
      5,
      "BAT0")
    return widget
  end)


function battery()
  return battery_percent()
end

-- }}}

-- {{{ Timedate widget

local function timedate()
 local widget = wibox.widget.textbox()
 vicious.register(
  widget,
  vicious.widgets.date,
  _colorize('Date: ') .. '%b %d ' .. _colorize(' Time: ') .. ' %R')
 return widget
end

local function vpn_status()
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
      return(status_str)
    end,
    5
  )
  return widget
end

local disk_status = label_wrap(
  'hom',
  function ()
    local state = {
      disk = '/home',
      widget = wibox.widget.textbox(),
    }
    -- state.size_key = '{' .. state.disk .. ' size_gb}'
    -- state.used_key = '{' .. state.disk .. ' used_gb}'
    state.used_p_key = '{' .. state.disk .. ' used_p}'
    vicious.register(
      state.widget,
      vicious.widgets.fs,
      function (w, data)
        return data[state.used_p_key] .. '%'
      end,
      5)
    return state.widget
  end)


local cpu_status = label_wrap(
  'cpu',
  function ()
    local widget = wibox.widget.textbox()
    vicious.register(
      widget,
      vicious.widgets.cpu,
      "$1%",
      5)
    return widget
  end)

local cpu_freq = label_wrap(
  'cpufreq',
  function ()
    local widget = wibox.widget.textbox()
    vicious.register(
      widget,
      vicious.widgets.cpufreq,
      function(w, arg)
        return tostring(math.floor(arg[2] * 10) / 10) .. "GHz"
      end,
      5,
      'cpu0')
    return widget
  end)

-- }}}

-- }}}

-- Music player widget {{{

function cmus_client ()
  local music_text = wibox.widget.textbox()
  music:set_markup("Couldn't connect to cmus server")
end

-- }}}

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
      state.widget:set_markup(state.label .. addText)
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
separator:set_markup(' ')

return {
 ram=ram,
 battery=battery,
 timedate=timedate,
 vpn_status=vpn_status,
 disk_status=disk_status,
 separator=separator,
 timer=timer,
 cpu=cpu_status,
 cpufreq=cpu_freq,
 _label_wrap=label_wrap
}
