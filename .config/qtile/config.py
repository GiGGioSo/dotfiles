# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

## TODO LIST ##
# - Maybe remove Volume from the bar because you already have dunst notifications

## Dotfiles for reference
# - https://github.com/the-argus/rose-pine-dots

from libqtile import bar, layout, widget, hook, qtile
from libqtile.log_utils import logger
from libqtile.config import Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import subprocess
import os

mod = "mod4"
terminal = guess_terminal()
home = os.path.expanduser("~")

SIZE=23

### Pywal COLORS ###
colors = []
cache='/home/gio/.cache/wal/colors'
def load_colors(cache):
    with open(cache, 'r') as file:
        for _ in range(8):
            colors.append(file.readline().strip())
    colors.append('#ffffff')
    lazy.reload()
load_colors(cache)

### Colorful mountain theme ###
colors = [
        "#1f1a24", # black
        "#eb836a", # red
        "#b66ceb", # magenta
        "#82aac2", # cyan
        "#58678c", # blue
        "#c5c8c6", # white
        "#37344a", # light black
        ]

### Start applications on startup ###
@hook.subscribe.startup_once
def autostart():
    subprocess.call([f"{home}/.config/qtile/autostart.sh"])

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key(
        [mod], "space", 
        lazy.group.next_window(), 
        lazy.window.bring_to_front(),
        desc="Move window focus to other window"
        ),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod, "shift"], "b", lazy.hide_show_bar(), desc="Toggle the bar"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawn("rofi -show combi"), desc="Spawn a command using a prompt widget"),
    # Added by me :)
    Key([mod, "control"], "o", lazy.window.toggle_floating(), desc="Toggle to/from floating mode"),
    Key([mod, "control"], "f", lazy.window.toggle_fullscreen(), desc="Toggle to/from fullscreen mode"),
    Key([mod], "g", lazy.spawn("google-chrome-stable"), desc="Launch Google Chrome"),
    Key([mod], "b", lazy.spawn("qutebrowser"), desc="Launch QuteBrowser"),
    Key([mod], "f", lazy.spawn("firefox"), desc="Launch Firefox"),
    Key([mod, "control", "shift"], "l", lazy.spawn("shutdown now"), desc="Shutdown the system"),
    # Sound
    Key([], "XF86AudioMute", lazy.spawn(f"{home}/.local/scripts/volume/volume.sh mute")),
    Key([], "XF86AudioLowerVolume", lazy.spawn(f"{home}/.local/scripts/volume/volume.sh down")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn(f"{home}/.local/scripts/volume/volume.sh up")),
    # Rotate screen
    Key([], "XF86Launch2", lazy.spawn(f"{home}/.local/scripts/screen/rotate_screen.sh"), desc="Rotate the screen"),
    # Screenshot utility
    Key([], "Print", lazy.spawn("flameshot gui"), desc="Screenshot utility"),
    # Toggle touchpad
    Key([mod, "shift"], "t", lazy.spawn(f"{home}/.local/scripts/touchpad_toggle.sh toggle"), lazy.widget["widgetbox"].toggle(), desc="Toggle touchpad"),
    # Color picker
    Key([mod, "shift"], "p", lazy.spawn(f"{home}/.local/scripts/pick_color.sh"), desc="Pick color from the screen"),
]
groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layouts = [
    layout.Columns(
        border_focus=colors[1], 
        border_normal=colors[0],
        border_width=3,
        margin=4,
    ),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(
    #     border_focus=colors[1], 
    #     border_normal=colors[0],
    #     border_width=3,
    # ),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    # font="Hack Nerd Font",
    font="FiraCode Nerd Font Bold",
    fontsize=14,
    padding=2,
    background = colors[0],
)
extension_defaults = widget_defaults.copy()

def separator_widget(foreground_color, background_color=colors[0], separator="\ue0be"):
    return widget.TextBox(
            text=separator,
            font="Anonymous Pro",
            fontsize=SIZE,
            foreground=foreground_color,
            background=background_color,
            padding=-1,
        )

screens = [
    Screen(
        wallpaper = f"{home}/.config/wallpapers/colorful-mountain.png",
        top=bar.Bar(
            [
                widget.GroupBox(
                    inactive=colors[6],
                    active=colors[4],
                    highlight_method="text",
                    hide_unused=False,
                    disable_drag=True,
                    spacing=0,
                    this_current_screen_border=colors[1],
                ),
                widget.Spacer( length = 5 ),
                widget.TaskList(
                    font="FiraCode Nerd Font",
                    icon_size=0,
                    highlight_method="block",
                    border=colors[0],
                    foreground=colors[1],
                    rounded=False,
                    margin=1,
                    max_title_width=400,
                    markup_focused="<b>[{}]</b>",
                    markup_normal="({})",
                ),
                widget.Systray(),
                widget.Spacer(length=5),
                widget.WidgetBox( # make the touchpad-disabled icon appear only when needed
                    font="Anonymous Pro",
                    fontsize=SIZE-1,
                    foreground=colors[1], # color of the next widget
                    text_closed="\ue0be",
                    text_open="",
                    widgets = [
                        separator_widget(colors[4]),
                        widget.Image(
                            filename="/usr/share/icons/Adwaita/48x48/status/touchpad-disabled-symbolic.symbolic.png",
                            background=colors[4],
                            margin=1,
                        ),
                        separator_widget(colors[1], colors[4]),
                    ]
                ),
                widget.CPU(
                    format="CPU:{load_percent}%",
                    background=colors[1],
                ),
                separator_widget(colors[2], colors[1]),
                widget.Memory(
                    format="RAM:{MemUsed:.2f}G",
                    measure_mem='G',
                    background=colors[2],
                    ),
                separator_widget(colors[3], colors[2]),
                widget.Battery(
                    background=colors[3],
                    update_interval=5,
                    format='BATT:{percent:2.0%} WATT:{watt:.1f}'
                ),
                separator_widget(colors[4], colors[3]),
                widget.Volume(
                    fmt="VOL:{}",
                    background=colors[4],
                ),
                separator_widget(colors[1], colors[4]),
                widget.Clock(
                    format="%d-%-m-%Y %-H:%M:%S",
                    background=colors[1],
                ),
            ],
            size=SIZE,
            opacity=1.0,
            margin=[5, 9, 2, 9], # [Up, Right, Down, Left]
            # border_width=[1, 1, 1, 1],  # Draw top and bottom borders
            # border_color=["#82aac2", "#82aac2", "#82aac2", "#82aac2"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), lazy.window.brint_to_front(), start=lazy.window.get_position()),
    Drag([mod, "control"], "Button1", lazy.window.set_size_floating(), start=lazy.window.get_size()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
float_types = [
    "dialog"
]
floating_layout = layout.Floating(
    border_focus=colors[1], 
    border_normal=colors[0],
    border_width=3,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
