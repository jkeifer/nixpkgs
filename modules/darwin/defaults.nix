{ ... }: {
  system.defaults.NSGlobalDomain = {
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
    expose-group-by-app = false;
    mru-spaces = false;
    static-only = true;
    show-recents = false;
    tilesize = 32;
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
