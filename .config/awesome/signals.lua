-- signals

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- why do i need to do this here but the scripts_dir variable from rc.lua carries over?
beautiful.init("/home/lily/.config/awesome/theme.lua")

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    -- this makes floating windows stay on top, i think.
    if c.class ~= "PCSX2" then
        -- i need to specify not pcsx2 here bc the window is really annoying in tiling layouts
        if c.floating then
            c.ontop = true
        end
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
-- im leaning towards not using titlebars i should just yeet this section
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                margins = 10,
                widget = wibox.container.margin,
                align  = "left",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            margins = 10,
            marginwidget = wibox.container.margin,
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal,
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- this is the reason im leaning towards not using titlebars
-- (there are more reasons i just like this)
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    awful.util.spawn_with_shell(scripts_dir .. "workspaces.sh")
end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- make client square when entering fullscreen, return to rounded corners when leaving
client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        c:set_shape(gears.shape.rect)
    else
        c:set_shape(function(cr, width, height)
            gears.shape.rounded_rect(cr, width, height, 15)
        end)
    end
end)

-- this signal replaces spotify's rule bc spotify's a lil bitch baby
client.connect_signal("property::class", function(c)
    if c.class == "Spotify" then
        tag = 2
        c:move_to_tag(root.tags()[tag])
-- i wanted to move all of the rules here and have them work like the spotify case above and use
-- the spawn command below but that kinda broke after a restart and i've reverted back to regular
-- rules. i realise while typing this that the other windows probably don't emit the property::class
-- signal which may explain why it fell apart
--  elseif c.class == "firefox" then
--      tag = 6
--      c:move_to_screen(root.tags()[tag].screen+1)
--      c:move_to_tag(root.tags()[tag])
--  elseif c.class == "sayonara" then
--      tag = 3
--      c:move_to_screen(root.tags()[tag].screen+1)
--      c:move_to_tag(root.tags()[tag])
--  elseif c.class == "photoshop.exe" then
--      tag = 7
--      c:move_to_screen(root.tags()[tag].screen+1)
--      c:move_to_tag(root.tags()[tag])
--  elseif c.class == "Steam" then
--      tag = 9
--      c:move_to_screen(root.tags()[tag].screen+1)
--      c:move_to_tag(root.tags()[tag])
--  elseif c.class == "REAPER" then
--      tag = 8
--      c:move_to_screen(root.tags()[tag].screen+1)
--      c:move_to_tag(root.tags()[tag])
--  elseif c.class == "discord" then
--      tag = 1
--      c:move_to_screen(1)
--      c:move_to_tag(root.tags()[tag])
--      awful.util.spawn_with_shell("dunstify cum")
    end
    -- i want to replace the c.class here with c.name, but sometimes c.name has spaces and that
    -- causes problems with passing arguments to the workspaces script
    -- i've tried several methods of concatenation and formatting and nothing's worked
    -- im tired and want to go to bed
--  awful.util.spawn_with_shell(scripts_dir .. "workspaces.sh new_win " .. c.class .. " " .. tag)
end)

-- switching to an empty tag on the second screen does not seem to mark it as active in
-- wmctrl's output. i cannot find any way to remedy this.
tag.connect_signal("property::selected", function()
    awful.util.spawn_with_shell(scripts_dir .. "workspaces.sh")
end)
