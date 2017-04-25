-- Placement of config
local CONFIG_PATH = "/home/anesterenko/.config/awesome"
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")

HOME_DIR = '/home/cleac/.config/awesome/'

do
  local cmds = {
    HOME_DIR.."/run_once blueman-applet",
    HOME_DIR.."/run_once nm-applet",
    "xrandr --output HDMI1 --left-of VGA1",
    "slack &",
    "~/Downloads/Telegram/Telegram &",
    "xscreensaver -nosplash &"
  }

  for _,cmd in pairs(cmds) do
    awful.util.spawn_with_shell(cmd)
  end
end

  -- Initialize memory widget
  memwidget = wibox.widget.textbox()
  -- Register memory widget
  vicious.register(memwidget, vicious.widgets.mem, '<span font="'..'Product Sans 8.5'..'">Mem: $2M/$3M</span>', 1)

  -- Initialaze battery widget
  batwidget = wibox.widget.textbox()
  batwidget:connect_signal("mouse::enter", function ()
      left_storage.notif = naughty.notify({ text=left_storage.text, timeout=10000000 })
  end)
  batwidget:connect_signal("mouse::leave", function ()
      if left_storage.notif ~= nil then
          naughty.destroy(left_storage.notif)
          left_storage.notif = nil
      end
  end)
  left_storage = {}
  vicious.register(batwidget, vicious.widgets.bat, '<span font="'..'Product Sans 8.5'..'">$1$2% </span>', 1, "BAT0")
  vicious.register(left_storage, vicious.widgets.bat, "$3 left", 1, "BAT0")

  uptimewidget = wibox.widget.textbox()

  local tmdwidgt_data = {}
  timedatewidget = wibox.widget.textbox()
  timedatewidget:connect_signal("mouse::enter", function ()
      -- TODO: Write more flexible way to display calendar
      os.execute('cal > ~/.tmp')
      local fp = io.open('/home/cleac/.tmp', 'rb')
      if fp == nil then
          return -1
      end
      io.input(fp)
      local data = io.read("*a")
      fp:close()
      os.execute('rm ~/.tmp')
      tmdwidgt_data.notification = naughty.notify({ text = data })
  end)
  timedatewidget:connect_signal("mouse::leave", function ()
      if tmdwidgt_data.notification ~= nil then
          naughty.destroy(tmdwidgt_data.notification)
          tmdwidgt_data.notification = nil
      end
  end)
  vicious.register(timedatewidget, vicious.widgets.date, '<span font="'..'Product Sans 8.5'..'">%b %d, %R</span>')

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
                           text = err })
          in_error = false
      end)
  end
  -- }}}

 -- {{{ Display configurations

  -- Get active outputs
  local function outputs()
     local outputs = {}
     local xrandr = io.popen("xrandr -q")
     if xrandr then
        for line in xrandr:lines() do
     output = line:match("^([%w-]+) connected ")
     if output then
        outputs[#outputs + 1] = output
     end
        end
        xrandr:close()
     end

     return outputs
  end


  local function arrange(out)
     -- We need to enumerate all the way to combinate output. We assume
     -- we want only an horizontal layout.
     local choices  = {}
     local previous = { {} }
     for i = 1, #out do
        -- Find all permutation of length `i`: we take the permutation
        -- of length `i-1` and for each of them, we create new
        -- permutations by adding each output at the end of it if it is
        -- not already present.
        local new = {}
        for _, p in pairs(previous) do
     for _, o in pairs(out) do
        if not awful.util.table.hasitem(p, o) then
           new[#new + 1] = awful.util.table.join(p, {o})
        end
     end
        end
        choices = awful.util.table.join(choices, new)
        previous = new
     end

     return choices
  end

  -- Build available choices
  local function menu()
     local menu = {}
     local out = outputs()
     local choices = arrange(out)

     for _, choice in pairs(choices) do
        local cmd = "xrandr"
        -- Enabled outputs
        for i, o in pairs(choice) do
     cmd = cmd .. " --output " .. o .. " --auto"
     if i > 1 then
        cmd = cmd .. " --above " .. choice[i-1]
     end
        end
        -- Disabled outputs
        for _, o in pairs(out) do
     if not awful.util.table.hasitem(choice, o) then
        cmd = cmd .. " --output " .. o .. " --off"
     end
        end

        local label = ""
        if #choice == 1 then
     label = 'Only <span weight="bold">' .. choice[1] .. '</span>'
        else
     for i, o in pairs(choice) do
        if i > 1 then label = label .. " + " end
        label = label .. '<span weight="bold">' .. o .. '</span>'
     end
        end

        menu[#menu + 1] = { label,
          cmd,"/usr/share/icons/Tango/32x32/devices/display.png"}
     end

     return menu
  end

  -- Display xrandr notifications from choices
  local state = { iterator = nil,
      timer = nil,
      cid = nil }
  local function xrandr()
     -- Stop any previous timer
     if state.timer then
        state.timer:stop()
        state.timer = nil
     end

     -- Build the list of choices
     if not state.iterator then
        state.iterator = awful.util.table.iterate(menu(),
            function() return true end)
     end

     -- Select one and display the appropriate notification
     local next  = state.iterator()
     local label, action, icon
     if not next then
        label, icon = "Keep the current configuration", "/usr/share/icons/Tango/32x32/devices/display.png"
        state.iterator = nil
     else
        label, action, icon = unpack(next)
     end
     state.cid = naughty.notify({ text = label,
          icon = icon,
          timeout = 4,
          screen = mouse.screen, -- Important, not all screens may be visible
          font = "Free Sans 18",
          replaces_id = state.cid }).id

     -- Setup the timer
     state.timer = timer { timeout = 4 }
     state.timer:connect_signal("timeout",
          function()
             state.timer:stop()
             state.timer = nil
             state.iterator = nil
             if action then
                awful.util.spawn(action, false)
                -- {{{ Wallpaper
                if beautiful.wallpaper then
                    for s = 1, screen.count() do
                        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
                    end
                end
                -- }}}
             end
          end)
     state.timer:start()
  end

 --}}}


  -- {{{ Variable definitions
  -- Themes define colours, icons, font and wallpapers.
  beautiful.init(CONFIG_PATH.."/themes/cleac/theme.lua")

  -- This is used later as the default terminal and editor to run.
  terminal = "konsole"
  editor = os.getenv("EDITOR") or "vim"
  editor_cmd = terminal .. " -e " .. editor

  -- Default modkey.
  -- Usually, Mod4 is the key with a logo between Control and Alt.
  -- If you do not like this or do not have such a key,
  -- I suggest you to remap Mod4 to another key using xmodmap or other tools.
  -- However, you can use another modifier like Mod1, but it may interact with others.
  modkey = "Mod4"

  -- Table of layouts to cover with awful.layout.inc, order matters.
  local layouts =
  {
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
      awful.layout.suit.magnifier
  }
  -- }}}

  -- {{{ Wallpaper
  if beautiful.wallpaper then
      for s = 1, screen.count() do
          gears.wallpaper.maximized(beautiful.wallpaper, s, true)
      end
  end
  -- }}}

  -- {{{ Tags
  -- Define a tag table which hold all screen tags.
  tags = {
      screen_names = { '• ' ,'•', '•', '•', '•', '•',   },
      layout_configs = {layouts[2], layouts[2], layouts[2], layouts[2], layouts[2], layouts[2]}
  }
  for s = 1, screen.count() do
      -- Each screen has its own tag table.
      tags[s] = awful.tag(tags.screen_names, s, tags.layout_configs)
  end
  -- }}}

  -- {{{ Menu
  -- Create a laucher widget and a main menu
  myawesomemenu = {
     { "manual", terminal .. " -e man awesome" },
     { "edit config", editor_cmd .. " " .. awesome.conffile },
     { "restart", awesome.restart },
     { "quit", awesome.quit }
  }


  mymainmenu = awful.menu({
    items = {
      { "awesome", myawesomemenu, beautiful.awesome_icon },
      { "open terminal", terminal }
    }
  })


  -- Menubar configuration
  menubar.utils.terminal = terminal -- Set the terminal for applications that require it
  -- }}}

  -- {{{ Wibox
  -- Create a textclock widget
  mytextclock = awful.widget.textclock()

  -- Create a wibox for each screen and add it
  mywibox = {}
  mypromptbox = {}
  mylayoutbox = {}
  mytaglist = {}
  mytaglist.buttons = awful.util.table.join(
                      awful.button({ }, 1, awful.tag.viewonly),
                      awful.button({ modkey }, 1, awful.client.movetotag),
                      awful.button({ }, 3, awful.tag.viewtoggle),
                      awful.button({ modkey }, 3, awful.client.toggletag),
                      awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                      awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                      )
  mytasklist = {}
  mytasklist.buttons = awful.util.table.join(
                       awful.button({ }, 1, function (c)
                                                if c == client.focus then
                                                    c.minimized = true
                                                else
                                                    -- Without this, the following
                                                    -- :isvisible() makes no sense
                                                    c.minimized = false
                                                    if not c:isvisible() then
                                                        awful.tag.viewonly(c:tags()[1])
                                                    end
                                                    -- This will also un-minimize
                                                    -- the client, if needed
                                                    client.focus = c
                                                    c:raise()
                                                end
                                            end),
                       awful.button({ }, 3, function ()
                                                if instance then
                                                    instance:hide()
                                                    instance = nil
                                                else
                                                    instance = awful.menu.clients({
                                                        theme = { width = 250 }
                                                    })
                                                end
                                            end),
                       awful.button({ }, 4, function ()
                                                awful.client.focus.byidx(1)
                                                if client.focus then client.focus:raise() end
                                            end),
                       awful.button({ }, 5, function ()
                                                awful.client.focus.byidx(-1)
                                                if client.focus then client.focus:raise() end
                                            end))

  sep = wibox.widget.textbox()
  end_sep = wibox.widget.textbox()

  sep:set_markup('<span font="Product Sans 11">'..awful.util.escape('>> <<')..'</span>')
  end_sep:set_markup('<span font="Product Sans 11">'..awful.util.escape(' <<')..'</span>')

  for s = 1, screen.count() do
      -- Create a promptbox for each screen
      mypromptbox[s] = awful.widget.prompt()
      -- Create an imagebox widget which will contains an icon indicating which layout we're using.
      -- We need one layoutbox per screen.
      mylayoutbox[s] = awful.widget.layoutbox(s)
      mylayoutbox[s]:buttons(awful.util.table.join(
                             awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                             awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                             awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                             awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
      -- Create a taglist widget
      mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons, {
              font = 'Product Sans',
              squares_resize = true,
          })

      -- Create a tasklist widget
      mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

      -- Create the wibox
      mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })

      -- Widgets that are aligned to the left
      local middle_layout = wibox.layout.fixed.horizontal()
      middle_layout:add(mytaglist[s])
      -- left_layout:add(mypromptbox[s])

      -- Widgets that are aligned to the right
      local right_layout = wibox.layout.fixed.horizontal()
      if s == 1 then
          systray = wibox.widget.systray()
          systray:set_base_size(16)
          right_layout:add(systray)
          right_layout:add(end_sep)
      end
      -- right_layout:add(memwidget)
      -- right_layout:add(sep)
      right_layout:add(timedatewidget)
      right_layout:add(sep)
      right_layout:add(batwidget)

      local left_layout = wibox.layout.fixed.horizontal()
      left_layout:add(memwidget)

      -- right_layout:add(mytextclock)
      -- right_layout:add(mylayoutbox[s])

      local layout = wibox.layout.align.horizontal()
      layout:set_middle(middle_layout)
      layout:set_left(left_layout)
      layout:set_right(right_layout)

      mywibox[s]:set_widget(layout)
  end
  -- }}}

  -- {{{ Mouse bindings
  root.buttons(awful.util.table.join(
      awful.button({ }, 3, function () mymainmenu:toggle() end),
      awful.button({ }, 4, awful.tag.viewnext),
      awful.button({ }, 5, awful.tag.viewprev)
  ))
  -- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  -- Sleep and lock command
    awful.key({ }, "XF86Sleep", function ()
      awful.util.spawn("xscreensaver-command -lock")
      os.execute("sleep 2")
      awful.util.spawn("systemctl hybrid-sleep")
  	 end),
    -- Sleep command
    awful.key({ }, "XF86ScreenSaver", function ()
      awful.util.spawn("xscreensaver-command -lock")
    end),
    awful.key({ modkey }, "F12", function ()
      awful.util.spawn("xscreensaver-command -lock")
    end),
    awful.key({ modkey,  }, "e", function()
    awful.util.spawn("krusader") end),
    awful.key({ modkey,  }, "t", function()
  awful.util.spawn(terminal) end),
    awful.key({ modkey,  }, "b", function()
  awful.util.spawn("firefox") end),

    awful.key({ }, "XF86MonBrightnessDown", function ()
        awful.util.spawn("xbacklight -dec 5") end),
    awful.key({ }, "XF86MonBrightnessUp", function ()
        awful.util.spawn("xbacklight -inc 5") end),

    awful.key({ modkey,           }, "h",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "р",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "l",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "д",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "Tab", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
       function ()
           awful.client.focus.history.previous()
           if client.focus then
               client.focus:raise()
           end
       end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-2)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "F4",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Alt"     }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey }, "]", function ()
                mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
            end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

globalkeys = awful.util.table.join(
   globalkeys,
   awful.key({}, "XF86Display", xrandr))

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
                     size_hints_honor = false } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "google-chrome" },
      properties = { tag = tags[1][1] }},
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = true
    if titlebars_enabled and (c.floating or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
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

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)


-- }}}
