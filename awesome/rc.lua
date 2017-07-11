-- Placement of config
local CONFIG_PATH = os.getenv('HOME') .. "/.config/awesome"
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
require("errors")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")

local brightness = require("brightness")
local autostart = require("autostart")
local display = require("display")

local widgets = require("widgets")

autostart.init()

beautiful.init(CONFIG_PATH.."/themes/cleac/theme.lua")

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
   screen_names = { '1: 😄' ,'2: >_', '3: 🔥', '4: 🐍', },
   layout_configs = {layouts[2], layouts[2], layouts[2], layouts[2]}
}
for s = 1, screen.count() do
   -- Each screen has its own tag table.
   tags[s] = awful.tag(tags.screen_names, s, tags.layout_configs)
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
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
left_sep = wibox.widget.textbox()
end_sep = wibox.widget.textbox()

sep:set_markup('<span font="Product Sans 11">'..awful.util.escape('>> <<')..'</span>')
end_sep:set_markup('<span font="Product Sans 11">'..awful.util.escape(' <<')..'</span>')
left_sep:set_markup('<span font="Product Sans 11">'..awful.util.escape(' >> ')..'</span>')

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
   -- mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

   -- Create the wibox
   mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })

   -- Widgets that are aligned to the left
   local middle_layout = wibox.layout.fixed.horizontal()
   middle_layout:add(mytaglist[s])

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
   right_layout:add(widgets.timedate{font='Fira Code 8.5'})
   right_layout:add(sep)
   right_layout:add(widgets.battery{font='Fira Code 8.5'})

   local left_layout = wibox.layout.fixed.horizontal()
   left_layout:add(widgets.ram{font='Fira Code 8.5'})
   left_layout:add(left_sep)
   left_layout:add(mypromptbox[s])


   local layout = wibox.layout.align.horizontal()
   layout:set_middle(middle_layout)
   layout:set_left(left_layout)
   layout:set_right(right_layout)

   mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
   awful.button({ }, 3, function ()  end),
   awful.button({ }, 4, awful.tag.viewnext),
   awful.button({ }, 5, awful.tag.viewprev)
))
  -- }}}

local lock_screen_command = "xscreensaver-command -lock" -- TODO: find another appliable screensaver

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ }, "XF86Sleep", function ()
      awful.util.spawn(lock_screen_command)
      os.execute("sleep 2")
      awful.util.spawn("systemctl hybrid-sleep")
    end),
    awful.key({ }, "XF86ScreenSaver", function ()
      awful.util.spawn(lock_screen_command)
    end),
    awful.key({ modkey }, "F12", function ()
      awful.util.spawn(lock_screen_command)
    end),

    awful.key({ modkey,           }, "h",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "l",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx(1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Shift"   }, "Tab", function () awful.screen.focus_relative( 1) end),
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

    -- TODO Implement resizing of floating windows using shortcuts
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Control" }, "j",     function () awful.client.incwfact( 0.05)    end),
    awful.key({ modkey, "Control" }, "k",     function () awful.client.incwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Shift" }, "j",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Shift" }, "k",     function () awful.tag.incncol(-1)         end),
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
globalkeys = brightness.init(globalkeys)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "q",      function (c) c:kill()                         end),
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
   awful.key({}, "XF86Display", display.xrandr))

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
        local layout = wibox.layout.align.horizontal() layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

-- }}}
