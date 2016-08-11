local awful = require("awful")
local wibox = require("wibox")

local test = wibox.widget.base.make_widget()
test.fit = function(test, width, height)
       local size = math.min(width, height)
       return size, size
end
test.draw = function( test, wibox, cr, width, height )
       cr:move_to(0, 0)
       cr:line_to(width, height)
       cr:move_to(width, 0)
       cr:line_to(0, height)
       cr:set_line_width(3)
       cr:stroke()
	-- body
end