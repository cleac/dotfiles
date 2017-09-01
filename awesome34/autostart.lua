local awful = require('awful')
local sh_interpreter = 'sh '
local autostart_file_source = '~/.config/awesome/autostart '

local function invoke()
  awful.util.spawn_with_shell(sh_interpreter .. autostart_file_source)
end

return {init=invoke}
