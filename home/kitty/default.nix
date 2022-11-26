{ config, lib, pkgs, ... }:
let
  theme = builtins.readFile ./earthsong.conf;
in
{
  # Kitty terminal
  # https://sw.kovidgoyal.net/kitty/conf.html
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.kitty.enable
  programs.kitty = {
    enable = true;

    darwinLaunchOptions = [
      "--directory=${config.home.homeDirectory}"
    ];

    settings = {
      scrollback_lines = 50000;
      font_family = "Fira Code";
      font_size = "14.0";
      disable_ligatures = "cursor"; # disable ligatures when cursor is on them

      # Window layout
      # Hiding the decorations looks cool, but prevents dragging windows.
      # If using a window manager religiously, uncomment this.
      #hide_window_decorations = "titlebar-only";
      window_padding_width = "10";

      strip_trailing_spaces = "smart";
      enable_audio_bell = "no";
      macos_titlebar_color = "background";
      macos_option_as_alt = "yes";
      confirm_os_window_close = 1;

      cursor_blink_interval = 0;

      # Tab bar
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_title_template = "Tab {index}: {title}";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
      tab_activity_symbol = "";
    };

    extraConfig = ''
      ${theme}

      ## Keyboard mappings
      map cmd+c        copy_to_clipboard
      map cmd+v        paste_from_clipboard

      # Window management
      map cmd+d         new_window
      map cmd+alt+d     new_window_with_cwd
      map cmd+n         new_os_window
      map cmd+w         close_window
      map cmd+right     next_window
      map cmd+left      previous_window
      map cmd+up        move_window_forward
      map cmd+down      move_window_backward
      map cmd+l         next_layout

      # Tab management
      map cmd+t         new_tab
      map cmd+alt+q     close_tab
      map cmd+alt+right next_tab
      map cmd+alt+left  previous_tab
      map cmd+alt+shift+right  move_tab_forward
      map cmd+alt+shift+left   move_tab_backward
    '';

    #extras.useSymbolsFromNerdFont = "JetBrainsMono Nerd Font";
  };
}
