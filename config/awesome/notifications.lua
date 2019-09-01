local beautiful = require("beautiful")
local naughty = require("naughty")
local awful = require("awful")

local battery_low_notified = false
local battery_critical_level = 20 -- Percents

-- Store notification objects to be able to replace notificaions
local layout_notification
local volume_notification
local brightness_notification
local governor_notification

naughty.config.padding = beautiful.notification_padding
naughty.config.spacing = beautiful.notification_spacing
naughty.config.defaults.margin = beautiful.notification_margin

naughty.config.presets.critical = {
    bg = beautiful.notification_bg_critical,
    fg = beautiful.notification_fg_critical,
    timeout = 0
}

-- Show notificaion when battery charger plugged
awesome.connect_signal("evil::charger", function(plugged, is_initial)
    if not is_initial and plugged then
        naughty.notify({
            text = "Battery is charging.",
            icon = beautiful.icon_battery,
            icon_size = beautiful.notification_icon_size
        })
    end
end)

-- Notify when battery reaches critical level
awesome.connect_signal("evil::battery", function(value)
    if value <= battery_critical_level and not battery_low_notified then
        naughty.notify({
            title = "Battery is low",
            text = "Please, plug the charger.",
            timeout = 0,
            icon = beautiful.icon_battery,
            icon_size = beautiful.notification_icon_size
        })
        battery_low_notified = true
    elseif value > battery_critical_level and battery_low_notified then
        battery_low_notified = false
    end
end)

-- Volume notificaion
awesome.connect_signal("volume::update", function(volume, mute, skip_notification)
    if not skip_notification then
        local out = mute and "Mute" or tostring(volume).."%"
        local replace_id = volume_notification and volume_notification.id or nil
        local notification_icon = mute and beautiful.icon_muted or beautiful.icon_volume
        volume_notification = naughty.notify({
            text = out,
            replaces_id = replace_id,
            icon = notification_icon,
            icon_size = beautiful.notification_icon_size,
            timeout = 3
        })
    end
end)

awesome.connect_signal("evil::brightness", function(brightness, skip_notification)
    if not skip_notification then
        local replace_id = brightness_notification and brightness_notification.id or nil
        local text = tostring(math.floor(brightness)).."%"
        brightness_notification = naughty.notify({
            text = text,
            replaces_id = replace_id,
            icon = beautiful.icon_brightness,
            icon_size = beautiful.notification_icon_size,
            timeout = 3
        })
    end
end)

-- Notify changed layout
-- tag.connect_signal("property::layout", function()
--     local replace_id = layout_notification and layout_notification.id or nil
--     local layout_name = awful.layout.getname(awful.layout.get(awful.screen.focused()))
--     if not awesome.startup then
--         layout_notification = naughty.notify({
--             title = "Layout",
--             text = layout_name,
--             replaces_id = replace_id,
--             timeout = 3,
--             icon = beautiful.icon_layout,
--             icon_size = beautiful.notification_icon_size
--         })
--     end
-- end)

-- Notify when CPU governor changed
awesome.connect_signal("cpu::governor", function(governor, skip_notification)
    if not skip_notification then
        local replace_id = governor_notification and governor_notification.id or nil
        local notification_icon = beautiful.icon_sysload
        if governor == "performance" then notification_icon = beautiful.icon_temperature end
        governor_notification = naughty.notify({
            title = "CPU governor",
            text = governor,
            replaces_id = replace_id,
            icon = notification_icon,
            icon_size = beautiful.notification_icon_size
        })
    end
end)
