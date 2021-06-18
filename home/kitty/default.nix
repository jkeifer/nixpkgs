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

    settings = {
      scrollback_lines = 50000;
      font_family = "Fira Code";
      font_size = "14.0";
      disable_ligatures = "cursor"; # disable ligatures when cursor is on them

      # Window layout
      hide_window_decorations = "titlebar-only";
      window_padding_width = "10";

      strip_trailing_spaces = "smart";
      enable_audio_bell = "no";
      macos_titlebar_color = "background";
      macos_option_as_alt = "yes";

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
    '';

    #extras.useSymbolsFromNerdFont = "JetBrainsMono Nerd Font";
  };
}
