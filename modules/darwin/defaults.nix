{ ... }: {
  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    AppleShowAllExtensions = true;
    AppleShowScrollBars = "Always";
    AppleTemperatureUnit = "Fahrenheit";
    InitialKeyRepeat = 20;
    KeyRepeat = 2;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSNavPanelExpandedStateForSaveMode = true;
    NSNavPanelExpandedStateForSaveMode2 = true;
    "com.apple.sound.beep.feedback" = 0;
    "com.apple.trackpad.scaling" = 0.875;
    "com.apple.trackpad.enableSecondaryClick" = true;
  };

  system.defaults.alf = {
    globalstate = 1;
    allowsignedenabled = 1;
    allowdownloadsignedenabled = 1;
    stealthenabled = 1;
  };

  system.defaults.dock = {
    autohide = true;
    autohide-delay = 100.0;
    expose-group-by-app = false;
    mru-spaces = false;
    orientation = "right";
    static-only = true;
    show-recents = false;
    tilesize = 16;
  };

  system.defaults.loginwindow = {
    GuestEnabled = false;
    DisableConsoleAccess = true;
  };

  system.defaults.spaces.spans-displays = false;

  system.defaults.trackpad = {
    Clicking = false;
    TrackpadRightClick = true;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    _FXShowPosixPathInTitle = true;
    FXEnableExtensionChangeWarning = true;
  };
}
