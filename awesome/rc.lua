-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local widgets = require('widgets')

require('autostart').init()

local evo = nil

if pcall(function () evo = require('evo') end) then end

naughty.config.defaults.icon_size = 32
naughty.config.defaults.border_width = 0
naughty.config.defaults.font = 'Sans 12'

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(os.getenv('HOME') .. "/.config/awesome/theme/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end}
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({
        "1",
        "2",
        "3",
        "4",
        "5",
        "6",
        "7",
        "8",
        "9",
    }, s, {
        awful.layout.layouts[2],
        awful.layout.layouts[2],
        awful.layout.layouts[2],
        awful.layout.layouts[2],
        awful.layout.layouts[2],
        awful.layout.layouts[2],
        awful.layout.layouts[2],
        awful.layout.layouts[2],
        awful.layout.layouts[2],
    })

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.minimizedcurrenttags, tasklist_buttons)

    if s.index == 1 then
      -- Create the wibox
      s.topbar = awful.wibar{
          position = "top",
          screen = s,
      }

      -- sysystray
      s.systray = wibox.widget.systray()
      s.systray:set_base_size(beautiful.wibar_height * .7)

      -- Add widgets to the wibox
      s.topbar:setup {
          layout = wibox.layout.align.horizontal,
          { -- Left widgets
              layout = wibox.layout.fixed.horizontal,
              s.mytaglist,
              s.mypromptbox,
          },
          s.mytasklist, -- Middle widget
          { -- Right widgets
              layout = wibox.layout.fixed.horizontal,
              mykeyboardlayout,
              widgets.disk_status(),
              widgets.ram(),
              widgets.battery(),
              widgets.separator,
              evo.prom_default(),
              wibox.container.margin(
                s.systray, 2, 2, 4
              ),
              mytextclock,
              s.mylayoutbox,
          },
      }

      -- s.bottombar = awful.wibar {
      --   position = 'left',
      --   screen = s,
      --   bg = '#444',
      --   height = 400,
      --   width = 32,
      --   y = 0,
      --   x = 0,
      -- }
      -- s.bottombar.x = 0
      -- s.bottombar.y = 20
    else
      -- Create the wibox
      s.topbar = awful.wibar{
          position = "left",
          screen = s,
      }

      -- Add widgets to the wibox
      s.topbar:setup {
          layout = wibox.layout.align.horizontal,
          s.mytaglist,
          s.mytasklist, -- Middle widget
          s.mylayoutbox,
      }
    end
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

local function run_lock_screen ()
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper_lock or beautiful.wallpaper
        if type(wallpaper) == 'function' then
            wallpaper = wallpaper(nil)
        end
        awful.util.spawn("i3lock -I 1 -e -i " .. wallpaper .. " -c 000000")
    else
        awful.util.spawn("i3lock -I 1 -e -c 000000")
    end
end

incstatus_collection = {}

IncStatus = {
    DEFAULT_STEP=50,
    INC_STEP=5,
    MAX_STEP=80,
}

function IncStatus:new()
    o = {}
    setmetatable(o, self)
    self.__index = self
    self.calls = 0
    self.step = initial_step or self.DEFAULT_STEP
    incstatus_collection[#incstatus_collection + 1] = o
    return o
end

function IncStatus:get_inc()
    self.calls = self.calls + 1
    return self.step
end

resize_inc_status = IncStatus:new()
move_inc_status = IncStatus:new()

-- {{{ Key bindings
globalkeys = gears.table.join(
        awful.key({ }, "XF86ScreenSaver", function () run_lock_screen() end,
                  {description = 'lock screen', group = 'lockscreen'}),
        awful.key({ modkey }, "t", function () awful.util.spawn(terminal) end),
        awful.key({ modkey }, "l", function () run_lock_screen() end,
                  {description = 'lock screen', group = 'lockscreen'}),

        awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
                  {description="show help", group="awesome"}),

        awful.key({ modkey,           }, "j",   awful.tag.viewprev,
                  {description = "view previous", group = "tag"}),
        awful.key({ modkey,           }, "k",  awful.tag.viewnext,
                  {description = "view next", group = "tag"}),
        awful.key({ modkey,           }, ']', function ()
            local wibar_cur = awful.screen.focused().mywibox
            wibar_cur.visible = not wibar_cur.visible
        end, {}),

        awful.key({ modkey,           }, "Tab",
            function ()
               awful.client.focus.byidx( 1)
            end,
            {description = "focus next by index", group = "client"}
        ),
        awful.key({ modkey, "Shift"   }, "Tab",
            function ()
                awful.client.focus.byidx(-1)
            end,
            {description = "focus previous by index", group = "client"}
        ),
        -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
        --           {description = "show main menu", group = "awesome"}),

        -- client focus manipulation
        awful.key({ modkey, "Mod1"    }, "j", function ()
                awful.client.focus.global_bydirection('down') end,
                {description = "Focus to client at bottom of current", group="client"}),
        awful.key({ modkey, "Mod1"    }, "k", function ()
                awful.client.focus.global_bydirection('up') end,
                {description = "Focus to client at top of current", group="client"}),
        awful.key({ modkey, "Mod1"    }, "h", function ()
                awful.client.focus.global_bydirection('left') end,
                {description = "Focus to client at left of current", group="client"}),
        awful.key({ modkey,  "Mod1"   }, "l", function ()
                awful.client.focus.global_bydirection('right') end,
                {description = "Focus to client at right of current", group="client"}),
        awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
                  {description = "jump to urgent client", group = "client"}),

        -- screen focus manipulation
        awful.key({ modkey,           }, "`", function () awful.screen.focus_relative( 1) end,
                  {description = "focus the next screen", group = "screen"}),
        awful.key({ modkey, "Shift"   }, "`", function () awful.screen.focus_relative(-1) end,
                  {description = "focus the previous screen", group = "screen"}),

        -- Layout manipulation
        awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
                  {description = "swap with next client by index", group = "client"}),
        awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
                  {description = "swap with previous client by index", group = "client"}),

        -- Resizing windows
        awful.key({ modkey, "Control" }, "l", function ()
            if not awful.client.floating.get(client.focus) then awful.tag.incmwfact( 0.05)
            else client.focus:relative_move(0, 0, resize_inc_status:get_inc(), 0) end
            client.focus:raise()
        end, {description = 'resize window inc to left', group = 'resize'}),
        awful.key({ modkey, "Control" }, "h", function ()
            if not awful.client.floating.get(client.focus) then awful.tag.incmwfact(-0.05)
            else awful.client.moveresize(0, 0, -resize_inc_status:get_inc(), 0) end
            client.focus:raise()
        end, {description = 'resize window inc to right', group = 'resize'}),
        awful.key({ modkey, "Control" }, "j", function ()
            if not awful.client.floating.get(client.focus) then awful.client.incwfact( 0.05)
            else awful.client.moveresize(0, 0, 0, resize_inc_status:get_inc()) end
            client.focus:raise()
        end, {description = 'resize window inc to top', group = 'resize'}),
        awful.key({ modkey, "Control" }, "k", function ()
            if not awful.client.floating.get(client.focus) then awful.client.incwfact(-0.05)
            else awful.client.moveresize(0, 0, 0, -resize_inc_status:get_inc()) end
            client.focus:raise()
        end, {description = 'resize window inc to bottom', group = 'resize'}),

        -- Resizing windows
        awful.key({ modkey, "Shift" }, "l", function ()
            if awful.client.floating.get(client.focus) then
                client.focus:relative_move(move_inc_status:get_inc(), 0, 0, 0)
            end
            client.focus:raise()
        end, {description = 'move window to left', group = 'move'}),
        awful.key({ modkey, "Shift" }, "h", function ()
            if awful.client.floating.get(client.focus) then
                client.focus:relative_move(-move_inc_status:get_inc(), 0, 0, 0)
            end
            client.focus:raise()
        end, {description = 'move window to right', group = 'move'}),
        awful.key({ modkey, "Shift" }, "j", function ()
            if awful.client.floating.get(client.focus) then
                client.focus:relative_move(0, move_inc_status:get_inc(), 0, 0)
            end
            client.focus:raise()
        end, {description = 'move window to top', group = 'move'}),
        awful.key({ modkey, "Shift" }, "k", function ()
            if awful.client.floating.get(client.focus) then
                client.focus:relative_move(0, -move_inc_status:get_inc(), 0, 0)
            end
            client.focus:raise()
        end, {description = 'move window to bottom', group = 'move'}),

        -- Standard program
        awful.key({ modkey, "Control" }, "r", awesome.restart,
                  {description = "reload awesome", group = "awesome"}),
        awful.key({ modkey, "Shift"   }, "q", awesome.quit,
                  {description = "quit awesome", group = "awesome"}),

        -- awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
        --           {description = "increase master width factor", group = "layout"}),
        -- awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
        --           {description = "decrease master width factor", group = "layout"}),
        -- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
        --           {description = "increase the number of master clients", group = "layout"}),
        -- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
        --           {description = "decrease the number of master clients", group = "layout"}),
        -- awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
        --           {description = "increase the number of columns", group = "layout"}),
        -- awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
        --           {description = "decrease the number of columns", group = "layout"}),
        awful.key({ modkey,           }, "space", function ()
            awful.layout.inc( 1)
            local current_tag = awful.screen.focused().selected_tag
            for _, client in pairs(current_tag:clients()) do
                client.floating = current_tag.layout.name == 'floating'
                local c = client
                if c.floating and c.type ~= 'desktop' and
                    c.type ~= 'splash' and
                    c.type ~= 'notification' and
                    c.type ~= 'dock' and
                    c.type ~= 'combo' and
                    c.type ~= 'menu' then awful.titlebar.show(c)
                elseif not c.floating then awful.titlebar.hide(c) end
            end
        end,
                  {description = "select next", group = "layout"}),

        awful.key({ modkey,           }, "-", function ()
            local current_tag = awful.screen.focused().selected_tag
            awful.tag.incnmaster(1, current_tag)
            -- current_tag.gap = current_tag.gap - 1
            -- if current_tag.gap <= 0 then current_tag.gap = beautiful.max_gap end
        end, { description = "change gap size", group = "layout"}),
        awful.key({ modkey, "Shift"   }, "-", function ()
            local current_tag = awful.screen.focused().selected_tag
            awful.tag.incnmaster(-1, current_tag)
            -- current_tag.gap = current_tag.gap - 1
            -- if current_tag.gap <= 0 then current_tag.gap = beautiful.max_gap end
        end, { description = "change gap size", group = "layout"}),
        awful.key({ modkey,           }, "=", function ()
            local current_tag = awful.screen.focused().selected_tag
            awful.tag.incncol(1, current_tag)
            -- current_tag.gap = current_tag.gap - 1
            -- if current_tag.gap <= 0 then current_tag.gap = beautiful.max_gap end
        end, { description = "change gap size", group = "layout"}),
        awful.key({ modkey, "Shift"   }, "=", function ()
            local current_tag = awful.screen.focused().selected_tag
            awful.tag.incncol(-1, current_tag)
            -- current_tag.gap = current_tag.gap - 1
            -- if current_tag.gap <= 0 then current_tag.gap = beautiful.max_gap end
        end, { description = "change gap size", group = "layout"}),

        awful.key({ modkey,           }, "0", function ()
            local current_tag = awful.screen.focused().selected_tag
            if current_tag.gap == beautiful.zero_gap then
                current_tag.gap = current_tag.cached_gap or theme.useless_gap
                current_tag.cached_gap = nil
            else
                current_tag.cached_gap = current_tag.gap
                current_tag.gap = beautiful.zero_gap
            end
            local cur_wibox = awful.screen.focused().mywibox
            -- if current_tag.cached_gap == nil then
            --     cur_wibox.opacity = beautiful.wibar_default_opacity
            -- else
            --     cur_wibox.opacity = beautiful.wibar_fill_opacity
            -- end

        end, { description = "change gap size", group = "layout"}),
        awful.key({ modkey, "Shift"   }, "space", function ()
            awful.layout.inc(-1)
            local current_tag = awful.screen.focused().selected_tag
            for _, client in pairs(current_tag:clients()) do
                client.floating = current_tag.layout.name == 'floating'
                local c = client
                if c.floating and c.type ~= 'desktop' and
                    c.type ~= 'splash' and
                    c.type ~= 'notification' and
                    c.type ~= 'dock' and
                    c.type ~= 'combo' and
                    c.type ~= 'menu' then awful.titlebar.show(c)
                elseif not c.floating then awful.titlebar.hide(c) end
            end
        end,
                  {description = "select previous", group = "layout"}),

        awful.key({ modkey, "Control" }, "n",
                  function ()
                      local c = awful.client.restore()
                      -- Focus restored client
                      if c then
                          client.focus = c
                          c:raise()
                      end
                  end,
                  {description = "restore minimized", group = "client"}),

        -- Prompt
        awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
                  {description = "run prompt", group = "launcher"}),

        awful.key({ modkey }, "x",
                  function ()
                      awful.prompt.run {
                        prompt       = "Run Lua code: ",
                        textbox      = awful.screen.focused().mypromptbox.widget,
                        exe_callback = awful.util.eval,
                        history_path = awful.util.get_cache_dir() .. "/history_eval"
                      }
                  end,
                  {description = "lua execute prompt", group = "awesome"}),
        -- Menubar
        awful.key({ modkey }, "p", function() menubar.show() end,
                  {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle ,
        {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "i", function (c)
        naughty.notify{
            title='Client class',
            text="Class: " .. tostring(c.class) .. '\nFloating: ' .. tostring(c.floating)
        }
    end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end
globalkeys = require('brightness').init(globalkeys)

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     titlebars_enabled = true,
     }
    },
    { rule={class = 'Xfce4-terminal'},
      properties = { size_hints_honor = false }},
    { rule={class = 'albert'},
      properties = { border_width = 0 }},

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer",
          "jetbrains-idea"},
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    local not_all_tiled = false
    for _, tag in pairs(c:tags()) do
        if tag.layout.name == 'floating' then
            not_all_tiled = true
            break
        end
    end
    c.floating = not_all_tiled

    if c.floating and c.type ~= 'desktop' and
        c.type ~= 'splash' and
        c.type ~= 'notification' and
        c.type ~= 'dock' and
        c.type ~= 'combo' and
        c.type ~= 'menu' and
        c.class ~= 'albert' then awful.titlebar.show(c)
    elseif not c.floating then awful.titlebar.hide(c) end

    if c.class == 'jetbrains-idea' then
        c.floating = true
        awful.titlebar.hide(c)
    end

    if c.class == 'albert' then
        c.floating = true
        awful.titlebar.hide(c)
    end

end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Right
            awful.titlebar.widget.closebutton    (c),
            awful.titlebar.widget.maximizedbutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        { -- Middle
            { -- Title
                align  = "left",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

function is_charged()
    battery_string = io.popen('acpi'):read('*line')
    return string.match(battery_string, '%s*(10|9)%d%s*') ~= nil
end

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}
