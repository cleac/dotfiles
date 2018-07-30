local os = os
local awful = require('awful')
local sh_interpreter = '/bin/bash '
local autostart_file_source = os.getenv('HOME') .. '/.config/awesome/autostart '
local home_root_file_source = os.getenv('HOME') .. '/.autostart'

local function invoke()
  awful.util.spawn_with_shell(sh_interpreter .. autostart_file_source)
  awful.util.spawn_with_shell(sh_interpreter .. home_root_file_source)
end

return {init=invoke}
