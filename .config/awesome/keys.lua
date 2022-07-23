local gears = require("gears")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")

modkey = "Mod4"


-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- directional focus
    awful.key({ modkey }, "Left", function()
        awful.client.focus.global_bydirection("left")
        if client.focus then client.focus:raise() end
    end,
              {description = "focus client left", group = "client"}),
    awful.key({ modkey }, "Down", function()
        awful.client.focus.global_bydirection("down")
        if client.focus then client.focus:raise() end
    end,
              {description = "focus client down", group = "client"}),
    awful.key({ modkey }, "Up", function()
        awful.client.focus.global_bydirection("up")
        if client.focus then client.focus:raise() end
    end,
              {description = "focus client up", group = "client"}),
    awful.key({ modkey }, "Right", function()
        awful.client.focus.global_bydirection("right")
        if client.focus then client.focus:raise() end
    end,
              {description = "focus client right", group = "client"}),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- (directional) Layout manipulation
    awful.key({ modkey, "Shift"   }, "Left", function () awful.client.swap.bydirection("left")    end,
              {description = "swap with client to left", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Down", function () awful.client.swap.bydirection("down")    end,
              {description = "swap with client below", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Up", function () awful.client.swap.bydirection("up")    end,
              {description = "swap with client above", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.bydirection("right")    end,
              {description = "swap with client to right", group = "client"}),

    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program

    -- set terminal in rc.lua (i may move that variable here)
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "e", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- i exclusively use dwindle layout for now these binds mean nothing to me
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next layout", group = "layout"}),
    awful.key({ modkey, "Control", "Shift" }, "space", function () awful.layout.inc(-1)       end,
              {description = "select previous layout", group = "layout"}),
    -- im sorry for ruining the uniformity of this section

    -- this one also means nothing to me having minimized windows in a no-bar environment
    -- doesn't seem like it'd work well. maybe i could figure smth out tho.
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    -- since there's no bar, i need to find a new place for the prompt box.
    -- i think this is also defined in rc.lua
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

    -- rofi launcher
    awful.key({ modkey }, "d", function()
                  awful.util.spawn_with_shell("$HOME/.config/polybar/shades/scripts/launcher.sh")
              end,
              {description = "open launcher", group = "launcher"}),

    -- screenshots
    -- scripts_dir is defined in rc.lua
    awful.key({}, "Print", function()
                  awful.util.spawn_with_shell(scripts_dir .. "screenshot.sh -q")
              end,
              {description = "take screenshot", group = "screenshots"}),
    awful.key({ "Control" }, "Print", function()
                  awful.util.spawn_with_shell(scripts_dir .. "screenshot.sh -s")
              end,
              {description = "take screenshot of region", group = "screenshots"}),
    awful.key({ "Control", "Shift" }, "Print", function()
                  awful.util.spawn_with_shell(scripts_dir .. "screenshot.sh -w")
              end,
              {description = "take screenshot of current active window", group = "screenshots"}),

    -- media keys
    -- the dunstify commands are simply placeholders for now
    awful.key({}, "XF86AudioRaiseVolume", function()
                  awful.util.spawn_with_shell(scripts_dir .. "volume.sh up")
              end,
              {description = "raise volume by 5%", group = "audio"}),
    awful.key({}, "XF86AudioLowerVolume", function()
                  awful.util.spawn_with_shell(scripts_dir .. "volume.sh down")
              end,
              {description = "lower volume by 5%", group = "audio"}),
    awful.key({}, "XF86AudioMute", function()
                  awful.util.spawn_with_shell(scripts_dir .. "volume.sh mute")
              end,
              {description = "toggle mute", group = "audio"}),
    awful.key({ modkey, "Shift" }, "a", function()
                  awful.util.spawn_with_shell("pactl set-source-mute alsa_input.pci-0000_0a_00.3.analog-stereo toggle")
              end,
              {description = "toggle line in mute", group = "audio"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Shift"   }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
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
            local tag = root.tags()[i]
            local screen = tag.screen
            if tag then
                tag:view_only()
                awful.screen.focus(screen)
            end
            awful.util.spawn_with_shell("$HOME/.scripts/workspaces.sh")
        end,
        {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
        function ()
            local tag = root.tags()[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end,
        {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
        function ()
            if client.focus then
                local tag = root.tags()[i]
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
                local tag = root.tags()[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
        end
        end,
        {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end
-- special config for the (1)0th workspace, hidden somewhere within the tag list
globalkeys = gears.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "0",
    function ()
        local tag = root.tags()[10]
        local screen = tag.screen
        if tag then
            tag:view_only()
            awful.screen.focus(screen)
        end
        awful.util.spawn_with_shell("$HOME/.scripts/workspaces.sh")
    end,
    {description = "view tag #0", group = "tag"}),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "0",
    function ()
        local tag = root.tags()[10]
        local screen = tag.screen
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end,
    {description = "toggle tag #0", group = "tag"}),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "0",
    function ()
        if client.focus then
            --local tag = client.focus.screen.tags[10]
            local tag = root.tags()[10]
            local screen = tag.screen
            if tag then
                client.focus:move_to_tag(tag)
                --client.focus:move_to_screen(screen)
            end
        end
    end,
    {description = "move focused client to tag #0", group = "tag"}),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control", "Shift" }, "0",
    function ()
        if client.focus then
            local tag = root.tags()[10]
        local screen = tag.screen
            if tag then
                client.focus:toggle_tag(tag)
            end
    end
    end,
    {description = "toggle focused client on tag #0", group = "tag"})
)

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

root.keys(globalkeys)
