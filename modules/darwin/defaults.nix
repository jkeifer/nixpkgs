{ ... }: let
in {
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
    "com.apple.sound.beep.volume" = 0.725;
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

    # hot corners possible values
    # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.dock.wvous-bl-corner
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
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

  system.defaults.CustomUserPreferences = {
    "com.apple.TextEdit" = {
      AddExtensionToNewPlainTextFiles = 0;
      IgnoreHTML = 1;
      RichText = 0;
      SmartQuotes = false;
    };

    "com.apple.WindowManager" = {
      EnableStandardClickToShowDesktop = false;
    };

    # still need to manually disable spotlight keyboard shortcut 😕
    "com.raycast.macos" = {
      raycastGlobalHotkey = "Command-49";
    };

    # maybe needs https://github.com/LnL7/nix-darwin/pull/825 but even that doesn't work
    #"com.if.Amphetamine" = {
    #  "Hide Dock Icon" = 1;
    #  "Icon Style" = 2;
    #  "Trigger Data" = [
    #    {
    #      Enabled = 1;
    #      Name = "Wifi";
    #      SSID = "Othrostichies";
    #      "Screen Saver Delay" = 5;
    #      "Screen Saver Exceptions" = [];
    #      TypeIDs = [
    #        2
    #      ];
    #    }
    #  ];
    #};
  };

  system.activationScripts.postUserActivation.text = ''
    # diable startup sound
    sudo /usr/sbin/nvram StartupMute=%01

    # following line should allow us to avoid a logout/login cycle for most settings
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
