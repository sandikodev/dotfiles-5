local awful = require("awful")
local json = require("utils.json")

local cmd = "curl https://api.darksky.net/forecast/"..user.darksky_key.."/51.21,33.21?exclude=minutely,hourly,alerts,flags"

awful.widget.watch(cmd, 600, function(w, out)
    local data = json.decode(out)
    local forecast = {
        currently = data.currently,
        daily = data.daily.data
    }
    awesome.emit_signal("evil::weather", forecast)
end)
