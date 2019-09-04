local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")

local helpers = {}

function helpers.colorize_text(txt, fg)
    return "<span foreground='" .. fg .."'>" .. txt .. "</span>"
end

function helpers.get_volume_info(callback)
    awful.spawn.easy_async_with_shell("pactl list sinks | grep -e Volume -e Mute",
        function(stdout)
            local volume = stdout:match('(%d+)%% /')
            local muted = stdout:match('Mute:%s+(yes)')
            if muted then
                callback(tonumber(volume), true)
            else
                callback(tonumber(volume), false)
            end
        end
    )
end

local volume_step = 3
function helpers.volume_control(option)
    helpers.get_volume_info(function(vol, mute)
        local cmd -- Command to execute
        local next_volume = vol
        local next_mute = mute

        if option == "toggle" then
            cmd = "pactl set-sink-mute @DEFAULT_SINK@ toggle"
            -- Volume is muted corrently, but will be toggled
            next_mute = not mute
        elseif option == "up" then
            next_volume = vol + volume_step
            if next_volume >= 100 then -- DO NOT ROCK THE HOUSE!
                cmd = "pactl set-sink-volume @DEFAULT_SINK@ 100%"
                next_volume = 100
            else
                cmd = "pactl set-sink-volume @DEFAULT_SINK@ +"..volume_step.."%"
            end
            if mute then
                cmd = "pactl set-sink-mute @DEFAULT_SINK@ 0 && "..cmd
            end
            next_mute = false
        elseif option == "down" then
            cmd = "pactl set-sink-volume @DEFAULT_SINK@ -"..volume_step.."%"
            next_volume = vol - volume_step
            if next_volume <= 0 then
                next_volume = 0
            end
            if mute then
                cmd = "pactl set-sink-mute @DEFAULT_SINK@ 0 && "..cmd
            end
            next_mute = false
        end

        awful.spawn.with_shell(cmd)
        awesome.emit_signal("volume::update", next_volume, next_mute, false)
    end)
end

function helpers.get_weather_icon(icon)
    if icon == "clear-day" then
        return beautiful.weather_sun
    elseif icon == "clear-night" then
        return beautiful.weather_moon
    elseif icon == "rain" then
        return beautiful.weather_rain
    elseif icon == "cloudy" then
        return beautiful.weather_cloudy
    elseif icon == "snow" then
        return beautiful.weather_snow
    elseif icon == "sleet" then
        return beautiful.weather_sleet
    elseif icon == "wind" then
        return beautiful.weather_wind
    elseif icon == "fog" then
        return beautiful.weather_fog
    elseif icon == "partly-cloudy-day" then
        return beautiful.weather_cloudy_day
    elseif icon == "partly-cloudy-night" then
        return beautiful.weather_cloudy_night
    elseif icon == "hail" then
        return beautiful.weather_hail
    elseif icon == "thunderstorm" then
        return beautiful.weather_thunderstorm
    elseif icon == "tornado" then
        return beautiful.weather_tornado
    end
end

function helpers.farenheit_to_celsius(farenheit)
    local celsius = (farenheit - 32) * 5 / 9
    return math.ceil(celsius)
end

-- Rectangle with rounded borders shape
helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

return helpers
